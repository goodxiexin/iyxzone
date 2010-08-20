#include <cstdio>

#include "dict.h"

using namespace std;

int dict_mem;

namespace rmmseg
{

    struct Entry
    {
        int word_offset;//Word *word;
        int next_offset; //下一个的偏移量，从_shm_base开始算Entry *next;
    };

		Entry* next_entry(Entry* entry){
			int offset = entry->next_offset;
			if(offset < 0){
				return NULL;
			}else{
				return (Entry*)(_shm_base + offset);
			}
		}

		Word* entry_word(Entry* entry){
			int offset = entry->word_offset;
			if(offset < 0){
				return NULL;
			}else{
				return (Word*)(_shm_base + offset);
			}
		}

    const int init_size = 262147;
    const int max_density = 5;
    /*
      Table of prime numbers 2^n+a, 2<=n<=30.
    */
    static int primes[] = {
        524288 + 21,
        1048576 + 7,
        2097152 + 17,
        4194304 + 15,
        8388608 + 9,
        16777216 + 43,
        33554432 + 35,
        67108864 + 15,
        134217728 + 29,
        268435456 + 3,
        536870912 + 11,
        1073741824 + 85,
    };


    //static int n_bins = init_size;
    static int n_offsets = init_size;
		static int n_entries = 0;
		static int *offsets = NULL;
    //static Entry **bins = NULL;

    static unsigned int hash(const char *str, int len)
    {
        unsigned int key = 0;
        while (len--)
        {
            key += *str++;
            key += (key << 10);
            key ^= (key >> 6);
        }
        key += (key << 3);
        key ^= (key >> 11);
        key += (key << 15);
        return key;
    }

    namespace dict
    {

				void init()
				{
						if(rmmseg::first_copy()){
							offsets = (int*)(shm_alloc(init_size * sizeof(int)));
							for(int i=0;i<init_size;i++){
								offsets[i] = -1;
							}
							//bins = static_cast<Entry **>(shm_alloc(init_size * sizeof(Entry *)));
						}else{
							if(!rmmseg::shm_inited()){
								perror("shm not inited");
								exit(1);
							}
							offsets = (int*)(_shm_base + sizeof(int));
							printf("海涛, offset: %d\n", offsets[142939]);
							//bins = static_cast<Entry **>(static_cast<void*>(_shm_base + sizeof(int)));
						}
				}

        /**
         * str: the base of the string
         * len: length of the string (in bytes)
         *
         * str may be a substring of a big chunk of text thus not nul-terminated,
         * so len is necessary here.
         */
        Word *get(const char *str, int len)
        {
            unsigned int h = hash(str, len) % n_offsets;//n_bins;
            Entry *entry = NULL;//bins[h];
						int offset = offsets[h];
						printf("h: %d, offset: %d\n", h, offsets[h]);
						if(offset > 0){
							entry = (Entry*)(_shm_base + offset);
						}
            if (!entry)
                return NULL;
            do
            {
								Word* word = entry_word(entry);
                if (len == word->nbytes &&
                    strncmp(str, word->text, len) == 0){
                    return word;
								}
                entry = next_entry(entry);
            }
            while (entry);

            return NULL;
        }

        void add(Word *word)
        {
            unsigned int hash_val = hash(word->text, word->nbytes);
            unsigned int h = hash_val % n_offsets;//n_bins;
            Entry *entry = NULL; //bins[h];
						int offset = offsets[h];
						if(offset > 0){
							entry = (Entry*)(_shm_base + offset);
						}

            if (!entry)
            {
                entry = (Entry*)(shm_alloc(sizeof(Entry)));
                entry->word_offset = (char*)word - _shm_base;
                entry->next_offset = -1; //next = NULL;
                offsets[h] = (char*)entry - _shm_base;
						printf("h: %d, offset: %d\n", h, offsets[h]);
								//bins[h] = entry;
                n_entries++;
            }

            bool done = false;
            do
            {
								Word* eword = entry_word(entry);
                if (word->nbytes == eword->nbytes &&
                    strncmp(word->text, eword->text, word->nbytes) == 0)
                {
                    entry->word_offset = (char*)word - _shm_base;
                    done = true;
                    break;
                }
                entry = next_entry(entry);//entry->next;
            }
            while (entry);

            if (!done)
            {
                entry = (Entry*)(shm_alloc(sizeof(Entry)));
                entry->word_offset = (char*)word - _shm_base;
                entry->next_offset = offsets[h];//bins[h];
                offsets[h] = (char*)entry - _shm_base; //bins[h] = entry;
            }
        }

        bool load_chars(const char *filename)
        {
						if(!first)
							return false;

            FILE *fp = fopen(filename, "r");
            if (!fp)
            {
                return false;
            }

            const int buf_len = 24;
            char buf[buf_len];
            char *ptr;
					            
						while(fgets(buf, buf_len, fp))
            {
                // NOTE: there SHOULD be a newline at the end of the file
                buf[strlen(buf)-1] = '\0';    // truncate the newline
                ptr = strchr(buf, ' ');
                if (!ptr)
                    continue;       // illegal input
                *ptr = '\0';
                add(make_word(ptr+1, 1, atoi(buf), NULL, -1));
            }
            fclose(fp);
            return true;
        }

        bool load_words(const char *filename)
        {
						if(!first)
							return false;

            FILE *fp = fopen(filename, "r");
            if (!fp)
            {
                return false;
            }
            const int buf_len = 128;
            char buf[buf_len];
            char *ptr;
						char *_ptr;
            
						while(fgets(buf, buf_len, fp))
            {
                // NOTE: there SHOULD be a newline at the end of the file
                buf[strlen(buf)-1] = '\0';    // truncate the newline
								ptr = strchr(buf, '\t');
                if (!ptr)
                    continue;       // illegal input
                *ptr = '\0';
								_ptr = strchr(ptr+1, '\t');
								if(!_ptr)
									continue; //illegal input
								*_ptr = '\0';
                add(make_word(buf, (ptr-buf)/3, atoi(ptr+1), _ptr+1, -1));
            }
            fclose(fp);
            return true;
        }
    }
}
