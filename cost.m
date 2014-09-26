function [C] = cost(nodeName,nodeComp,Adj,seed,clusters,params)
%% Combine multiple costs as a single one (linear)
%  2014.9.2 20:00
    [ C1 ] = costComp(nodeName,nodeComp,Adj,seed,clusters,params);
    [ C2 ] = costFront(nodeName,nodeComp,Adj,seed,clusters,params);
    alpha = 1;  % combining coefficient [0,1]
    C = alpha * C1 + (1-alpha) * C2;
end

