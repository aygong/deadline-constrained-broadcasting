function [tdr_opt_ana] = idea_opt_ana()
% Analyze the optimal scheme (idealized)
% Declare global variables
% See main_without_retran.m
global D
global num_state initial_belief actions num_action
global transF rewards

% Compute the expected total reward from slot 1 to slot D
% U_opt: the value function corresponding to the optimal policy
% pi_opt: the optimal policy
U_opt = zeros(num_state,D+1);
pi_opt = zeros(num_state,D);
acTransF = zeros(num_state,num_action);
for t = D:-1:1
    for si = 1:num_state % si: the index of the state at the present slot
        acTransF(:,:) = transF(si,:,:);
        acU = rewards(si,:)+transpose(U_opt(:,t+1))*acTransF;
        [U_opt(si,t),pi_opt(si, t)] = max(acU);
        pi_opt(si,t) = actions(pi_opt(si,t));
    end
end

% Compute the TDR performance
tdr_opt_ana = dot(initial_belief,U_opt(:,1));
tdr_opt_sim = idea_opt_sim(pi_opt);

% Print the TDR performance
fprintf("tdr_opt_ana (idea) = %.4f\n",tdr_opt_ana);
fprintf("tdr_opt_sim (idea) = %.4f\n",tdr_opt_sim);