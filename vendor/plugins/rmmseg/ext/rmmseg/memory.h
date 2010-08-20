#ifndef _MEMORY_H_
#define _MEMORY_H_

#include <cstdlib>
#include <stdio.h>

#define TO_ADDR(x) (_shm_base + x)
#define TO_OFFSET(x) ((char*)x - _shm_base)

namespace rmmseg
{
		const int SHMSZ = 134217728; //64MB

		extern char* _shm_base;

		extern bool first;

		void *shm_alloc(int len);

		void init_shm();

		bool shm_inited();

		bool first_copy();

		int shm_usage();

}

#endif /* _MEMORY_H_ */
