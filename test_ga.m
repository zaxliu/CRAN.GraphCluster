% ObjectiveFunction = @simple_fitness;
% nvars = 2;    % Number of variables
% LB = [0 0];   % Lower bound
% UB = [1 13];  % Upper bound
% ConstraintFunction = @simple_constraint;
% rng(1,'twister') % for reproducibility
% options = gaoptimset('PlotFcns',{@gaplotbestf,@gaplotmaxconstr},'Display','iter'); %
% [x,fval] = ga(ObjectiveFunction,nvars,[],[],[],[],LB,UB,ConstraintFunction,options);

lb = [5*pi,-20*pi];
ub = [20*pi,-4*pi];
opts = gaoptimset('PlotFcns',@gaplotbestf);
rng(1,'twister') % for reproducibility
IntCon = 1;
[x,fval,exitflag] = ga(@rastriginsfcn,2,[],[],[],[],lb,ub,[],IntCon,opts)