function [tdr_myo_sim] = real_myo_sim()
% Simulate the myopic scheme (realistic)
% Declare global variables
% See main_without_retran.m
global N D lambda sigma NE
global initial_belief actions
global transF rewards obserF

% Run independent numerical experiments
success = zeros(1, NE);

parfor ne = 1:NE
    % Simulate the packet arrival
    % status: 0 (inactive), 1 (active)
    status = rand(1, N) < lambda;
    % Consider an arbitrary node as the tagged node
    tagged_node = randi([1 N]);
    % Initialize the activity belief
    belief = initial_belief;
    
    for t = 1:D
        if status(tagged_node) > 0
            % Determine the value of transmission probability
            [~, ai_opt] = max(belief * rewards);
            % Simulate the random access
            access = (rand(1, N) < actions(ai_opt)) .* (status > 0);
            status = status - access;
            if access(tagged_node) * sum(access) == 1 && rand < sigma
                success(ne) = 1;
            end
            % Update the activity belief
            belief = belief *...
                (obserF(:, :, min(1, sum(access))+1) .* transF(:, :, ai_opt)); %#ok<*PFBNS>
            belief = belief / sum(belief);
        else
            break
        end
    end
end

% Compute the TDR performance
tdr_myo_sim = sum(success) / NE / lambda;

% Print the TDR performance
fprintf("tdr_myo_sim (real) = %.4f\n", tdr_myo_sim);