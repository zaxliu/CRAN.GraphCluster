%% Initialization
% clear all;
% initialization parameters
params.nodeType = {'radioTX','radioRX','fft','ifft',...
            'MIMOtx','MIMOrx',...
            'mod','demod','code','decode',...
            'sourceDL','sinkUL'};   % Type name [12]
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
params.linkRule1 = {'radioRX,fft,one2one','fft,MIMOrx,one2all','MIMOrx,demod,one2one','demod,decode,one2one','decode,sinkUL,all2one',....
            'sourceDL,code,one2all','code,mod,one2one','mod,MIMOtx,one2one','MIMOtx,ifft,all2one','ifft,radioTX,one2one'}; 
params.linkWeight1 = [1, 0.9/subNum, 0.9/subNum,  0.9*4/30/subNum, 0.81*4/30/subNum,...
                        0.81*4/30/subNum, 0.9*4/30/subNum, 0.9/subNum, 0.9/subNum, 1];   % Weighting rule between links
% link initialization rule #2 [between of chains] and corresponding weight
params.linkRule2 = {}; % Node linkage rule between chains
params.linkWeight2 = [];
% params.linkRule2 = {'MIMOrx,MIMOrx,mutual/cyclic','MIMOtx,MIMOtx,mutual/cyclic'}; % Node linkage rule between chains
% params.linkWeight2 = [0.9/subNum, 0.9/subNum];
% seed nodes for custering operation
params.seedRule1 = {'2|radioTX,radioRX'};  % Cluster seed in the same chain 'N,node1,...nodeN'
params.seedRule2 = {'2|sourceDL,sinkUL'};  % cluster seed across chains
[nodeName,nodeComp,Adj,paths,delayBound,seed,Con] = init(params);
%% Compare CoMP
% params.alpha = 0.01;  
% params.beta = 10;
% params.scaleC1 = 2;
% params.scaleC2 = 6.3;
% D = 30;
% N = 10;
% delayBound = delayBound/max(delayBound)*D;
% clusters = []; C1 = []; C2 = []; C3 = [];
% for n = 1:N
%     [clusters(:,n),fval(n)] = clusterFun_custom(nodeName,nodeComp,Adj,paths,delayBound,Con,seed,params);
%     [C1(n)] = costComp(nodeName,nodeComp,Adj,seed,clusters(:,n),params);
%     [C2(n)] = costFront(nodeName,nodeComp,Adj,seed,clusters(:,n),params);
%     [C3(n)] = penaltyDelay(nodeName,nodeComp,Adj,paths,delayBound,seed,clusters(:,n),params);
%     fprintf('Run #%d, C1 = %f, C2 = %f, C3 = %f, fval = %f\n',n,C1(n),C2(n),C3(n),fval(n)); 
% end
% profile = resultProfiling(clusters,nodeName,params);
% distProb(:,2) = sum(profile(:,1:(end-1)),2)./sum(profile,2);
% bar(distProb);
% % xlabel('Node type');ylabel('Probability');

%% Exhaustive scaning ( Cannot run simultaneously with clustering )
% h = figure; hold on;
% [ bestCluster, Cmin ] = tryAll(nodeName,nodeComp,Adj,seed,params);
%% Tradeoff w.r.t alpha
% N = 10; % num runs for each alpha
% D = 30; % delay bound factor
% alphaVec = [0.01:0.01:0.1,0.12:0.02:0.3]; % alphas to use
% params.beta = 10;
% params.scaleC1 = 2;
% params.scaleC2 = 6.3;
% 
% figure; hold on; h1 = gca;
% figure; hold on; h2 = gca;
% delayBound = D*delayBound/max(delayBound);
% meanC1 = zeros(1,length(alphaVec)); meanC2 = zeros(1,length(alphaVec));
% stdC1 = zeros(1,length(alphaVec)); stdC2 = zeros(1,length(alphaVec));
% profiles = cell(1,length(alphaVec));
% distProb = [];
% for alphaIdx = 1:length(alphaVec)
%     alpha = alphaVec(alphaIdx);
%     clusters = []; C1 = []; C2 = []; C3 = [];
%     for n = 1:N
%         params.alpha = alpha;
%         [clusters(:,n),fval] = clusterFun_custom(nodeName,nodeComp,Adj,paths,delayBound,Con,seed,params);
%         [C1(n)] = costComp(nodeName,nodeComp,Adj,seed,clusters(:,n),params);
%         [C2(n)] = costFront(nodeName,nodeComp,Adj,seed,clusters(:,n),params);
%         [C3(n)] = penaltyDelay(nodeName,nodeComp,Adj,paths,delayBound,seed,clusters(:,n),params);
%         fprintf('Run #%d: alpha = %.3f, C1 = %.3f, C2 = %.3f, C3 = %.3f, fval = %.3f\n',n,alpha,C1(n),C2(n),C3(n),fval);       
%     end
%     % Post processing
%     meanC1(alphaIdx) = mean(C1); meanC2(alphaIdx) = mean(C2);
%     stdC1(alphaIdx) = std(C1); stdC2(alphaIdx) = std(C2);
%     fprintf('meanC1 = %.3f, stdC1 = %.3f, meanC2 = %.3f, stdC2 = %.3f\n',meanC1(alphaIdx),stdC1(alphaIdx),meanC2(alphaIdx),stdC2(alphaIdx));
%     profiles{alphaIdx} = resultProfiling(clusters,nodeName,params);
%     distProb(:,alphaIdx) = sum(profiles{alphaIdx}(:,1:(end-1)),2)./sum(profiles{alphaIdx},2);
%     % Visualization
%     plot(h1,meanC1(alphaIdx),meanC2(alphaIdx),'bo');
% end
% % profiling compare
% % bar(h2,distProb(3:10,:));
% % set(h2,'XTick',1:numel(params.nodeType));
% % set(h2,'XTickLabel',params.nodeType)
% % xlabel('Node type');ylabel('Distribution probability');
% % legend('Distribution','Centralization');

%% Tradeoff w.r.t alpha
N = 10; % num runs for each alpha
delayVec = [20:-1:1]; % delay bound factor
params.alpha = 0.01;
params.beta = 10;
params.scaleC1 = 2;
params.scaleC2 = 6.3;

figure; hold on; h1 = gca;
figure; hold on; h2 = gca;

meanC1 = zeros(1,length(delayVec)); meanC2 = zeros(1,length(delayVec));
stdC1 = zeros(1,length(delayVec)); stdC2 = zeros(1,length(delayVec));
profiles = cell(1,length(delayVec));
distProb = [];
for delayIdx = 1:length(delayVec)
    delayBound = delayVec(delayIdx)*delayBound/max(delayBound);
    clusters = []; C1 = []; C2 = []; C3 = [];
    for n = 1:N
        [clusters(:,n),fval] = clusterFun_custom(nodeName,nodeComp,Adj,paths,delayBound,Con,seed,params);
        [C1(n)] = costComp(nodeName,nodeComp,Adj,seed,clusters(:,n),params);
        [C2(n)] = costFront(nodeName,nodeComp,Adj,seed,clusters(:,n),params);
        [C3(n)] = penaltyDelay(nodeName,nodeComp,Adj,paths,delayBound,seed,clusters(:,n),params);
        fprintf('Run #%d: delay = %.3f, C1 = %.3f, C2 = %.3f, C3 = %.3f, fval = %.3f\n',n,delayVec(delayIdx),C1(n),C2(n),C3(n),fval);       
    end
    % Post processing
    meanC1(delayIdx) = mean(C1); meanC2(delayIdx) = mean(C2);
    stdC1(delayIdx) = std(C1); stdC2(delayIdx) = std(C2);
    fprintf('meanC1 = %.3f, stdC1 = %.3f, meanC2 = %.3f, stdC2 = %.3f\n',meanC1(delayIdx),stdC1(delayIdx),meanC2(delayIdx),stdC2(delayIdx));
    profiles{delayIdx} = resultProfiling(clusters,nodeName,params);
    distProb(:,delayIdx) = sum(profiles{delayIdx}(:,1:(end-1)),2)./sum(profiles{delayIdx},2);
    % Visualization
    plot(h1,meanC1(delayIdx),meanC2(delayIdx),'bo');
    xlabel('Computational cost');ylabel('fronthauling cost');
    pause(0.01);
end
% profiling compare
bar(h2,distProb);
xlabel('Node index');ylabel('Distribution probability');
%% Visualizing results
% bg = biograph(Adj,nodeName);dolayout(bg);
% set(bg,'ShowWeights','on');
% h = view(bg);
% bg.nodes(1).Position = [150 150];
% dolayout(bg, 'Pathsonly', true);
% view(bg)
% profile = resultProfiling( clusters,nodeName,params );
% figure;
% distProb = sum(profile(:,1:(end-1)),2)./sum(profile,2);
% centProb = 1-distProb;
% bar([distProb,centProb],'stacked');
% set(gca,'XTick',1:numel(params.nodeType));
% set(gca,'XTickLabel',params.nodeType)
% xlabel('Node type');ylabel('Probability');legend('Distribution','Centralization');
