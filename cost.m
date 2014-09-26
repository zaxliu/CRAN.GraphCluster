function [C] = cost(nodeName,nodeComp,Adj,seed,clusters,params)
%% Combine multiple costs as a single one (linear)
%  2014.9.2 20:00
    [ C1 ] = costComp(nodeName,nodeComp,Adj,seed,clusters,params);
    [ C2 ] = costFront(nodeName,nodeComp,Adj,seed,clusters,params);
    alpha = 0;  % combining coefficient [0,1]
    C = alpha * C1/6 + (1-alpha) * C2/60;
end

