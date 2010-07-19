#ifndef _WORD_H_
#define _WORD_H_

#include <climits>
#include <cstring>
#include "memory.h"
#include "cixing.h"

namespace rmmseg
{
    const int word_embed_len = 4; /* at least 1 char (3 bytes+'\0') */
 
		/*
		 * 词性和词频不是必须的
		 * 当没有的时候就用0代替
		 */ 
		struct Word
    {
        unsigned char   nbytes;
        char            length;
        int							freq;
        int							cixing;
				char            text[word_embed_len];
    };

    inline Word *make_word(const char *text, int length=1,
                           int freq=0, char *cixing=NULL, int nbytes=-1)
    {
				if (freq > INT_MAX)
            freq = INT_MAX;   /* avoid overflow */
        if (nbytes == -1)
            nbytes = strlen(text);
        
				Word *w = static_cast<Word *>(pool_alloc(sizeof(Word) + nbytes + 1 - word_embed_len));
        
				w->nbytes = std::strlen(text);
        w->length = length;
        w->freq = freq;
				
				// parse cixng
				w->cixing = parse_cixing(cixing); 
		
				std::strncpy(w->text, text, nbytes);
        w->text[nbytes] = '\0';
				return w;
    }
}

#endif /* _WORD_H_ */
