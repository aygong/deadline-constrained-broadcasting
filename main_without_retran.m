clc,clear
% Compare without retransmissions

%% Declare global variables
% N: the number of nodes
% D: the delivery deadline (in time slots)
% lambda: the packet arrival rate
% sigma: the packet success rate
% delta_p: the sampling interval
% NE: the number of independent numerical experiments
global N D lambda sigma delta_p NE
% states: {0,1,2,...,N-1}
% num_state: the cardinality of the set {0,1,2,...,N-1}
% initial_belief: the initial activity belief (realistic)
% actions: {0,Δp,2Δp,...,1} (the discretized action space)
% num_action: the cardinality of the set {0,Δp,2Δp,...,1}
global states num_state initial_belief actions num_action
% transF: the state transition function
% rewards: the rewards
% obserF: the observation function
global transF rewards obserF

delta_p = 1e-4;
NE = 1e+7;

%% Define local variables
% tdr_opt_ana: the TDR of the optimal scheme (idealized)
% tdr_myo_ana: the TDR of the myopic scheme (idealized)
% tdr_heu_sim: the TDR of the proposed heuristic scheme (realistic)
% tdr_sta_ana: the TDR of the optimal static scheme (realistic)
% tdr_myo_sim: the TDR of the myopic scheme (realistic)
% ana -> analytical, sim -> simulation
tdr_opt_ana = zeros(2,6);
tdr_myo_ana = zeros(2,6);
tdr_heu_sim = zeros(2,6);
tdr_sta_ana = zeros(2,6);
tdr_myo_sim = zeros(2,6);

%% Compute the TDR performance
evaluation_parameter = 1;
switch evaluation_parameter
    case 1
        % case 1: the packet arrival rate
        Ns = 50;
        Ds = [10,20];
        lambdas = 0.1:0.06:0.4;
        sigmas = 0.9;
        disp('-> Choose the packet arrival rate');
    case 2
        % case 2: the delivery deadline
        Ns = 50;
        Ds = 10:2:20;
        lambdas = 0.25;
        sigmas = [0.8,1];
        disp('-> Choose the delivery deadline');
    case 3
        % case 3: the packet success rate
        Ns = 50;
        Ds = 15;
        lambdas = [0.1,0.4];
        sigmas = 0.8:0.04:1;
        disp('-> Choose the packet success rate');
    otherwise
        disp('-! Wrong value\n');
end

for row = 1:2
    for col = 1:6
        % Set the network model
        switch evaluation_parameter
            case 1
                N = Ns;
                D = Ds(row);
                lambda = lambdas(col);
                sigma = sigmas;
                fprintf("-> row = %d, col = %.2f\n",D,lambda);
            case 2
                N = Ns;
                D = Ds(col);
                lambda = lambdas;
                sigma = sigmas(row);
                fprintf("-> row = %.2f, col = %d\n",sigma,D);
            case 3
                N = Ns;
                D = Ds;
                lambda = lambdas(row);
                sigma = sigmas(col);
                fprintf("-> row = %.2f, col = %.2f\n",lambda,sigma);
            otherwise
                break
        end
        
        % Set the MDP and POMDP
        states = 0:N-1;
        num_state = length(states);
        initial_belief = binopdf(states,N-1,lambda);
        actions = 0:delta_p:1;
        num_action = length(actions);
        [transF,rewards,obserF] = function_computing();
        
        % Compute the numerical results
        tdr_opt_ana(row,col) = idea_opt_ana();
        tdr_myo_ana(row,col) = idea_myo_ana();
        tdr_heu_sim(row,col) = real_heu_sim();
        tdr_sta_ana(row,col) = real_sta_ana();
        tdr_myo_sim(row,col) = real_myo_sim();
    end
end