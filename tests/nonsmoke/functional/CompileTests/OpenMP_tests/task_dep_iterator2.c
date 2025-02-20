#include<stdio.h>

void set_an_element(int*p, int val) {
    *p = val;
}

void print_all_elements(int*v, int n) {
    int i;
    for (i = 0; i < n; ++i) {
        printf("%d, ", v[i]);
    }
    printf("\n");
}

void parallel_computation(int n) {
    int v[n];
    #pragma omp parallel
    #pragma omp single
    {   
        int i;
        for (i = 0; i < n; ++i)
        #pragma omp task depend(out: v)
        set_an_element(&v[i], i);
        
        #pragma omp task depend(iterator(it = 0:n), in: v)
        print_all_elements(v, n);
        
    }
        
}
