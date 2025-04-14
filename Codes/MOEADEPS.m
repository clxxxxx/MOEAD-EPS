classdef MOEADEPS < ALGORITHM
% <multi/many> <real/integer/label/binary/permutation>
% Evolutionary algorithm with adaptive weights

%------------------------------- Reference --------------------------------
% M. Li and X. Yao, What weights work for you? Adapting weights for any
% Pareto front shape in decomposition-based evolutionary multiobjective
% optimisation, Evolutionary Computation, 2020, 28(2): 227-253.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)
            %% Generate the weight vectors
            [W,Problem.N] = UniformPoint(Problem.N,Problem.M);  % Generate the weight vectors
            W = (W + 1e-4)/(1 + Problem.M*1e-4);
            T = ceil(Problem.N/10);                             % The size of neighbours of each weight  
            
            %% Detect the neighbours of each weight
            B = pdist2(W,W);
            [~,B] = sort(B,2); 
            B = B(:,1:T);
            
            %% Generate random population
            P = Problem.Initialization();
            Zmin = min(P.objs,[],1);
            
            %% Generate an archive set
            Archive = P(NDSort(P.objs,1)==1);
            np = Problem.N;
            Zmax = max(Archive.objs,[],1);
            fmcount = zeros(1,Problem.M);

            %% Set parameters and initialize an empty superior external population           

            if Problem.M < 10
                acc = 0.01;
            else
                acc = 0.02;
            end
            interval = round(Problem.maxFE*0.02/Problem.N);
            IM = [];
            flag = 0;   

            %% Optimization
            while Algorithm.NotTerminated(P)
                if Problem.FE/Problem.N < ceil(Problem.maxFE*0.8/Problem.N)
                    if flag == 0
                        prob = 0.9;
                    else
                        prob = 0.1;
                    end
                    oldP = P.objs;
                    [P,Archive_temp,Zmin] = Evolve(Problem,P,W,B,Zmin,prob,flag);
                    % Update solutions in the archive set
                    Archive = unique([Archive,Archive_temp]);
                    Archive = Archive(NDSort(Archive.objs,1)==1);
                    Archive = ArchiveUpdate(Archive, np);
                    [Zmax,fmcount] = ZmaxUpdate(Zmax,max(Archive.objs,[],1),fmcount,interval);

                    IM = CalculateIM(IM,oldP,P.objs,Zmin,W,interval,acc,flag);
                    state = JudgeState(IM,interval,acc);  
                    if state == 1
                        flag = 1;
                        [P,~,~] = UpdateMainPop(P,W,T,Archive,Zmax,Zmin,Problem);
                        [W,B] = GenerateWeight(P,Zmin,T,Problem);
                        IM = [];
                    elseif state == 3
                        flag = 0;
                    end
                else
                    prob = 0.9;
                    flag = 1;
                    [P,~,Zmin] = Evolve(Problem,P,W,B,Zmin,prob,flag);
                end
            end
            
        end
    end
end