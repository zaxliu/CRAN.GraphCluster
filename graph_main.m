%% Initialization
clear all;
% initialization parameters
params.nodeType = {'radioTX','radioRX','fft','ifft',...
            'MIMOtx','MIMOrx',...
            'mod','demod','code','decode',...
            'dataSourceDL','dataSinkUL'};   % Type name [12]
params.nodeComp = [0,   0,   1, 1,...
                   0.5, 0.5,... 
                   0.1, 0.1, 0.1, 2,...
                   0,   0];  	% node computation complexity [by type]
cpRatio = 0.9; subNum = 2; modRatio = 4/30; codeRatio = 0.9;
params.nodeNum = [1,    1,  1,  1,...
                  subNum,subNum,...
                  subNum,subNum,subNum,subNum,...
                  1,    1];     % number of node by type in each chain (vbs-UL/DL)
params.chainNum = 2;                        % number of chains (vbs-UL/DL)
% link initialization rule #1 [internal of chains] and corresponding weight
params.linkRule1 = {'radioRX,fft,one2one','fft,MIMOrx,one2all','MIMOrx,demod,one2one','demod,decode,one2one','decode,dataSinkUL,all2one',....
            'dataSourceDL,code,one2all','code,mod,one2one','mod,MIMOtx,one2one','MIMOtx,ifft,all2one','ifft,radioTX,one2one'}; 
params.linkWeight1 = [1, 0.9/subNum, 0.9/subNum,  0.9*4/30/subNum, 0.81*4/30/subNum,...
                        0.81*4/30/subNum, 0.9*4/30/subNum, 0.9/subNum, 0.9/subNum, 1];   % Weighting rule between links
% params.linkRule1 = {'radioRX,fft,one2one','fft,MIMOrx,one2all','MIMOrx,demod,one2one','demod,decode,one2one','decode,dataSinkUL,all2one',....
%             'dataSourceDL,code,one2all','code,mod,one2one','mod,MIMOtx,one2one','MIMOtx,ifft,all2one','ifft,radioTX,one2one'}; 
% params.linkWeight1 = [1, 0.9/subNum, 0.9/subNum,  0.9*4/30/subNum, 0.81*4/30/subNum,...
%                         0.81*4/30/subNum, 0.9*4/30/subNum, 0.9/subNum, 0.9/subNum, 1];   % Weighting rule between links
% link initialization rule #2 [between of chains] and corresponding weight
params.linkRule2 = {}; % Node linkage rule between chains
params.linkWeight2 = [];
% params.linkRule2 = {'MIMOrx,MIMOrx,mutual/cyclic','MIMOtx,MIMOtx,mutual/cyclic'}; % Node linkage rule between chains
% params.linkWeight2 = [0.9/subNum, 0.9/subNum];
% seed nodes for custering operation
params.seedRule1 = {'2|radioTX,radioRX'};  % Cluster seed in the same chain 'N,node1,...nodeN'
params.seedRule2 = {'2|dataSourceDL,dataSinkUL'};  % cluster seed across chains
[nodeName,nodeComp,Adj,paths,delayBound,seed,Con] = init(params);

params.alpha = 1;  
params.beta = 0; 
params.scaleC1 = params.chainNum;
params.scaleC2 = 2.8651;
%% Cluster, cost
% for n = 1
%     [clusters(:,n),fval(n)] = clusterFun_custom(nodeName,nodeComp,Adj,paths,delayBound,Con,seed,params);
%     [C1(n)] = costComp(nodeName,nodeComp,Adj,seed,clusters(:,n),params);
%     [C2(n)] = costFront(nodeName,nodeComp,Adj,seed,clusters(:,n),params);
%     [C3(n)] = penaltyDelay(nodeName,nodeComp,Adj,paths,delayBound,seed,clusters(:,n),params);
%     disp(fval(n));
% end
%% Exhaustive scaning ( Cannot run simultaneously with clustering )
% h = figure; hold on;
% [ bestCluster, Cmin ] = tryAll(nodeName,nodeComp,Adj,seed,params);
%% Visualize tradeoff
% figure; 
hold on; warning off;
[front] = tryAll(nodeName,nodeComp,Adj,seed,params,[]);
plot(front(1,:),front(2,:),'+'); hold on;
% h = gca;
% for alpha = 0.02:0.01:0.4
%     for n = 1:3
%         params.alpha = alpha;  
%         params.beta = 0; 
%         params.scaleC1 = 1;
%         params.scaleC2 = 2;
%         [clusters,fval] = clusterFun_custom(nodeName,nodeComp,Adj,paths,delayBound,Con,seed,params);
%         [C1] = costComp(nodeName,nodeComp,Adj,seed,clusters,params);
%         [C2] = costFront(nodeName,nodeComp,Adj,seed,clusters,params);
%         [C3] = penaltyDelay(nodeName,nodeComp,Adj,paths,delayBound,seed,clusters,params);
%         fprintf('alpha = %f, C1 = %f, C2 = %f, fval = %f\n',alpha,C1,C2,fval);
%         plot(h,C1,C2,'ro');hold on;
% %         pause;
%     end
% end
%% Visualizing results
% bg = biograph(Adj,nodeName);dolayout(bg);
% set(bg,'ShowWeights','on');
% h = view(bg);
% bg.nodes(1).Position = [150 150];
% dolayout(bg, 'Pathsonly', true);
% view(bg)
% profile = resultProfiling( clusters,nodeName,params );
% figure;
% stem(sum(profile(:,1:(end-1)),2)./sum(profile,2));
% set(gca,'XTick',1:18)
% set(gca,'XTickLabel',params.nodeType)

