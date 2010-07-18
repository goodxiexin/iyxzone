#ifndef _TOKEN_H_
#define _TOKEN_H_
#include <cstring>
#include <cstdio>
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
        // `text' may or may not be nul-terminated, its length
        // should be stored in the `length' field.
        //
        // if length is 0, this is an empty token
        const char *text;
        int length;
				int freq;
				int cixing;
    };
}

#endif /* _TOKEN_H_ */
