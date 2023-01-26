function [tdr_heuR_sim] = real_heuR_sim()
% Simulate the proposed heuristic scheme (realistic)
% Declare global variables
% See main_with_retran.m
global N D lambda sigma NE K

% Divide a frame into K consecutive subframes
subframes = subframe_dividing(D, K);

% Run independent numerical experiments
success = zeros(1, NE);
parfor ne = 1:NE
    % Simulate the packet arrival
    % status_initial: 0 (inactive), 1 (active)
    status_initial = rand(1, N) < lambda;
    % Consider an arbitrary node as the tagged node
    tagged_node = randi([1 N]);
    subsuccess = zeros(1, K);
    
    for k = 1:K
        % Set the packet arrival
        status = status_initial;
        % Set the delivery deadline of the subframe
        subD = subframes(k);
        % Initialize the approximation on the activity belief
        approx_belief = [N - 1, lambda];
        for t = 1:subD
            if status(tagged_node) > 0
                % Determine the value of transmission probability
                M = approx_belief(1);
                a = approx_belief(2);
                if M * a + 1 > subD - t + 1 || t == subD
                    p = min(1 / (M * a + a), 1);
                else
                    p = 1 / (subD - t + 1);
                end
                % Simulate the random access
                access = (rand(1, N) < p) .* (status > 0);
                status = status - access;
                if access(tagged_node) * sum(access) == 1 && rand < sigma
                    subsuccess(k) = 1;
                end
                % Update the approximation on the activity belief
                if sum(access) == 0
                    % case 1: observation = idle
                    approx_belief = [M, (a - a * p) / (1 - a * p)];
                else
                    % case 2: observation = busy
                    approx_belief = [M - 1, 1];
                    if approx_belief(1) > 0
                        approx_belief(2) = ...
                        M * (a - a * p) * (1 - (1 - a * p)^(M-1)) / ((M - 1) * (1 - (1 - a * p)^M));
                    end
                end
            else
                break
            end
        end
    end
    success(ne) = min(1, sum(subsuccess));
end

% Compute the TDR performance
tdr_heuR_sim = sum(success) / NE / lambda;