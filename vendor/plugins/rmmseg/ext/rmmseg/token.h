#ifndef _TOKEN_H_
#define _TOKEN_H_
#include <cstring>

namespace rmmseg
{
    struct Token
    {
        Token(const char *txt, int len, int frq, int cx){
					text = txt;
					length = len;
					freq = frq;
					cixing = cx;
				}
        
				const char *text;
        int length;
				int freq;
				int cixing;
    };
}

#endif /* _TOKEN_H_ */
