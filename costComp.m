function [ C ] = costComp( nodeName,nodeComp,Adj,seed,clusters,params )
%% Compute the total computational cost from a clustering scheme
%  2014.9.2 20:01
    Nc = max(clusters); % num of clusters is equal to the maximum number in var 'clusters'
    c = zeros(Nc,1);    % complexity in each cluster
    for n = 1:Nc
        c(n) = sum(nodeComp(clusters==n));
    end
    C = sum(2.^c(1:(Nc-1))) + 0; % mapping: distributed site has exponential cost, data center has 0 cost
end

