function [Population,Archive_temp,Z] = Evolve(Problem,Population,W,B,Z,p,flag)

    [N,M] = size(Population.objs);
    % Calculate the converging rate of each weight
    for i = 1 : N
        % Choose parents
        if rand < p
            P = B(i,randperm(size(B,2)));
        else
            P = randperm(N);    
        end
        P(ismember(P, i)) = [];
        P = [i P];
        if flag == 1 && p == 0.1
            Offspring = OperatorGAhalf(Problem,Population(P(1:2)),{1,5,1,5});
        else
            Offspring = OperatorGAhalf(Problem,Population(P(1:2)));
        end
        % Put the offspring into the archive
        Archive_temp(i) = Offspring;
        % Update the ideal point
        Z = min(Z ,Offspring.obj);
        PopObj = Population.objs-repmat(Z,N,1);
        OffObj = repmat(Offspring.obj-Z,N,1);
        % Select the solutions which meet conditions to update
        if flag == 1
            g_old = max(abs(Population.objs-repmat(Z,N,1))./W,[],2);
            g_new = max(repmat(abs(Offspring.obj-Z),N,1)./W,[],2);
        else
            c = M/100;
            a = ones(M)*c;
            a(logical(eye(M))) = 1;
            PopObj = PopObj * a ./ (W *a ./W);
            OffObj = OffObj * a ./ (W *a ./W);
            g_old = max(abs(PopObj)./W,[],2);
            g_new = max(abs(OffObj)./W,[],2);
        end
        ind = find(g_old >= g_new);

        if ~isempty(ind)
            tem = randperm(length(ind));
            ind = ind(tem);
            Population(ind(1)) = Offspring;
        end

    end
end