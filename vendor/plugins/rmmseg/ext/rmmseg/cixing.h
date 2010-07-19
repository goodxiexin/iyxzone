#ifndef _CIXING_H_
#define _CIXING_H_

/*
 * 词性用一个integer表示
 * 每一位代表一种词性
 * 总共可以支持３２种词性，目前使用的有１７种
 */

#define CX_UNKNOWN(x)	(x == 0)
#define CX_NOUN(x)		((x & 0x00000001) == 0x00000001)
#define CX_VERB(x)		((x & 0x00000002) == 0x00000002)
#define CX_ADJ(x)			((x & 0x00000004) == 0x00000004)
#define CX_ADV(x)			((x & 0x00000008) == 0x00000008)
#define CX_CLAS(x)		((x & 0x00000010) == 0x00000010)
#define CX_ECHO(x)		((x & 0x00000020) == 0x00000020)
#define CX_STRU(x)		((x & 0x00000040) == 0x00000040)
#define CX_AUX(x)			((x & 0x00000080) == 0x00000080)
#define CX_COOR(x)		((x & 0x00000100) == 0x00000100)
#define CX_CONJ(x)		((x & 0x00000200) == 0x00000200)
#define CX_SUFFIX(x)	((x & 0x00000400) == 0x00000400)
#define CX_PREFIX(x)	((x & 0x00000800) == 0x00000800)
#define CX_PREP(x)		((x & 0x00001000) == 0x00001000)
#define CX_QUES(x)		((x & 0x00002000) == 0x00002000)
#define CX_NUM(x)			((x & 0x00004000) == 0x00004000)
#define CX_IDIOM(x)		((x & 0x00008000) == 0x00008000)
#define CX_GAME(x)		((x & 0x00010000) == 0x00010000)

#define CX_TYPE(x)

namespace rmmseg
{
		const int cixing_count = 17;

		const int cixing_codes[cixing_count] = {0x0000001, 0x0000002, 0x00000004, 0x00000008, 0x00000010, 0x00000020, 0x00000040, 0x00000080, 0x00000100, 0x00000200, 0x00000400, 0x00000800, 0x00001000, 0x00002000, 0x00004000, 0x00008000, 0x00010000};

		const char cixing_symbols[cixing_count][10] ={"N", "V", "ADJ", "ADV", "CLAS", "ECHO", "STRU", "AUX", "COOR", "CONJ", "SUFFIX", "PREFIX", "PREP", "QUES", "NUM", "IDIOM", "GAME"};

		inline int parse_cixing(char* cixing){
			int ret = 0;

			if(cixing){
				char* base = cixing;
				char* cur = base;
				while(*cur != '\0'){
					while(*cur != ',' && *cur != '\0'){
						cur++;
					}
					*cur = '\0';
					for(int i=0;i<cixing_count;i++){
						if(std::strcmp(base, cixing_symbols[i]) == 0){
							ret |= cixing_codes[i];
						}
					}
					base = cur + 1;
					cur = base;
				}
			}
	
			return ret;
		}
}

#endif
