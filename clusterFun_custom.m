function [clusters,fval] = clusterFun_custom(nodeName,nodeComp,Adj,paths,delayBound,Con,seed,params)
%% Find best clustering scheme using Genetic algorithm
%  using customized crossover and mutation functions
%  2014.9.3 20:00
    %% Function handles
    fitnessFcn = @(clusters) cost(nodeName,nodeComp,Adj,paths,delayBound,seed,clusters,params);
    initPopFcn = @(GenomeLength,FitnessFcn,options) pop_gb(GenomeLength,FitnessFcn,options,seed,Con);
    mutationFcn = @(parents,options,GenomeLength,FitnessFcn,state,thisScore,thisPopulation) mutation_gb(parents,options,GenomeLength,FitnessFcn,state,thisScore,thisPopulation,seed,Con);
    
    %% Assign bounds [0:Nc] and integer constraint
    lb = ones(1,length(seed));
    ub = max(seed)*ones(1,length(seed));
    lb(seed~=0) = seed(seed~=0);    % cluster index for seed nodes are fixed
    ub(seed~=0) = seed(seed~=0);
    %% Set options
    opts = gaoptimset(...%'InitialPopulation', InitPop, ...
                        'StallGenLimit',50,'TolFun',1e-10,...
                        'Generations',300,'PlotFcns',{@gaplotbestfun,@gaplotbestindiv,@gaplotdistance,@gaplotscores},...
                        'CreationFcn',initPopFcn,...
                        'MutationFcn',mutationFcn);
    %% Genetic algorithm
%     rng(3,'twister') % seeding for random number generator, uncomment if want to reproduce result
    [x,fval,exitflag] = ga(fitnessFcn,length(seed),[],[],[],[],lb,ub,[],[],opts);
    if size(x,2)~=1
        clusters = x.';
    end
end

%% Customized intial population function
function Population = pop_random(GenomeLength,FitnessFcn,options)
    totalpopulation = sum(options.PopulationSize);
    range = options.PopInitRange;
    lowerBound = range(1,:);
    span = range(2,:) - lowerBound;
    Population = repmat(lowerBound,totalpopulation,1) + ...
         round(repmat(span,totalpopulation,1) .* ...
    rand(totalpopulation,GenomeLength));
end
function Population = pop_gb(GenomeLength,FitnessFcn,options,seed,Con)
    seed = seed';
    seedIndex = seed~=0;
    clusterCon = Con.*repmat(seed,length(seed),1);
    Population = zeros(sum(options.PopulationSize),GenomeLength);
    for i = 1:sum(options.PopulationSize)
        for j = 1:length(seed)         
            tmp = unique(clusterCon(j,:));  % find unique connected clusters
            tmp = tmp(2:end);               % discard cluster 0
            index = randi(length(tmp),1);   % randomly select a cluster
            Population(i,j) = tmp(index); % change the position to that cluster
        end
        Population(i,seedIndex) = seed(seedIndex);
    end
end
%% Customized crossover function
% function crossoverChildren = custom_crossover(parents,options,GenomeLength,FitnessFcn,state,thisScore,thisPopulation,CrossoverFcnArgs)
% arents,options,GenomeLength,FitnessFcn,unused,thisPopulation    
% end
%% Customized mutation functions
function mutationChildren = mutation_gb(parents,options,GenomeLength,FitnessFcn,state,thisScore,thisPopulation,seed,Con)
    seed = seed';
    seedIndex = seed~=0;
    mutationChildren = zeros(length(parents),GenomeLength);
    clusterCon = Con.*repmat(seed,length(seed),1);
    for i = 1:length(parents)
        mutationParent = thisPopulation(parents(i),:);   % extract parent for mutation
        mutationIndex  = rand(1,length(seed))>0.5;  % decide the mutation position
        mutationIndex(seedIndex) = 0;
        for j = 1:length(mutationParent)         
            if mutationIndex(j) == 1    % if decide to mutate
                tmp = unique(clusterCon(j,:));  % find unique connected clusters
                tmp = tmp(2:end);               % discard cluster 0
                index = randi(length(tmp),1);   % randomly select a cluster
                mutationParent(j) = tmp(index); % change the position to that cluster
            end
        end
        mutationChildren(i,:) = mutationParent;
    end
end
function mutationChildren = mutation_bouncing(parents,options,GenomeLength,FitnessFcn,state,thisScore,thisPopulation,seed,Adj)
% Random bouncing mutation
	seed = seed.';
    seedIndex = (seed~=0);     n = max(seed) - 1;
    bCeil = max(seed)*ones(size(seed)); bCeil(seedIndex) = seed(seedIndex);
    bFloor = reshape(repmat((1:n),length(seed)/n,1),1,length(seed)); bFloor(seedIndex) = seed(seedIndex);% fully distributed
    mutationChildren = zeros(length(parents),GenomeLength);
    for i=1:length(parents)
        parent = thisPopulation(parents(i),:);
        bIndex1 = rand(1,length(seed))>0.8;
        bIndex2 = rand(1,length(seed))>0.5;
        mutantFactor = bFloor; mutantFactor(bIndex2) = bCeil(bIndex2);
        parent(bIndex1) =  mutantFactor(bIndex1);
        mutationChildren(i,:) = parent;
    end
end
function mutationChildren = mutation_randmod(parents,options,GenomeLength,FitnessFcn,state,thisScore,thisPopulation)
% Mutation by adding random number in a modular fashion
     if(nargin < 9)
         shrink = 1;
         if(nargin < 8)
             scale = 1;
         end
     end
     if (shrink > 1) || (shrink < 0)
         msg = sprintf('Shrink factors that are less than zero or greater than one may \n\t\t result in unexpected behavior.');
         warning('gads:INT_MUTATION:ShrinkFactor',msg);
     end

     scale = scale - shrink * scale * state.Generation/options.Generations;

     range = options.PopInitRange;
     lower = range(1,:);
     upper = range(2,:);
     scale = scale * (upper - lower);

     mutationChildren = zeros(length(parents),GenomeLength);
     for i=1:length(parents)
         parent = thisPopulation(parents(i),:);
         mutationChildren(i,:) = parent + round(scale .* randn(1,length(parent)));
     end
     mutationChildren = mod((mutationChildren-1),max(upper)) + 1;
end