function [ profile ] = resultProfiling( clusters,nodeName,params )
%% Analyze and visualize the clustering result
%  2014.9.10 22:12
    nodeType = params.nodeType;
    numType = numel(nodeType);
    numClusters = max(clusters(:));
    profile = zeros(numType,numClusters);
    for typeIndex = 1:numType % for each type
        idCurrentType = cellfun(@(x) ~isempty(strfind(x,nodeType{typeIndex}))...
            &&(strfind(x,nodeType{typeIndex})==1), nodeName); % find nodes of this type
        for clusterIndex = 1:numClusters % for each cluster
            tmp = clusters(idCurrentType,:); tmp = tmp(:);
            profile(typeIndex,clusterIndex) = sum(tmp==clusterIndex); % count the number of this type in this culster
        end
    end
end

