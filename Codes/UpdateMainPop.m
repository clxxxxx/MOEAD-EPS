function [P,W,B] = UpdateMainPop(P1,W1,T,P2,Zmax,Zmin,Global)
% Update the main population 

    % Merge both of the population and select the solutions which have better distribution as the new main population
    P = [P1,P2];
    % Normalisation
    fmax = Zmax;
    fmin = Zmin;
    PCObj = (P.objs-repmat(fmin,length(P),1))./repmat(fmax-fmin,length(P),1);

    [W2,~] = GenerateWeight(P2,Zmin,T,Global);
    W = [W1;W2];

    % one by one add-remove by the ED 
    d  = pdist2(PCObj,PCObj);
    d(logical(eye(length(d)))) = inf;
    Choose = false(1,length(P));
    Choose(1:Global.N) = true;
    for i = Global.N+(1:length(P2))
        Choose(i) = true;
        Remain = find(Choose);
        subDis = d(Remain,Remain);
        subDis = sort(subDis,2);
        [~,Rank] = sortrows(subDis);
        worst = Rank(1);
        Choose(Remain(worst))  = false;
    end
    P = P(Choose);
    W = W(Choose,:);
    B = pdist2(W,W);
    [~,B] = sort(B,2);
    B = B(:,1:T); 

end