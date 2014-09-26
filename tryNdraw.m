function [  ] = tryNdraw(h,nodeName,nodeComp,Adj,seed,clusters,params)
    
    nxt = find(seed==0,1,'first');
    if isempty(nxt)
        [ C1 ] = costComp(nodeName,nodeComp,Adj,seed,seed,params);
        [ C2 ] = costFront(nodeName,nodeComp,Adj,seed,seed,params);
        disp(seed.');
        plot(C1,C2,'+');
        hold on;
    else
        for n = 1:max(seed)
            delta = zeros(size(seed));
            delta(nxt) = n;
            tryNdraw(h,nodeName,nodeComp,Adj,seed + delta ,clusters,params)
        end
    end

end

