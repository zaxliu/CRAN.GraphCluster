function bg = node_del(bg,NodeID)
% Delete node from graph. Also deletes all edges connected to the node.
% bg - graph object
% NodeID - id of node to delete


if ~bg.isLaidout
    dolayout(bg);
end

if ischar(NodeID)
    node_ind = find(ismember(get(bg.Nodes,'ID'),NodeID));
else
    node_ind = NodeID;
end

to = full(bg.to);
edge_id = sort([nonzeros(to(:,node_ind));nonzeros(to(node_ind,:))],'descend');
bg.edges(edge_id) = [];
to(node_ind,:)=[];
to(:,node_ind) = [];
[x,y] = find(to);
for i = 1:length(edge_id)
    for j = 1:length(x)
        if (to(x(j),y(j))>edge_id(i))
            to(x(j),y(j))=(to(x(j),y(j)))-1;
        end
    end
end
bg.Nodes(node_ind) = [];
bg.to = sparse(to);
bg.from = sparse(to');
for i = 1:length(bg.Nodes)
    bg.Nodes(i).ID = num2str(i);
end

