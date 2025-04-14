function [state] = JudgeState(IM,interval,acc)
           
    % Judge if the population is totally converged
    maxIM   = max(IM,[],'all');  
    num = sum(IM>acc,"all")/size(IM,2);
    if size(IM,2) >= 5 && num >= size(IM,1)/10
        state = 3;
    elseif size(IM,2) == interval && num < size(IM,1)/10
        state = 1;
    else
        state = 2;
    end
end