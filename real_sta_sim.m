function [tdr_sta_sim] = real_sta_sim(pi_sta)
% Simulate the optimal static scheme (realistic)
% Declare global variables
% See main_without_retran.m
global N D lambda sigma NE

% Run independent numerical experiments
success = zeros(1, NE);
parfor ne = 1:NE
    % Simulate the packet arrival
    % status: 0 (inactive), 1 (active)
    status = rand(1, N) < lambda;
    % Consider an arbitrary node as the tagged node
    tagged_node = randi([1 N]);
    for t = 1:D
        if status(tagged_node) > 0
            % Simulate the random access
            access = (rand(1, N) < pi_sta) .* (status > 0);
            status = status - access;
            if access(tagged_node) * sum(access) == 1 && rand < sigma
                success(ne) = 1;
            end
        else
            break
        end
    end
end

% Compute the TDR performance
tdr_sta_sim = sum(success) / NE / lambda;