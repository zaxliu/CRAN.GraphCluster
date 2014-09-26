function [ C ] = costComp( nodeName,nodeComp,Adj,seed,clusters,params )
%% Compute the total computational cost from a clustering scheme
    Nc = max(clusters); % num of clusters is assumed to be equal to the maximum number in var 'clusters'
    c = zeros(Nc,1);
    for n = 1:Nc
        c(n) = sum(nodeComp(clusters==n));
    end
    C = 1.5.^c(1) + c(2);         
end

