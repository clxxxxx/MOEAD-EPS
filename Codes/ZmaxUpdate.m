function [Zmax,count] = ZmaxUpdate(oldmax,newmax,count,interval)
% Update the nadir point
    Zmax = oldmax;
    ind1 = find(newmax<=1.05*oldmax);
    count(ind1) = 0;
    Zmax(ind1) = newmax(ind1);

    ind2 = find(newmax>1.05*oldmax);
    count(ind2) = count(ind2) + 1;
    for i = 1:length(count)
        if count(i) == 2*interval
            Zmax(i) = newmax(i);
            count(i) = 0;
        end
    end
end