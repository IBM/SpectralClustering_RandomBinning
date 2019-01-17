function [normalized_cut]=compute_normalized_cut(A,s);

K=max(s);
n=size(A,1);
for k=1:K
    ind_in=find(s==k);
    ind_out=setdiff(1:n,ind_in);
    Ain=A(ind_in,ind_in');
    Aout=A(ind_in,ind_out');
    twoms=sum(nonzeros(Ain));
    cs=sum(nonzeros(Aout));
    if(twoms==0)
        conductance(k)=0;
    else
        conductance(k)=cs/(cs+twoms);
    end
    twom=sum(nonzeros(A));
    
    if(twom==0|cs==0)
        normalized_cut(k)=conductance(k);
    else
        normalized_cut(k)=conductance(k)+cs/(twom-twoms+cs);
    end
end