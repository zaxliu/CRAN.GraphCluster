function [ C ] = costFront(nodeName,nodeComp,Adj,seed,clusters,params )
%% Compute the total fronthauling cost from a clustering scheme
%  2014.9.2 20:04
    Nc = max(clusters); % num of clusters is assumed to be equal to the maximum number in var 'clusters'
    c = zeros(Nc,Nc);   % bandwidth between cluster pairs (including self cost)
    for i1 = 1:Nc
        nodes1 = (clusters == i1);        
        for i2 = 1:Nc
            nodes2 = (clusters == i2);
            rows = Adj(nodes1,:); cols = rows(:,nodes2);
            c(i1,i2) = sum(cols(:));
        end
    end
    % Mapping:
    %   1) internal links has 0 cost; 
    %   2) links between cell sites (edge links) has 4^BW cost;
    %   3) links between cell site and data center has 2^BW cost
    C = 0;
    for i1 = 1:Nc
        for i2 = 1:Nc
            if i1==i2 % internal links
                continue
            elseif i1~=Nc && i2~=Nc
                C = C + 4^c(i1,i2);
            else
                C = C + 2^c(i1,i2);
            end
        end
    end
end

