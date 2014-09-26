function [Con] = conection(Adj)
%% Find the connection matrix
    Con = zeros(size(Adj));
    Exp = 1; % exponentials of A (0-th)
    for n = 1:size(Adj,1)   % a node can reach any connected node within N-1 steps (linear chain)
        Exp = Exp*Adj;
        Con = (Con + Exp)>0;
    end
    Con = (Con + Con'+eye(size(Con)))>0;
end