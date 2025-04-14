function [IM] = CalculateIM(IM,oldObj,newObj,Z,W,interval,acc,flag)
% Calculate Convergence information of the population
             
    % Calculate the converging rate of each weight
    if flag == 1
        oldObj = max(abs((oldObj-repmat(Z,size(oldObj,1),1))./W),[],2);
        newObj = max(abs((newObj-repmat(Z,size(newObj,1),1))./W),[],2);
    else
        [N,M] = size(oldObj);
        oldObj = oldObj-repmat(Z,N,1);
        newObj = newObj-repmat(Z,N,1);
        c = M/100;
        a = ones(M)*c;
        a(logical(eye(M))) = 1;
        oldObj = oldObj * a ./ (W *a ./W);
        newObj = newObj * a ./ (W *a ./W);
        oldObj = max(abs(oldObj)./W,[],2);
        newObj = max(abs(newObj)./W,[],2);
    end
    IM(:,end+1)   = (oldObj-newObj)./oldObj;
    ind = mean(IM,1)>=acc;
    if sum(ind)>0
        IM = IM(:,find(ind,1):end);
    end
    if size(IM,2) > interval
        IM(:,1)   = [];
    end   
end