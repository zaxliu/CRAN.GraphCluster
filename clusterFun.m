function [clusters,fval] = clusterFun(nodeName,nodeComp,Adj,seed,params)
%% Find best clustering scheme using Genetic algorithm (mixed-integer)
%  2014.9.2 20:00
    %% Fitness function 
%     fitnessFcn = @cost;   % simple cost fcn
    fitnessFcn = @(clusters) cost(nodeName,nodeComp,Adj,seed,clusters,params);
    %% Assign bounds [0:Nc] and integer constraint
    lb = ones(1,length(seed));
    ub = max(seed)*ones(1,length(seed));
    lb(seed~=0) = seed(seed~=0);    % cluster index for seed nodes are fixed
    ub(seed~=0) = seed(seed~=0);
    IntCon = 1:length(seed);
    %% Initial population (random or "fully distributed")
    popSize = 100;
    InitPop = randi([1,max(seed)],[length(seed),popSize])'; % random intitial value
%     InitPop = repmat(reshape(repmat((1:6),10,1),1,60),popSize,1); % fully distributed
    InitPop(:,seed~=0) = repmat(seed(seed~=0)',popSize,1);
    %% Set options
    opts = gaoptimset('InitialPopulation', InitPop, ...
                        'StallGenLimit',50,'TolFun',1e-10,...
                        'Generations',300,'PlotFcns',{@gaplotbestfun,@gaplotbestindiv});
    %% Genetic algorithm
%     rng(1,'twister') % seeding for random number generator, uncomment if want to reproduce result
    [x,fval,exitflag] = ga(fitnessFcn,length(seed),[],[],[],[],lb,ub,[],IntCon,opts);
    clusters = x.';
end

