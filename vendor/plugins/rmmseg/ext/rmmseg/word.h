#ifndef _WORD_H_
#define _WORD_H_

#include <climits>
#include <cstring>
#include <cstdio>
#include "memory.h"

namespace rmmseg
{
    const int word_embed_len = 4; /* at least 1 char (3 bytes+'\0') */
    
		struct Word
    {
        unsigned char   nbytes;   /* number of bytes */
        char            length;   /* number of characters */
        int							freq;
        int							cixing;
				char            text[word_embed_len];
    };

    /**
     * text: the text of the word.
     * length: number of characters (not bytes).
     * freq: the frequency of the word.
     */
    inline Word *make_word(const char *text, int length=1,
                           int freq=0, char *cixing=NULL, int nbytes=-1, unsigned long *mem=NULL)
    {
		const int cixing_count = 17;
		const int cixing_codes[cixing_count] = {1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768, 65536}; 
		const char* cixing_symbols[cixing_count] ={"N", "V", "ADJ", "ADV", "CLAS", "ECHO", "STRU", "AUX", "COOR", "CONJ", "SUFFIX", "PREFIX", "PREP", "QUES", "NUM", "IDIOM", "GAME"};
        if (freq > INT_MAX)
            freq = INT_MAX;   /* avoid overflow */
        if (nbytes == -1)
            nbytes = strlen(text);
				*mem += sizeof(Word) + nbytes+ 1 - word_embed_len;
        Word *w = static_cast<Word *>(pool_alloc(sizeof(Word) + nbytes + 1 - word_embed_len));
        w->nbytes = std::strlen(text);
        w->length = length;
        w->freq = freq;
				w->cixing = 0;
				//printf("make word, cixing: [%s]\n", cixing);
				if(cixing){
					char* base=cixing;
					char* cur=base;
					while(*cur != '\0'){
						while(*cur != ',' && *cur != '\0'){
							cur++;
						}
						*cur = '\0';
						for(int i=0;i<cixing_count;i++){
							if(std::strcmp(base, cixing_symbols[i]) == 0){
								w->cixing |= cixing_codes[i];
							}
						}
						base = cur + 1;
						cur = base;
					}
				}
				std::strncpy(w->text, text, nbytes);
        w->text[nbytes] = '\0';
        //printf("text: %s, cixing: %d\n", w->text, w->cixing);
				return w;
    }
}

#endif /* _WORD_H_ */
