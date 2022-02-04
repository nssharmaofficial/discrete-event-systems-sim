%% 3th question
close all;
%% Parameters of the simulations
kmax = 90; % maximum event index
N = 100; % number of observations
M = 1000; % number of estimation

L = kmax;
sz = [3 L];
V=zeros(3,L);

% MULTIPLE SIMULATIONS
disp('MULTIPLE SIMULATIONS'), disp(' ');

%% Simulations
px_est = zeros(M,11);

sim = menu('Do you want to start a new simulation or use the saved data?','Start a new simulation','Use the saved data');
switch sim
    case 1
        str = "Simulation on";
    case 2
        str = "Simulation off";
        load Saved_data\Mean_and_Variance.mat
end


if str == "Simulation on"
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
    
    disp(' Simulations in progress...')
    for j = 1:M
        state_counter = zeros(N,n);
    
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
        
            for t_idx=1:length(T)
                if (T(t_idx)<=t_delta && T(t_idx+1)>t_delta) 
                   state_counter(i,X(t_idx)) = 1; 
                end
            end
        end
        % compute each state's probability after N observations
        for x = 1 : n
            px_est(j,x) = sum(state_counter(:,x))./N ;
        end
    end
    disp(' Simulations completed'), disp('');

    %% Compute mean and variance
    x_mean = mean(px_est);
    x_var = var(px_est);


    %% Save variables
    save('Mean_and_Variance','x_mean','x_var','px_est','N');

end %end simulation


%% Loading data from previous simulations

load Saved_data\Mean_and_Variance_N10.mat
x(1)=10;
y(1,:)=x_mean_10;
z(1,:)=x_var_10;

load Saved_data\Mean_and_Variance_N100.mat
x(2)=100;
y(2,:)=x_mean_100;
z(2,:)=x_var_100;

load Saved_data\Mean_and_Variance_N1000.mat
x(3)=1000;
y(3,:)=x_mean_1000;
z(3,:)=x_var_1000;

load Saved_data\Mean_and_Variance_N10000.mat
x(4)=10000;
y(4,:)=x_mean_10000;
z(4,:)=x_var_10000;

%% Plot of variance
figure();

subplot(1,2,1); 
semilogx(x,z');
xlabel('N- in log scale');
ylabel('Variance of \pi');
title('Trend of the variance of \pi');
legend('\pi_1','\pi_2','\pi_3','\pi_4','\pi_5','\pi_6','\pi_7','\pi_8','\pi_9','\pi_1_0','\pi_1_1');

subplot(1,2,2); 
semilogx(x,y');
xlabel('N - in log scale');
ylabel('Mean of \pi');
title('Trend of the mean of \pi');
legend('\pi_1','\pi_2','\pi_3','\pi_4','\pi_5','\pi_6','\pi_7','\pi_8','\pi_9','\pi_1_0','\pi_1_1');
