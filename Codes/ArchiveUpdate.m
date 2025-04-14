function Archive = ArchiveUpdate(Archive,N)
% Archive Update

    if isempty(Archive)
        return;
    else
        while length(Archive) > N
            % Normalization
            PCObj = Archive.objs;
            nND = length(Archive);
            fmax  = max(PCObj,[],1);
            fmin  = min(PCObj,[],1);
            PCObj = (PCObj-repmat(fmin,nND,1))./repmat(fmax-fmin,nND,1);
            %% Calculate the shifted distance between each two solutions
            np = length(Archive);
            d = inf(np);
            for i = 1 : np
                SPopObj = max(PCObj,repmat(PCObj(i,:),np,1));
                for j = [1:i-1,i+1:np]
                    d(i,j) = norm(PCObj(i,:)-SPopObj(j,:));
                end
            end

            % by the ED 
            while length(Archive) > N
                subDis = sort(d,2);
                subDis = subDis(:,1) + 0.1*subDis(:,2);
                [~,worst] = min(subDis);
                Archive(worst)  = [];
                d(worst,:) = [];
                d(:,worst) = [];
            end

        end
    end
end