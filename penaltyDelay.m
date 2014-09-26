function [P] = penaltyDelay(nodeName,nodeComp,Adj,paths,delayBound,seed,clusters,params)
%% This function calculates the delay penalty basing on path and cluster information
%  2014.9.10 21:11
%% Calculate complexity in each cluster
%  because delay penalty is related with the sum complexity of the clusters
%  that paths go through
    Nc = max(clusters); % num of clusters is equal to the maximum number in var 'clusters'
    clusterComp = zeros(Nc,1);    % complexity in each cluster
    for n = 1:Nc
        clusterComp(n) = sum(nodeComp(clusters==n));
    end
%% Iterate through all paths to calculate the sum delay penalty
    P = 0;  % sum penalty initailized to be 0
    % iterate through all paths
    for i = 1:numel(paths)
        currentPath = paths{i};
        currentDelay = 0;  % delay penalty on current path is initialized to be 0
        for j = 1:length(currentPath)
            currentDelay = currentDelay + nodeDelay(currentPath(j),nodeComp,clusterComp,clusters);
        end
        currentBound = delayBound(i);
        P = P + (currentDelay-currentBound)*((currentDelay-currentBound)>0);  % delay causes penalty only when it violates the delay bound 
    end    
end
%% Subfunction to compute delay penalty on each node
function [d] = nodeDelay(idx,nodeComp,clusterComp,clusters)
    clusterFactor = clusterComp(clusters(idx));
    if clusters(idx) == max(clusters)
        clusterFactor(end) = 1; % centralization place do not impose additional delay penalty
    end
    d = nodeComp(idx)*clusterFactor;
end
