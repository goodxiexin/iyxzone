#ifndef _DICT_H_
#define _DICT_H_

#include "word.h"

namespace rmmseg
{

		namespace dict
    {
				void	init();
        void  add(Word *word);
        bool  load_chars(const char *filename);
        bool  load_words(const char *filename);
        Word *get(const char *str, int len);
    }
}

#endif /* _DICT_H_ */
