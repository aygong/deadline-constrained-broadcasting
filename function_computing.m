function [transF,rewards,obserF] = function_computing()
% Compute the MDP and POMDP functions
% Declare global variables
% See main_without_retran.m
global sigma
global states num_state actions num_action

% Create the state transition function and rewards
transF = zeros(num_state,num_state,num_action);
rewards = zeros(num_state,num_action);

% Compute the state transition function and rewards
parfor ai = 1:num_action % ai: the index of the action at the present slot
    parTransF = zeros(num_state,num_state);
    p = actions(ai); %#ok<*PFGV>
    for si = 1:num_state % si: the index of the state at the present slot
        % Compute the rewards
        rewards(si,ai) = sigma*p*(1-p)^states(si); %#ok<*PFBNS>
        % Compute the transition probabilities
        parTransF(si,1:si) = binopdf(0:states(si),states(si),1-p)*(1-p);
    end
    transF(:,:,ai) = parTransF;
end

% Create the observation function
obserF = zeros(num_state,num_state,2);

% Compute the observation function
for si = 1:num_state % si: the index of the state at the present slot
    for sj = 1:si % sj: the index of the state at the next slot
        switch states(si)-states(sj)
            case 0 
                % the idle channel status
                obserF(si,sj,1) = 1;
            otherwise
                % the busy channel status
                obserF(si,sj,2) = 1;
        end
    end
end