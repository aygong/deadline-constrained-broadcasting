function [tdr_myo_ana] = idea_myo_ana()
% Analyze the myopic scheme (idealized)
% Declare global variables
% See main_without_retran.m
global D
global num_state initial_belief actions
global transF rewards

% Compute the expected total reward from slot 1 to slot D
% U_myo: the value function corresponding to the myopic policy
% pi_myo: the myopic policy
U_myo = zeros(num_state,D+1);
pi_myo = zeros(num_state,1);
for si = 1:num_state % si: the index of the state at the present slot
    [U_myo(si,D),pi_myo(si)] = max(rewards(si,:));
end
for t = D-1:-1:1
    for si = 1:num_state % si: the index of the state at the present slot
        U_myo(si,t) = rewards(si,pi_myo(si))+transF(si,:,pi_myo(si))*U_myo(:,t+1);
    end
end
pi_myo = actions(pi_myo);

% Compute the TDR performance
tdr_myo_ana = dot(initial_belief,U_myo(:,1));
tdr_myo_sim = idea_myo_sim(pi_myo);

% Print the TDR performance
fprintf("tdr_myo_ana (idea) = %.4f\n",tdr_myo_ana);
fprintf("tdr_myo_sim (idea) = %.4f\n",tdr_myo_sim);