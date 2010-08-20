#include "memory.h"
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>

namespace rmmseg
{

		char *_shm_base = NULL;

		bool first = false;

		void init_shm()
		{
			int shmid;
			key_t key;
			void *shm;
			
			key = 5678;

			if ((shmid = shmget(key, SHMSZ, 0666)) < 0) {
				// we are the first
				first = true;

				// create shm
				if ((shmid = shmget(key, SHMSZ, IPC_CREAT | 0666)) < 0) {
					perror("shmget");
					exit(1);
				}
			}

			if ((shm = shmat(shmid, NULL, 0)) == (void*)-1) {
        perror("shmat");
        exit(1);
			}

			_shm_base = (char*)shm;

			if (first) {
				int *sz = (int*)shm;
				*sz = sizeof(int);
				// now shm_alloc can work
			}

		}

		bool shm_inited()
		{
			return (_shm_base != NULL);
		}

		void *shm_alloc(int len)
		{
			int *sz = (int*)_shm_base;
			int remain = SHMSZ - (*sz);
			void *mem = _shm_base + (*sz);

			if(remain >= len)
			{
				(*sz) = (*sz) + len;
				return mem;
			}

			perror("shared memory overflow");
			exit(1);
		}

		bool first_copy()
		{
			return first;
		}

		int shm_usage()
		{
			int *sz = (int*)_shm_base;
			return (*sz);
		}

}
