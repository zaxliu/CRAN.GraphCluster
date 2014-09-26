function [mutationChild] = mutation_gb(parents,Con,seed)
    mutationChild = zeros(size(parents));
    clusterCon = Con.*repmat(seed,size(parents,1),1);
    for i = 1:numParents
        mutationParent = parents(i,:);   % extract parent for mutation
        mutationIndex  = rand(size(parent,2))>0.8;  % decide the mutation position
        for j = 1:size(parent,2)            
            if mutationIndex(j) == 1    % if decide to mutate
                tmp = unique(clusterCon(j,:));  % find unique connected clusters
                tmp = tmp(2:end);               % discard cluster 0
                index = randi(length(tmp),1);   % randomly select a cluster
                mutationParent(j) = tmp(index); % change the position to that cluster
            end
        end
        mutationChild(i,:) = mutationParent;
    end
end