%*************************************************************************
% Scalable spectral clustering based on random binning and primme
%
% Author: Lingfei Wu
% Date: 01/16/2019
%*************************************************************************

clear,clc
format shorte
addpath(genpath('./utilities'));
file_dir = './datasets/';
filename_list = {'pendigits'};

normalize_laplacian_flag = 1; % 1) 1:normalized laplacian; 2) 0:laplacian
R_list = [16 32 64 128 256]; % increasing R typically improve performance
sigma_list = [];
for jj = 1:length(filename_list)
    info = [];
    filename = filename_list{jj};
    disp(filename);
    if strcmp(filename, 'pendigits')
        KERNEL = 1; % Laplacian Kernel
        sigma = 0.39; % For other dataset, tune it for best performance
    end
    
    Accu_best_list = zeros(4,length(R_list));
    telapsed_rb_gen_list = zeros(1,length(R_list));
    telapsed_laplacian_eigen_list = zeros(1,length(R_list));
    telapsed_kmeans_list = zeros(1,length(R_list));
    telapsed_runtime_list = zeros(1,length(R_list));
    for j = 1:length(R_list)
        R = R_list(j);
        fprintf('R = %d\n',R);
    
        % load train and test feature data, A := Z * Z', Z is a N*R feature
        % matrix to approximate adjacency matrix A of a fully connected graph 
        timer_start = tic;
        file_path = strcat(file_dir,'/',filename,'.train.test');
        [Y, X] = libsvmread(file_path);
        [OFFSET, COOR, DELTA, MU, Z] = rb_train(X, KERNEL, sigma, R);
        labels = unique(Y);
        numClasses = length(labels);
        if numClasses > 2
            for i=numClasses:-1:1
                ind = (Y == labels(i));
                Y(ind) = i;
            end
        else
            ind = (Y == labels(1));
            Y(ind) = 2;
            ind = (Y == labels(2));
            Y(ind) = 1;
        end
        telapsed_rb_gen = toc(timer_start);
        telapsed_rb_gen_list(j) = telapsed_rb_gen;

        % compute degree diagonal matrix D := A * 1 = Z * (Z' * 1)
        N = size(Z,1);
        ZT1 = Z'*ones(N,1);
        ZZT1 = Z*ZT1;
        D = spdiags([ZZT1], 0, N, N);

        % Two ways to implicitly formulate laplacian: 
        % 1) L = D - A = D - Z*Z'; 
        % 2) L = I - sqrt(inv(D))*A*sqrt(inv(D)) 
        %      = I - sqrt(inv(D))*Z*Z'*sqrt(inv(D))
        timer_start = tic;
        K = length(unique(Y));
        opts.tol = 1e-4;
        opts.disp = 1;
        opts.isreal = 1;
        if normalize_laplacian_flag == 0
            [U,S] = primme_eigs(@(x)Lap_Afun(x,Z,D),N,K,'SA',opts);
        else
            Z2 = sqrt(inv(D))*Z;
            [U,S,V] = primme_svds(Z2,K,'L',opts);
        end
        telapsed_laplacian_eigen = toc(timer_start);

        % apply kmeans on resulting latent embedding from eigen
        timer_start = tic;
        U2 = zeros(size(U));
        for i=1:size(U,1)
            U2(i,:) = U(i,:)./norm(U(i,:));
        end
        kopts = statset('Display','final');
        rng('default');
        [IDX, C] = kmeans(real(U2),K,'Distance','sqeuclidean',...
            'Replicates',10,'Options',kopts); % 'cityblock'
        telapsed_kmeans = toc(timer_start);
        [nmi,fm,RI] = clustering_metric(0,Z,IDX,Y);
        accu = accuracy(IDX, Y)/100; % Calculate accuracy
        Accu_best_list(:,j) = [nmi;fm;accu;RI];
        telapsed_laplacian_eigen_list(j) = telapsed_laplacian_eigen;
        telapsed_kmeans_list(j) = telapsed_kmeans;
        telapsed_runtime_list(j) = telapsed_rb_gen + ...
            telapsed_laplacian_eigen + telapsed_kmeans;  
    end
    
    info.Accu_best = Accu_best_list;
    info.singvalue = diag(S);
    info.telapsed_rb_gen = telapsed_rb_gen_list;
    info.telapsed_laplacian_eigen = telapsed_laplacian_eigen_list;
    info.telapsed_kmeans = telapsed_kmeans_list;
    info.telapsed_runtime = telapsed_runtime_list;
    info.R = R_list;
    info.sigma = sigma;
    disp(info);
    savefilename = [filename '_SC_RB_varyingR'];
    save(savefilename,'info')
end