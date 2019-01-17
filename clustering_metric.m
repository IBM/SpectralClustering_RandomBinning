function [nmi,fm,RI,conduc,NC,ODF]=clustering_metric(flag_ext,A,s,s_true)
% Outputs:
% 1. NMI
% 2. fm - F-measure
% 3. RI - rand index 
% These three are measures given groundtruth labels
% 
% 4. conduc = conductance
% 5. NC - normalized cut
% 6. ODF - out-degree fraction
% 
% Input: 
% 
% flag_ext=0 - compute 1-3
% flag_ext=1 - compute 4-6  
% flag_ext=2 - compute 1-6
% 
% A: symmetric n-by-n weight matrix (sparse format supported)
% s: cluster label of each node from an algorithm. Every entry should be 
% between 1 to K, where K is the number of clusters (For MNist, K=10)
% s_true: gound-truth cluster label


if(flag_ext == 0 || flag_ext == 2)
    % Rand Index
    [AR,RI,MI,HI]=RandIndex(s_true,s);
    % f-measure
    fm=-1;
    p=-1;
    r=-1;
    [fm,p,r] = compute_f(s_true,s);
    % NMI
    [dummy,nmi,avgent] = compute_nmi(s_true,s);
else
    nmi=-1;
    fm=-1;
    RI=-1;
end

if(flag_ext == 1 || flag_ext == 2)
    % conductance
    conductance=compute_conductance(A,s);
    conduc=sum(conductance)/max(s);

    % normalized cut 
    NCtmp=compute_normalized_cut(A,s);
    NC=sum(NCtmp)/max(s);

    % average ODF
    K=max(s); d=sum(A,2);
    for k=1:K
        ind=find(s==k);
        d_in=sum(A(ind,ind),2);
        tmp(k)=(sum(1-d_in./d(ind)))/length(ind);
    end
    ODF=sum(tmp)/k;
else
    conduc=-1;
    NC=-1;
    ODF=-1;
end