clc, clear
% Compare with retransmissions

%% Declare global variables
% N: the number of nodes
% D: the delivery deadline (in time slots)
% lambda: the packet arrival rate
% sigma: the packet success rate
% delta_p: the sampling interval
% NE: the number of independent numerical experiments
% K: the number of copies of every packet to be transmitted
global N D lambda sigma delta_p NE K
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
% tdr_heuR_sim: the TDR of the proposed heuristic scheme (realistic)
% Kopt_heuR_sim: the optimal values of K that maximize the TDR
%                of the proposed heuristic scheme (realistic)
% tdr_staR_sim: the TDR of the optimal static scheme (realistic)
% Kopt_staR_sim: the optimal values of K that maximize the TDR
%                of the optimal static scheme (realistic)
% ana -> analytical, sim -> simulation
tdr_heuR_sim = zeros(2, 6);
Kopt_heuR_sim = zeros(2, 6);
tdr_staR_sim = zeros(2, 6);
Kopt_staR_sim = zeros(2, 6);

%% Compute the TDR performance
evaluation_parameter = 1;
switch evaluation_parameter
    case 1
        % case 1: the packet arrival rate
        Ns = 50;
        Ds = [10, 20];
        lambdas = 0.1:0.06:0.4;
        sigmas = 0.9;
        disp('-> Choose the packet arrival rate');
    case 2
        % case 2: the delivery deadline
        Ns = 50;
        Ds = 10:2:20;
        lambdas = 0.25;
        sigmas = [0.8, 1];
        disp('-> Choose the delivery deadline');
    case 3
        % case 3: the packet success rate
        Ns = 50;
        Ds = 15;
        lambdas = [0.1, 0.4];
        sigmas = 0.8:0.04:1;
        disp('-> Choose the packet success rate');
    otherwise
        error('Unexpected evaluation parameters.');
end

for row = 1:2
    % tdr_heuK_sim: the TDR of the proposed heuristic scheme (realistic)
    %               with different values of K
    % tdr_staK_sim: the TDR of the optimal static scheme (realistic)
    %               with different values of K
    tdr_heuK_sim = zeros(20, 6);
    tdr_staK_sim = zeros(20, 6);
    
    for col = 1:6
        % Set the network model
        switch evaluation_parameter
            case 1
                N = Ns;
                D = Ds(row);
                lambda = lambdas(col);
                sigma = sigmas;
                fprintf("-> D = %d, lambda = %.2f\n", D, lambda);
            case 2
                N = Ns;
                D = Ds(col);
                lambda = lambdas;
                sigma = sigmas(row);
                fprintf("-> sigma = %.2f, D = %d\n", sigma, D);
            case 3
                N = Ns;
                D = Ds;
                lambda = lambdas(row);
                sigma = sigmas(col);
                fprintf("-> lambda = %.2f, sigma = %.2f\n", lambda, sigma);
            otherwise
                error('Unexpected evaluation parameters.');
        end

        % Set the MDP and POMDP
        states = 0:N-1;
        num_state = length(states);
        initial_belief = binopdf(states, N-1, lambda);
        actions = 0:delta_p:1;
        num_action = length(actions);
        [transF, rewards, obserF] = function_computing();
        
        % Enumerate the numerical results
        for K = 1:D
            tdr_heuK_sim(K, col) = real_heuR_sim();
            tdr_staK_sim(K, col) = real_staR_sim();
        end
        
        % Compute the optimal results
        [tdr_heuR_sim(row, col), Kopt_heuR_sim(row, col)] = max(tdr_heuK_sim(:, col));
        [tdr_staR_sim(row, col), Kopt_staR_sim(row, col)] = max(tdr_staK_sim(:, col));
        
        % Print the optimal results
        fprintf("tdr_heuR_sim (real) = %.4f, Kopt_heuR = %d\n",...
            tdr_heuR_sim(row, col), Kopt_heuR_sim(row, col));
        fprintf("tdr_staR_sim (real) = %.4f, Kopt_staR = %d\n",...
            tdr_staR_sim(row, col), Kopt_staR_sim(row, col));
    end
end