/*
Tiny snippet to check the possibility of reading two consecutive float values in memory using a single call using float2
*/
#include <cuda_runtime.h>
#include <stdio.h>
__shared__ float a[32];
__global__ void sm_float2_set(){
    int tid = threadIdx.x;
    if(tid % 2 == 0){
        a[tid] = 15;
    }
    else{
        a[tid] = 7;
    }
    printf("%d set value %f", tid, a[tid] );
    __syncthreads();
}

__global__ void sm_float2_get(){
    float2 val = *(float2*)(a+threadIdx.x*2);
    printf("%d got value %f", threadIdx.x, val );
    printf("%d has two vals %f and %f", threadIdx.x, val.x, val.y);
}

int main(int argc, char **argv){
    sm_float2_set<<< 1,32 >>>();
    sm_float2_get<<< 1,16 >>>();
    cudaDeviceReset();
    return 0;
}
