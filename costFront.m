function [ C ] = costFront(nodeName,nodeComp,Adj,seed,clusters,params )
    Nc = max(clusters); % num of clusters is assumed to be equal to the maximum number in var 'clusters'
    c = zeros(Nc,Nc);
    for i1 = 1:Nc
        nodes1 = (clusters == i1);        
        for i2 = 1:Nc
            nodes2 = (clusters == i2);
            rows = Adj(nodes1,:); cols = rows(:,nodes2);
            c(i1,i2) = sum(cols(:));
        end
    end
    
    C = sum(2.^c(:))-sum(2.^diag(c)); % linear mapping, not including self weigh
end

