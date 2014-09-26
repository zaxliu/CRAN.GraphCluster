function [ bestCluster, Cmin ] = tryNdraw(nodeName,nodeComp,Adj,seed,clusters,params)
    Cmin = inf;
    bestCluster = [];
    nxt = find(seed==0,1,'first');
    if isempty(nxt)
        [ C1 ] = costComp(nodeName,nodeComp,Adj,seed,seed,params);
        [ C2 ] = costFront(nodeName,nodeComp,Adj,seed,seed,params);
        disp(seed.');
        plot(C1,C2,'+');
        hold on;
        if Cmin > (C1+C2)
            Cmin = C1+C2;
            bestCluster = seed;
        end
    else
        for n = 1:max(seed)
            delta = zeros(size(seed));
            delta(nxt) = n;
            [bestCluster1, Cmin1]  = tryNdraw(nodeName,nodeComp,Adj,seed + delta ,clusters,params);
            if Cmin > Cmin1
                Cmin = Cmin1;
                bestCluster = bestCluster1;
            end
        end
    end

end

