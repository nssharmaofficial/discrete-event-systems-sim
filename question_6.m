%% 6-th question
% Estimate E__x, E_lambda, E_s for the subsystem E formed by M2
% (means calcultated at time t_delta)

close all
disp(' ');
%% Parameters of the simulations
kmax = 1000; % maximum event index
N = 10; % number of observations
M = 10; % number of estimation

L = kmax;
sz = [3 L];
V=zeros(3,L);

%% Simulations
px_est = zeros(M,11);

sim = menu('Do you want to start a new simulation or look at the saved data?','Start a new simulation','Look at the saved data');
switch sim
    case 1
        str = "Simulation on";
    case 2
        str = "Simulation off";
        load Saved_data\6thquestion.mat
end


%states' configuration
states = [0 0 0; 0 0 1; 0 1 0; 2 0 1; 0 1 1; 1 1 0; 2 1 1; 1 1 1; 0 2 1; 2 2 1; 1 2 1]';

if str == "Simulation on"
    % MULTIPLE SIMULATIONS
    disp('MULTIPLE SIMULATIONS'), disp(' ');

    n_q = menu('N = ?','10','100','1000');
    switch n_q
        case 1
            N = 10;
        case 2
            N = 100;
        case 3
            N=1000;
    end

    m_q = menu('M = ?','10','100','1000');
    switch m_q
        case 1
            M = 10;
        case 2
            M = 100;
        case 3
            M = 1000;
    end

    k_q = menu('kmax = ?','50','100','500');
    switch k_q
        case 1
            kmax = 50;
        case 2
            kmax = 100;
        case 3
            kmax = 500;
    end

    L = kmax;
    sz = [3 L];
    V=zeros(3,L);

    disp(' Simulations in progress...')
    E_s = [];
    index = 1;
    aver_arr_m = zeros(M,1);
    part_in_m = zeros(M,1);
    for j = 1:M
        state_counter = zeros(N,n);
        aver_arr = zeros(N,1);
        part_in_n = zeros(N,1);
        % Progress
        if ismember(j,0:round(M/20):M)
            disp([ '   Progress ' num2str(j/M*100) '%' ])
        end
        for i = 1:N    
            % initialization clock structure randomly
            V(1,:) = exprnd(1/lambda,[1 L]);
            V(2,:) = exprnd(1/mu1,[1 L]);
            V(3,:) = exprnd(1/mu2,[1 L]);
        
            % Simulation
            [E,X,T] = simprobdes(model,V);
            
            h=0;  % for computing index k after t_delta
            for t_idx=1:length(T)
                if (T(t_idx)<=t_delta && T(t_idx+1)>t_delta) 
                   state_counter(i,X(t_idx+1)) = 1;
                   h = t_idx+1;
                end
            end
            
            % for estimating system time and average rate of customers admitted
            arr = 0;

            for k=h:length(X)-1
                if (((X(k-1)==1 && X(k) == 2) || (X(k-1)==3 && X(k) == 5)))
                     arr = arr + 1;
                     t0 = T(k);
                     % till d2 occurs
                     for y = k : length(X)-1
                         if (E(y)==3)
                             tf = T(y+1);
                             E_s(index) = tf-t0;
                             index = index + 1;
                             %k = y;
                             break
                         end
                     end
                    
                elseif ((X(k) == 5 && X(k-1) == 6) || (X(k) == 2 && X(k-1) == 3))
                    arr = arr + 1;
                    t0 = T(k);
                    % till d2 occurs
                    for y = k :length(X)-1
                         if (E(y)==3)  % d2
                             tf = T(y+1); % tolgo il +1
                             E_s(index) = tf-t0;
                             index = index + 1;
                             %k = y;
                             break
                         end
                     end

                elseif (E(k) == 3 && ismember(X(k),[4,7,9,10,11]))
                    arr = arr + 1;
                    t0 = T(k+1);
                    % till d2 occurs
                    for y = k+1 :length(X)-1
                         if (E(y)==3)
                             tf = T(y+1);
                             E_s(index) = tf-t0;
                             index = index + 1;
                            % k = y;
                             break
                         end
                     end
         
                end
            end

            aver_arr(i) = arr / (T(kmax)-T(h));

            % for estimating average number of customers in the system 
            part_inside = 0;
            for k=h:length(X)-1
                if states(3,X(k)) == 1
                    part_inside = part_inside + 1*(T(k+1)-T(k));
                end
            end

            part_in_n(i) = part_inside /(T(kmax)-T(h));
        end
        part_in_m(j) = mean (part_in_n);
        aver_arr_m(j) = mean(aver_arr);
        % compute each state's probability after N observations
        for x = 1 : n
            px_est(j,x) = sum(state_counter(:,x))./N ;
        end
    end
    disp(' Simulations completed'), disp('');

    %% Compute mean
    pi_est = mean(px_est);
  
    %% Plot state probabilities
    save('6thquestion','E_s','pi_est');
    
    E_s_sim = mean(E_s); % estimated by sim
    E_x_sim = mean(part_in_m);
    E_lam_sim = mean(aver_arr_m);
end

%computed analytically
% E_x = 0*(pi(1)+pi(3)+pi(6))+1*(pi(2)+pi(4)+pi(5)+pi(7)+pi(8)+pi(9)+pi(10)+pi(11));
% E_lambda =  lambda*q*(pi(1)+pi(3))+ mu1*(pi(6)+pi(3)) + mu2*(pi(4)+pi(7)+pi(9)+pi(10)+pi(11)); % for M2
% Es = E_x/ E_lambda; % for verifing the little's Law

%by simulations
E_x_est = 0*(pi_est(1)+pi_est(3)+pi_est(6))+1*(pi_est(2)+pi_est(4)+pi_est(5)+pi_est(7)+pi_est(8)+pi_est(9)+pi_est(10)+pi_est(11));
E_lam_est =  lambda*q*(pi_est(1)+pi_est(3))+ mu1*(pi_est(6)+pi_est(3)) + mu2*(pi_est(4)+pi_est(7)+pi_est(9)+pi_est(10)+pi_est(11)); 
E_s_est= E_x_est/ E_lam_est; % for verifing the values

E_s_check = E_x_sim / E_lam_sim;
% E_s_diff = abs(E_s_sim-E_s_est);
E_s_diff = abs(E_s_sim-E_s_check);

fprintf('E[S_sigma] estimated is equal to %f min\n',E_s_sim);
fprintf('E[X_sigma] estimated is equal to %f parts\n' ,E_x_sim);
fprintf('λ_sigma estimated is equal to %f arrivals/min \n',E_lam_sim);
% Verify of the little's Law
if E_s_diff<=0.01
    fprintf('The Littles law is verified with an error not exceeding 0.01, indeed the difference is %f \n',E_s_diff);
else
    fprintf('The Littles law is not verified with an error exceeding 0.01, indeed it is %f \n',E_s_diff);
end
