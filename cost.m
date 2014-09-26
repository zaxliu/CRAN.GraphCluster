function [C] = cost(nodeName,nodeComp,Adj,path,D,seed,clusters,params)
%% Linearly combine computational cost, fronthauling cost, and delay penalty
%  2014.9.10 17:00
    [C1] = costComp(nodeName,nodeComp,Adj,seed,clusters,params);
    [C2] = costFront(nodeName,nodeComp,Adj,seed,clusters,params);
    [C3] = penaltyDelay(nodeName,nodeComp,Adj,path,D,seed,clusters,params);
    alpha = params.alpha;
    beta = params.beta;
    scaleC1 = params.scaleC1; % combining coefficient [0,1]
    scaleC2 = params.scaleC2; % penalty coefficient
    C = alpha*C1/scaleC1 + (1-alpha)*C2/scaleC2 + beta*C3;
end

