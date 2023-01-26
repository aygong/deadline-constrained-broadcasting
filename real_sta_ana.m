function [tdr_sta_ana] = real_sta_ana()
% Analyze the optimal static scheme (realistic)
% Declare global variables
% See main_without_retran.m
global D
global initial_belief actions num_action
global transF rewards

% Compute the expected total reward from slot 1 to slot D
% U_sta: the value function corresponding to the static scheme
% pi_sta: the optimal static scheme
U_sta = zeros(1, num_action);
for ai = 1:num_action % ai - the index of the action
    belief = initial_belief;
    for t = 1:D
        U_sta(ai) = U_sta(ai) + dot(belief, rewards(:, ai));
        belief = belief * transF(:, :, ai);
    end
end

% Compute the TDR performance
[tdr_sta_ana, pi_sta] = max(U_sta);
tdr_sta_sim = real_sta_sim(actions(pi_sta));

% Print the TDR performance
fprintf("tdr_sta_ana (real) = %.4f\n", tdr_sta_ana);
fprintf("tdr_sta_sim (real) = %.4f\n", tdr_sta_sim);