%% Initialization
% clear all;
% initialization parameters
params.nodeType = {'radioTX','radioRX','fft','ifft',...
            'mod','demod','code','decode',...
            'dataSourceDL','dataSinkUL'};   % Type name [10]
params.nodeComp = [0,0,1,1,...
                    0.1,0.1,0.1,2,...
                    0,0];  	% node computation complexity [by type]
subNum = 4;
params.nodeNum = [1,1,1,1,...
                    subNum,subNum,subNum,subNum,...
                    1,1];     % number of node by type in each chain (vbs-UL/DL)
params.chainNum = 6;                        % number of chains (vbs-UL/DL)
% link initialization rule #1 [internal of chains] and corresponding weight
params.linkRule1 = {'radioRX,fft,one2one','fft,demod,one2all','demod,decode,one2one','decode,dataSinkUL,all2one',....
            'dataSourceDL,code,one2all','code,mod,one2one','mod,ifft,all2one','ifft,radioTX,one2one'}; 
params.linkWeight1 = [1, 0.9*1, 0.9*4/30/subNum, 0.81*4/30/subNum,...
                        0.81*4/30/subNum, 0.9*4/30/subNum, 0.9*1, 1];   % Weighting rule between links
% link initialization rule #2 [between of chains] and corresponding weight
params.linkRule2 = {}; % Node linkage rule between chains
params.linkWeight2 = {};
% seed nodes for custering operation
params.seedRule1 = {'2|radioTX,radioRX'};  % Cluster seed in the same chain 'N,node1,...nodeN'
params.seedRule2 = {'2|dataSourceDL,dataSinkUL'};  % cluster seed across chains
[nodeName,nodeComp,Adj,paths,delayBound,seed,Con] = init(params);
%% Cluster, cost
for n = 1
    [clusters(:,n),fval(n)] = clusterFun_custom(nodeName,nodeComp,Adj,paths,delayBound,Con,seed,params);
    [C1(n)] = costComp(nodeName,nodeComp,Adj,seed,clusters,params);
    [C2(n)] = costFront(nodeName,nodeComp,Adj,seed,clusters,params);
    [C3(n)] = penaltyDelay(nodeName,nodeComp,Adj,paths,delayBound,seed,clusters,params);
    disp(fval(n));
end

%% Exhaustive scaning ( Cannot run simultaneously with clustering )
% h = figure; hold on;
% [ bestCluster, Cmin ] = tryNdraw(nodeName,nodeComp,Adj,seed,clusters,params);
%% Visualizing results
% bg = biograph(Adj,nodeName);dolayout(bg);
% set(bg,'ShowWeights','on');
% h = view(bg);
% bg.nodes(1).Position = [150 150];
% dolayout(bg, 'Pathsonly', true);
% view(bg)
profile = resultProfiling( clusters,nodeName,params );
figure;
stem(sum(profile(:,1:(end-1)),2)./sum(profile,2));

