#ifndef _MEMORY_H_
#define _MEMORY_H_

#include <cstdlib>
#include <stdio.h>

namespace rmmseg
{
		const int SHMSZ = 31248588; //64MB
		extern char* _shm_base;
		extern bool first;

		void *shm_alloc(int len);

		void init_shm();

		bool shm_inited();

		bool first_copy();

}

#endif /* _MEMORY_H_ */
