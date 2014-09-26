function [ nodeName,nodeComp,Adj,paths,delayBound,seed,Con] = init( params )
%% Initializing a graph basing on creation rules
%  2014.9.10 21:28
%% Initialization
nodeName = cell(params.chainNum*sum(params.nodeNum),1); % name of each node
nodeComp = zeros(length(nodeName),1);   % computational complexity of each node
Adj = zeros(length(nodeName),length(nodeName)); % adjacency matrix
paths = {}; % all paths in the graph (number not known now)
delayBound = [];    % delay bound for each path
seed = zeros(size(nodeName));   % seeding vector
%% Node naming and weighting
%  Composed of mutiple chains, finite node type. Naming format:
%  Type.Chain#.Node#
nodeIndex = 1;
for indexChain = 1:params.chainNum % chain loop
    for indexType = 1:numel(params.nodeType) % node type loop
        if params.nodeNum(indexType)~=0
            for indexNode = 1:params.nodeNum(indexType) % each type in a single chain
                nodeName{nodeIndex} = [params.nodeType{indexType},'.',num2str(indexChain),'.',num2str(indexNode)];
                nodeComp(nodeIndex) = params.nodeComp(indexType);
                nodeIndex = nodeIndex + 1;
            end
        end
    end
end

%% Initialize links
for indexChain = 1:params.chainNum
    for il = 1:numel(params.linkRule1)
        [C]= textscan(params.linkRule1{il},'%s%s%s','delimiter', ',');
        type1 = C{1}{1}; type2 = C{2}{1}; rule = C{3}{1};
        idx1 = cellfun(@(x) ~isempty(strfind(x,[type1,'.',num2str(indexChain)]))...
            &&(strfind(x,[type1,'.',num2str(indexChain)])==1), nodeName);
        idx2 = cellfun(@(x) ~isempty(strfind(x,[type2,'.',num2str(indexChain)]))...
            &&(strfind(x,[type2,'.',num2str(indexChain)])==1), nodeName);  
        % Rules
        if strcmp(rule,'one2all') % one to all
            Adj(find(idx1,1,'first'),idx2) = params.linkWeight1(il);
        elseif strcmp(rule,'one2one') % one to one
            I1 = find(idx1); I2 = find(idx2);
            for nodeIndex = 1:length(I1)
                Adj(I1(nodeIndex),I2(nodeIndex)) = params.linkWeight1(il);
            end
        elseif strcmp(rule,'all2one') % all to one
            Adj(idx1,find(idx2,1,'first')) = params.linkWeight1(il);
        end
    end
end
%% Initialize cluster seeds
% seeding rule1
currentSegment = 1;
for indexChain = 1:params.chainNum
    for is = 1:numel(params.seedRule1)
        C= textscan(params.seedRule1{is},'%d%s','delimiter', '|');
        N = C{1}; extendSegments = C{2}{1};
        C = textscan(extendSegments,'%s',N,'delimiter', ',');
        for indexNode = 1:N
            type1 = C{1}{indexNode};
            idx1 = cellfun(@(x) ~isempty(strfind(x,[type1,'.',num2str(indexChain)]))...
            &&(strfind(x,[type1,'.',num2str(indexChain)])==1), nodeName);
            seed(idx1) = currentSegment;
        end
        currentSegment = currentSegment + 1;
    end
end
% seeding rule2
for is = 1:numel(params.seedRule2)
    C= textscan(params.seedRule2{is},'%d%s','delimiter', '|');
    N = C{1}; extendSegments = C{2}{1};
    C = textscan(extendSegments,'%s',N,'delimiter', ',');
    for indexNode = 1:N
        type1 = C{1}{indexNode};
        idx1 = cellfun(@(x) ~isempty(strfind(x,type1))...
        &&(strfind(x,type1)), nodeName);
        seed(idx1) = currentSegment;
    end
    currentSegment = currentSegment + 1;
end
%% Initialize paths and delay bound
buffer = [];
sourceCounter = 0;
% Find all source nodes
for nodeIndex = 1:length(seed) % iterate through all nodes
    if all(Adj(:,nodeIndex)==0) % chech if is source
        sourceCounter = sourceCounter + 1;
        buffer{sourceCounter} = nodeIndex; % add source to buffer
    end
end
% Recursion-based depth first search to find all source-sink paths
while(~isempty(buffer))
    currentSegment = buffer{1};    % pop out top segment in buffer
    extendSegments = {};    % all segments extended from current segment
    for nodeIndex = 1:length(seed)  % for each node
        % if current segment is connected with this node and no cycles,
        % then check the expanded segment
        if Adj(currentSegment(end),nodeIndex)~=0 && ~any(currentSegment == nodeIndex)
            if all(Adj(nodeIndex,:)==0) % if this node is sink
                paths = [paths,[currentSegment,nodeIndex]]; % find a path, store it
            else % yet another expansion
                extendSegments = [extendSegments, [currentSegment,nodeIndex]]; % push this extended segment into stack
            end
        end
    end
    if numel(buffer)~=1
        buffer = [extendSegments,buffer(2:end)]; % push all extended segments into buffer
    else
        buffer = [];
    end
    % while again
end
% Assignt path delay bound according to source and sink
delayBound = 100*ones(1,numel(paths));
%% Find the connection matrix
    Con = zeros(size(Adj));
    Exp = 1; % exponentials of A (0-th)
    for n = 1:size(Adj,1)   % a node can reach any connected node within N-1 steps (linear chain)
        Exp = Exp*Adj;
        Con = (Con + Exp)>0;
    end
    Con = (Con + Con'+eye(size(Con)))>0;
end