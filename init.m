function [ nodeName,nodeComp,Adj,seed ] = init( params )
%INIT Summary of this function goes here
%   Detailed explanation goes here
%% 
nodeName = cell(params.chainNum*sum(params.nodeNum),1);
nodeComp = zeros(length(nodeName),1);
Adj = zeros(length(nodeName),length(nodeName));
seed = zeros(size(nodeName));
%% Node naming and weighting
i = 1;
for ic = 1:params.chainNum
    for it = 1:numel(params.nodeType)
        if params.nodeNum(it)~=0
            for in = 1:params.nodeNum(it)
                nodeName{i} = [params.nodeType{it},'.',num2str(ic),'.',num2str(in)];
                nodeComp(i) = params.nodeComp(it);
                i = i + 1;
            end
        end
    end
end

%% Initialize links
for ic = 1:params.chainNum
    for il = 1:numel(params.linkRule1)
        [C]= textscan(params.linkRule1{il},'%s%s%s','delimiter', ',');
        type1 = C{1}{1}; type2 = C{2}{1}; rule = C{3}{1};
        idx1 = cellfun(@(x) ~isempty(strfind(x,[type1,'.',num2str(ic)]))...
            &&(strfind(x,[type1,'.',num2str(ic)])==1), nodeName);
        idx2 = cellfun(@(x) ~isempty(strfind(x,[type2,'.',num2str(ic)]))...
            &&(strfind(x,[type2,'.',num2str(ic)])==1), nodeName);  
        % Rules
        if strcmp(rule,'one2all') % one to all
            Adj(find(idx1,1,'first'),idx2) = params.linkWeight1(il);
        elseif strcmp(rule,'one2one') % one to one
            I1 = find(idx1); I2 = find(idx2);
            for i = 1:length(I1)
                Adj(I1(i),I2(i)) = params.linkWeight1(il);
            end
        elseif strcmp(rule,'all2one') % all to one
            Adj(idx1,find(idx2,1,'first')) = params.linkWeight1(il);
        end
    end
end
%% Initialize cluster seeds
% seeding rule1
cur = 1;
for ic = 1:params.chainNum
    for is = 1:numel(params.seedRule1)
        C= textscan(params.seedRule1{is},'%d%s','delimiter', '|');
        N = C{1}; tmp = C{2}{1};
        C = textscan(tmp,'%s',N,'delimiter', ',');
        for in = 1:N
            type1 = C{1}{in};
            idx1 = cellfun(@(x) ~isempty(strfind(x,[type1,'.',num2str(ic)]))...
            &&(strfind(x,[type1,'.',num2str(ic)])==1), nodeName);
            seed(idx1) = cur;
        end
        cur = cur + 1;
    end
end
% seeding rule2
for is = 1:numel(params.seedRule2)
    C= textscan(params.seedRule2{is},'%d%s','delimiter', '|');
    N = C{1}; tmp = C{2}{1};
    C = textscan(tmp,'%s',N,'delimiter', ',');
    for in = 1:N
        type1 = C{1}{in};
        idx1 = cellfun(@(x) ~isempty(strfind(x,type1))...
        &&(strfind(x,type1)), nodeName);
        seed(idx1) = cur;
    end
    cur = cur + 1;
end
end

