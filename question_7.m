%% 7th question
close all;

%% Parameters of the simulations
kmax = 500; % maximum event index
N = 1000; % number of simulations
M = 1000;

L = kmax;
sz = [3 L];
V=zeros(3,L);

% MULTIPLE SIMULATIONS
disp('MULTIPLE SIMULATIONS'), disp(' ');

%% Simulations
px_est = zeros(M,11);

q = menu('Do you want to start a new simulation or use the saved data?','Start a new simulation','Use the saved data');
switch q
    case 1
        str = "Simulation on";
    case 2
        str = "Simulation off";
        load Saved_data\7thquestion
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
    disp(' Simulations in progress...')
    for j = 1:M
        state_counter = zeros(n,500000);
        % Progress
        if ismember(j,0:round(M/20):M)
            disp([ '   Progress ' num2str(j/M*100) '%' ])
        end
        for i = 1:N
            %% Definition of the clock structure
             V(1,:)=data_gen_va(kmax);
             V(2,:)=data_gen_vd1(kmax);
             V(3,:)=data_gen_vd2(kmax);
            
            % Simulation
            [E,X,T] = simprobdes(model,V);

            T_vec = 0:0.01:T(end);
            k=2;
            for idx=1:length(T_vec)
                if T_vec(idx)<T(k)
                    state_counter(X(k-1),idx) = state_counter(X(k-1),idx) + 1; 
                else
                    k=k+1;
                    state_counter(X(k-1),idx) = state_counter(X(k-1),idx) + 1;
                end
            end
        end

    end %end simulation
    disp(' Simulations completed'), disp('');

    save('7thquestion','state_counter','N','M','kmax');
end

%% Plot

p_wrt_T = state_counter./N;
figure();
plot(p_wrt_T');
xlabel('time [min]');
ylabel('\pi(t)');
if str == "Simulation on"
    title('\pi(t)');
else
    title('\pi(t) calculated with the measured data, taking N=1000 observations (M=1000)');
end
legend('\pi_1','\pi_2','\pi_3','\pi_4','\pi_5','\pi_6','\pi_7','\pi_8','\pi_9','\pi_1_0','\pi_1_1');