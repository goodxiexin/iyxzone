#include <cstdio>

#include "dict.h"

using namespace std;

namespace rmmseg
{

    struct Entry
    {
        int word_offset;
        int next_offset;
    };

		Entry* next_entry(Entry* entry){
			int offset = entry->next_offset;
			if(offset < 0){
				return NULL;
			}else{
				return (Entry*)TO_ADDR(offset);
			}
		}

		Word* entry_word(Entry* entry){
			int offset = entry->word_offset;
			if(offset < 0){
				return NULL;
			}else{
				return (Word*)TO_ADDR(offset);
			}
		}

    const int init_size = 262147;
    const int max_density = 5;

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

    static int n_offsets = init_size;
		static int n_entries = 0;
		static int *offsets = NULL;

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
						}else{
							if(!rmmseg::shm_inited()){
								perror("shm not inited");
								exit(1);
							}
							offsets = (int*)TO_ADDR(sizeof(int));
						}
				}

        Word *get(const char *str, int len)
        {
            unsigned int h = hash(str, len) % n_offsets;
            Entry *entry = NULL;
						int offset = offsets[h];
						
						if(offset > 0){
							entry = (Entry*)TO_ADDR(offset);
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
            unsigned int h = hash_val % n_offsets;
            Entry *entry = NULL;
						int offset = offsets[h];
						if(offset > 0){
							entry = (Entry*)TO_ADDR(offset);
						}

            if (!entry)
            {
                entry = (Entry*)(shm_alloc(sizeof(Entry)));
                entry->word_offset = TO_OFFSET(word);
                entry->next_offset = -1;
                offsets[h] = TO_OFFSET(entry);
                n_entries++;
            }

            bool done = false;
            do
            {
								Word* eword = entry_word(entry);
                if (word->nbytes == eword->nbytes &&
                    strncmp(word->text, eword->text, word->nbytes) == 0)
                {
                    entry->word_offset = TO_OFFSET(word);
                    done = true;
                    break;
                }
                entry = next_entry(entry);
            }
            while (entry);

            if (!done)
            {
                entry = (Entry*)(shm_alloc(sizeof(Entry)));
                entry->word_offset = TO_OFFSET(word);
                entry->next_offset = offsets[h];
                offsets[h] = TO_OFFSET(entry);
            }
        }

        bool load_chars(const char *filename)
        {
						if(!rmmseg::first_copy())
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
                buf[strlen(buf)-1] = '\0';
                ptr = strchr(buf, ' ');
                if (!ptr)
                    continue;
                *ptr = '\0';
                add(make_word(ptr+1, 1, atoi(buf), NULL, -1));
            }
            fclose(fp);
            return true;
        }

        bool load_words(const char *filename)
        {
						if(!rmmseg::first_copy())
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
                buf[strlen(buf)-1] = '\0';
								ptr = strchr(buf, '\t');
                if (!ptr)
                    continue;
                *ptr = '\0';
								_ptr = strchr(ptr+1, '\t');
								if(!_ptr)
									continue;
								*_ptr = '\0';
                add(make_word(buf, (ptr-buf)/3, atoi(ptr+1), _ptr+1, -1));
            }
            fclose(fp);
            return true;
        }
    }
}
