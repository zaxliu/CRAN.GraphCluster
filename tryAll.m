function [front] = tryAll(nodeName,nodeComp,Adj,seed,params,front)
%% Try all possible clustering schemes
%  Try all possible clustering scheme using recursion. Visualize schemes 
%  on a plot. Find the best cluster simaltaneously.
%  2014.9.17 10:57
    nxt = find(seed==0,1,'first');  % next scheme to try (the next un-initialized node)
    if isempty(nxt)
        [ C1 ] = costComp(nodeName,nodeComp,Adj,seed,seed,params);
        [ C2 ] = costFront(nodeName,nodeComp,Adj,seed,seed,params);
        disp(seed.');
        front = extractFrontier([front,[C1;C2]]);
    else
        for n = 1:max(seed)
            delta = zeros(size(seed));
            delta(nxt) = n;
            [front]  = tryAll(nodeName,nodeComp,Adj,seed + delta ,params,front);            
        end
    end
end

