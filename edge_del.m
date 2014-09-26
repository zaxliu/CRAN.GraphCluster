function bg = edge_del(bg, SourceInd, SinkInd)
% bg = edge_del(bg, SourceInd, SinkInd)
% Delete selected edge from graph
% SourceInd, SinkInd are node IDs
if nargin < 3
    error('function requires at leat graph, source and sink');
elseif nargin > 3
    error('edge_del requires exactly 3 arguments');
end

to = full(bg.to);
edge_id = to(SourceInd,SinkInd);
to(SourceInd,SinkInd)=0;
bg.edges(edge_id) = [];
[x,y] = find(to>edge_id);
for i = 1:length(x)
    if to(x(i),y(i)) >edge_id
        to(x(i),y(i)) = to(x(i),y(i))-1;
    end
end
bg.to = sparse(to);
bg.from = to';