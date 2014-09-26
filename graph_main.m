%% Initialization
% initialization parameters
params.nodeType = {'radioTX','radioRX','fft','ifft',...
            'mod','demod','code','decode',...
            'dataSourceDL','dataSinkUL'};   % Type name [10]
params.nodeComp = [0,0,1,1,...
                    0.1,0.1,0.1,2,...
                    0,0];  	% node computation complexity [by type]
params.nodeNum = [1,1,1,1,...
                    1,1,1,1,...
                    1,1];     % number of node by type in each chain (vbs-UL/DL)
params.chainNum = 2;                        % number of chains (vbs-UL/DL)
% link initialization rule #1 [internal of chains] and corresponding weight
params.linkRule1 = {'radioRX,fft,one2one','fft,demod,one2all','demod,decode,one2one','decode,dataSinkUL,all2one',....
            'dataSourceDL,code,one2all','code,mod,one2one','mod,ifft,all2one','ifft,radioTX,one2one'}; 
params.linkWeight1 = [1, 0.9*1/3, 0.9*4/30/3, 0.81*4/30/3,...
                        0.81*4/30/3, 0.9*4/30/3, 0.9*1/3, 1];   % Weighting rule between links
% link initialization rule #2 [between of chains] and corresponding weight
params.linkRule2 = {}; % Node linkage rule between chains
params.linkWeight2 = {};
% seed nodes for custering operation
params.seedRule1 = {'2|radioTX,radioRX'};  % Cluster seed in the same chain 'N,node1,...nodeN'
params.seedRule2 = {'2|dataSourceDL,dataSinkUL'};  % cluster seed across chains
[nodeName,nodeComp,Adj,seed] = init(params);
%% Cluster, cost
% [clusters] = clusterFun(nodeName,nodeComp,Adj,seed);
% [ C1 ] = costComp(nodeName,nodeComp,Adj,seed,clusters,params );
% [ C2 ] = costFront(nodeName,nodeComp,Adj,seed,clusters,params );
% plot(C1,C2);hold on;
%% Cost scaning ( Cannot run simultaneously with single cost )

% h = figure; hold on;
tryNdraw(h,nodeName,nodeComp,Adj,seed,clusters,params);
%% Visualizing results
% bg = biograph(Adj,nodeName); dolayout(bg);
% set(bg,'ShowWeights','on');
% h = view(bg);
% bg.nodes(1).Position = [150 150];
% dolayout(bg, 'Pathsonly', true);
% view(bg)
