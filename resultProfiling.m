function [ profile ] = resultProfiling( clusters,nodeName,params )
%% Analyze and visualize the clustering result
    nodeType = params.nodeType;
    numType = numel(nodeType);
    M = max(clusters(:));
    profile = zeros(numType,M);
    for n = 1:numType
        index = cellfun(@(x) ~isempty(strfind(x,nodeType{n}))...
            &&(strfind(x,nodeType{n})==1), nodeName);
        for m = 1:M
            tmp = clusters(index,:); tmp = tmp(:);
            profile(n,m) = sum(tmp==m);
        end
    end
end

