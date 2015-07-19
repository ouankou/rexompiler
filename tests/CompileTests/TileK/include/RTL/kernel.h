
#ifndef __TILEK_RTL_KERNEL_H__
#define __TILEK_RTL_KERNEL_H__

struct klt_loop_context_t;

#if defined(TILEK_THREADS)
typedef void (*kernel_func_ptr)(int, int *, void **, void **, struct klt_loop_context_t *);
#else
typedef void (*kernel_func_ptr)(int *, void **, void **, struct klt_loop_context_t *);
#endif

struct kernel_desc_t {
  int num_data;
  int num_param;
  int num_scalar;
  int num_loops;
  int num_tiles;
  struct klt_loop_desc_t * loop_desc;
  kernel_func_ptr kernel_ptr;
};

extern struct kernel_desc_t kernel_desc[]; // Generated by compiler

struct kernel_t {
  struct kernel_desc_t * desc;
  void ** data;
  int   * param;
  void ** scalar;
  struct klt_loop_t * loops;
#if defined(TILEK_THREADS)
  int num_threads;
#elif defined(TILEK_ACCELERATOR)
  int num_gangs[3];
  int num_workers[3];
#endif
};

struct kernel_t * build_kernel(int idx);

void execute_kernel(struct kernel_t * kernel);

#endif /* __TILEK_RTL_KERNEL_H__ */

