# SpectralClustering_RandomBinning
SpectralClustering_RandomBinning (SC_RB) is a simple code for scaling up spectral clustering on large-scale datasets using state-of-the-art kernel approximation (Random Binning) and eigenvalue and singular value solver (PRIMME).

This code is a simple implementation (mix of Matlab, Matlab MEX, and C) of the WME in (Wu et al, "Scalable Spectral Clustering Using Random Binning Features", KDD'18). We refer more information about SC_RB to the following paper link: https://arxiv.org/abs/1805.11048 and the IBM Research AI Blog: https://www.ibm.com/blogs/research/2018/08/spectral-clustering/.


# Prerequisites

There are three required tool packages in order to run this code. You need to download RB, PRIMME, and LibSVM and compile the corresponding MEX files for your operating systems (Mac, Linux, or Windows).

For RB: https://github.com/teddylfwu/RB_GEN <br/>
For PRIMME: https://github.com/primme/primme <br/>
For LibSVM: https://github.com/cjlin1/libsvm <br/>

You will also need to download the datasets that are in libsvm format. Since this is the clustering task, you need to merge training and testing datasets into one file. You can download them from this link: https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/datasets/


# How To Run The Codes
Note that, in order to achieve the best performance, the hyper-parameter sigma (for generating a good kernel approximation matrix Z) has to be searched (using cross validation or other techniques). This is a crucial step for SC_RB.  

To generate the WME for your NLP applications, you need:

(1) If you use linux and Mac, you should be fine to skip compiling MEX for RB, PRIMME, and LibSVM. Otherwise, you need to download them form the above links and compile them in their Matlab folders. Then you need copy these MEX files into the utilities folder.

(2) Open Matlab terminal console and run specClustering_rb_example.m for getting clustering performance for example dataset pendigits. You might want to check if your results are consistent with them in pendigits_SC_RB_varyingR_exampleResults.mat.


# How To Cite The Codes
Please cite our work if you like or are using our codes for your projects! Let me know if you have any questions: lwu at email.wm.edu.

Lingfei Wu, Pin-Yu Chen, Ian En-Hsu Yen, Fangli Xu, Yinglong Xia and Charu Aggarwal, "Scalable Spectral Clustering Using Random Binning Features", KDD'18.

@InProceedings{wu2018scalable, <br/>
  title={Scalable Spectral Clustering Using Random Binning Features}, <br/>
  author={Wu, Lingfei and Chen, Pin-Yu and Yen, Ian En-Hsu and Xu, Fangli and Xia, Yinglong and Aggarwal, Charu}, <br/>
  booktitle={Proceedings of the 24th ACM SIGKDD International Conference on Knowledge Discovery & Data Mining}, <br/>
  year={2018} <br/>
}


------------------------------------------------------
Contributors: Lingfei Wu <br/>
Created date: January 16, 2019 <br/>
Last update: January 16, 2019 <br/>
