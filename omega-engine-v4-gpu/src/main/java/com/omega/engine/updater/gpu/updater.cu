#define BLOCK 1024 
#define ETA 10e-8 

extern "C"
__global__ void adam(float *diffW, float *weight,float *mw,float *vw,float beta1,float beta2,float learnRate, int n, int batch, int t)
{
    int i = (blockIdx.x + blockIdx.y*gridDim.x) * blockDim.x + threadIdx.x;
    if (i >= n) return;
    //float tmp = diffW[i] / batch;
    float tmp = diffW[i];
    mw[i] = beta1 * mw[i] + (1 - beta1) * tmp;
	vw[i] = beta2 * vw[i] + (1 - beta2) * tmp * tmp;
	float mhat = mw[i] / (1 - powf(beta1, t));
	float vhat = vw[i] / (1 - powf(beta2, t));
	weight[i] = weight[i] - learnRate * mhat / (sqrt(vhat) + ETA);
}

extern "C"
__global__ void adamw(float *diffW, float *weight,float *mw,float *vw,float beta1,float beta2,float learnRate, float weight_decay, int n, int batch, int t)
{
    int i = (blockIdx.x + blockIdx.y*gridDim.x) * blockDim.x + threadIdx.x;
    if (i >= n) return;
    //float tmp = diffW[i] / batch;
    float tmp = diffW[i];
    float theta = weight[i] - learnRate * weight_decay * weight[i];
    mw[i] = beta1 * mw[i] + (1 - beta1) * tmp;
	vw[i] = beta2 * vw[i] + (1 - beta2) * tmp * tmp;
	float mhat = mw[i] / (1 - powf(beta1, t));
	float vhat = vw[i] / (1 - powf(beta2, t));
	weight[i] = theta - learnRate * mhat / (sqrt(vhat) + ETA);
}

extern "C"
__global__ void adam_bn(float *diffW, float *weight,float *mw,float *vw,float beta1,float beta2,float learnRate, int n, int t)
{
    int i = (blockIdx.x + blockIdx.y*gridDim.x) * blockDim.x + threadIdx.x;
    if (i >= n) return;
    mw[i] = beta1 * mw[i] + (1 - beta1) * diffW[i];
	vw[i] = beta2 * vw[i] + (1 - beta2) * diffW[i] * diffW[i];
	float mhat = mw[i] / (1 - powf(beta1, t));
	float vhat = vw[i] / (1 - powf(beta2, t));
	weight[i] = weight[i] - learnRate * mhat / (sqrt(vhat) + ETA);
}

extern "C"
__global__ void adamw_bn(float *diffW, float *weight,float *mw,float *vw,float beta1,float beta2,float learnRate, float weight_decay, int n, int t)
{
    int i = (blockIdx.x + blockIdx.y*gridDim.x) * blockDim.x + threadIdx.x;
    if (i >= n) return;
    //float theta = weight[i] - learnRate * weight_decay * weight[i];
    mw[i] = beta1 * mw[i] + (1 - beta1) * diffW[i];
	vw[i] = beta2 * vw[i] + (1 - beta2) * diffW[i] * diffW[i];
	float mhat = mw[i] / (1 - powf(beta1, t));
	float vhat = vw[i] / (1 - powf(beta2, t));
	weight[i] = weight[i] - learnRate * mhat / (sqrt(vhat) + ETA);
}


extern "C"
__global__ void sgd(float *diffW, float *v,float *weight,float momentum,float weight_decay,float learnRate, int n, int batch)
{
    int i = (blockIdx.x + blockIdx.y*gridDim.x) * blockDim.x + threadIdx.x;
    if (i >= n) return;
    //float tmp = (diffW[i] / batch) + weight[i] * weight_decay;
    float tmp = diffW[i] + weight[i] * weight_decay;
    v[i] = v[i] * momentum + tmp;
	weight[i] = weight[i] - learnRate * v[i];
}

extern "C"
__global__ void sgd_bn(float *diffW, float *v,float *weight,float momentum,float weight_decay,float learnRate, int n, int batch)
{
    int i = (blockIdx.x + blockIdx.y*gridDim.x) * blockDim.x + threadIdx.x;
    if (i >= n) return;
    //float tmp = (diffW[i] / batch) + weight[i] * weight_decay;
    float tmp = diffW[i] + weight[i] * weight_decay;
    v[i] = v[i] * momentum + tmp;
	weight[i] = weight[i] - learnRate * v[i];
}