%% 5-th question
disp(' ');

% Verifing λeff = μeff

%load Saved_data\Mean_and_Variance_N10000.mat
%pi_est = x_mean_10000;
% 
% lambda_eff = lambda*(pi_est(1)+pi_est(2)+pi_est(3)+pi_est(5)+pi_est(9));
% mu2_eff = mu2*(pi_est(2)+pi_est(4)+pi_est(5)+pi_est(7)+pi_est(8)+pi_est(9)+pi_est(10)+pi_est(11));
% 
% if abs(lambda_eff-mu2_eff) <= 0.001
%     fprintf('The condition λeff = μeff is verified with difference %f\n',abs(lambda_eff-mu2_eff));
%     fprintf('λeff corresponds to  %f [arrivals/minutes] \n',lambda_eff);
%     fprintf('μeff corresponds to  %f [services/minutes] \n',mu2_eff);
%     disp('The number of observations needed was N = 10000, with M=1000 estimations');
% else
%     fprintf('The difference between λeff and μeff exceeds 0.001, indeed it is %f \n',abs(lambda_eff-mu2_eff));
% end


%% 5th question
close all;
disp(' ');
%% Parameters of the simulations
kmax = 100; % maximum event index
N = 10000; % number of observations
M = 1000; % number of estimation

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
        load Saved_data\5thquestion
end

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
    counter_dep_m = zeros(M,1); 
    counter_arr_m = zeros(M,1);
    for j = 1:M
        counter_dep = zeros(N,1); 
        counter_arr = zeros(N,1);
        state_counter = zeros(N,n);

        Progress
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
        
            % data for 4th question
            a = 0; arr = 0; dep = 0;

            for t_idx=1:length(T)
                if (T(t_idx)<=t_delta && T(t_idx+1)>t_delta) 
                   state_counter(i,X(t_idx)) = 1;
                   a = t_idx+1;
                end
            end

            for a_idx = a : kmax
                if E(a_idx) == 1 && (~ismember(X(a_idx),[4,6,7,8,10,11]))
                    arr = arr + 1;
                elseif E(a_idx) == 3
                   dep = dep + 1;     
                end
            end
            counter_arr(i)=arr/(T(end)-T(a));
            counter_dep(i)=dep/(T(end)-T(a));

        end
        counter_arr_m(j)=mean(counter_arr(i));
        counter_dep_m(j)=mean(counter_dep(i));
        % compute each state's probability after N observations
        for x = 1 : n
            px_est(j,x) = sum(state_counter(:,x))./N ;
        end
    end
    disp(' Simulations completed'), disp('');

    %%
    lam=mean(counter_arr_m);
    mu=mean(counter_dep_m);
    save('5thquestion','lam','mu');

end
lambda_eff = lam;
mu_eff = mu;
if abs(lambda_eff-mu_eff) <= 0.001
    fprintf('The condition λeff = μeff is verified with difference %f\n',abs(lambda_eff-mu_eff));
    fprintf('λeff corresponds to  %f [arrivals/minutes] \n',lambda_eff);
    fprintf('μeff corresponds to  %f [services/minutes] \n',mu_eff);
    fprintf('The number of observations needed was N = %d , with M = %d estimations\n',N, M);
else
    fprintf('The difference between λeff and μeff exceeds 0.001, indeed it is %f \n',abs(lambda_eff-mu_eff));
end
