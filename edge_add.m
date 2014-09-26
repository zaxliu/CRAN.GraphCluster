function bg = edge_add(bg,Source, Sink, edge_col)
% bg = edge_add(bg,Source, Sink,edge_type)
% Add edge to existing graph. 
% Source and Sink are node IDs
% edge_col defines color of the edge ,[0 0 1](default)
if nargin < 3
    error('function requires at leat graph, source and sink');
elseif nargin == 3
    edge_col = [0 0 1];
end

ed = bg.edges;
to = bg.to;
to(Source,Sink) = length(ed)+1;
bg.to = to;
bg.from = to';
cm(Source,Sink) = 1;
edge_id = ['Node ',num2str(Source),' -> Node ',num2str(Sink)];
h_new = biograph.edge(bg,bg.Nodes(Source),bg.Nodes(Sink),edge_id,cm(Source,Sink),1);
set(h_new,'LineColor',edge_col);
ed = [ed; h_new];
bg.edges = ed;
