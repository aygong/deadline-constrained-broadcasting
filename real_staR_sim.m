function [tdr_staR_sim] = real_staR_sim()
% Simulate the optimal static scheme (realistic)
% Declare global variables
% See main_with_retran.m
global N D lambda sigma NE K
global actions num_action

% Run independent numerical experiments
tdr_staR_sim = zeros(1, num_action);
for ai = 1:num_action
    p = actions(ai);
    success = zeros(1, NE);
    
    parfor ne = 1:NE
        % Simulate the packet arrival
        % status: 0 (inactive), 1 (active)
        status = K * (rand(1, N) < lambda);
        % Consider an arbitrary node as the tagged node
        tagged_node = randi([1 N]);
        for t = 1:D
            if status(tagged_node) > 0
                % Simulate the random access
                access = (rand(1, N) < p) .* (status > 0);
                status = status - access;
                if access(tagged_node) * sum(access) == 1 && rand < sigma
                    success(ne) = 1;
                end
            else
                break
            end
        end
    end
    tdr_staR_sim(ai) = sum(success) / NE / lambda;
end

% Compute the TDR performance
tdr_staR_sim = max(tdr_staR_sim);