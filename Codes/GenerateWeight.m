function [W,B] = GenerateWeight(Population,Z,T,Global)  
    % Obtain their corresponding weights
    Z = Z - 1e-4;
    W = (Population.objs - repmat(Z,length(Population),1))./repmat( sum(Population.objs,2)-repmat(sum(Z),length(Population),1), 1, Global.M );
    
    B = pdist2(W,W);
    [~,B] = sort(B,2);
    B = B(:,1:T); 
end