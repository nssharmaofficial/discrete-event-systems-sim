%% 4th question
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

counter_rej = 0; %how many times at least five arrivals are rejected
counter_arr = 0;

counter = [];  % for the 2nd way

sim = menu('Do you want to start a new simulation or look at the saved data?','Start a new simulation','Look at the saved data');
switch sim
    case 1
        str = "Simulation on";
    case 2
        str = "Simulation off";
        load Saved_data\4thquestion
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
        counter_rej_2_way = 0;
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
        
            % data for 4th question
            a = 0; b = 0; rej = 0; arr = 0;

            for t_idx=1:length(T)
                if (T(t_idx)<=t_delta && T(t_idx+1)>t_delta) 
                   state_counter(i,X(t_idx)) = 1;
                   a = t_idx+1;
                end
                if T(end)<=2.5*t_delta
                   b = kmax+1;
                elseif (T(t_idx)<=2.5*t_delta && T(t_idx+1)>2.5*t_delta)
                   b = t_idx;
                end
            end

            for a_idx = a : b-1
                if E(a_idx) == 1 
                    arr = arr + 1;
                    if arr == 5
                        counter_arr = counter_arr + 1;
                    end
                    if ismember(X(a_idx),[4,6,7,8,10,11]) 
                        rej = rej + 1;
                        if rej == 5
                            counter_rej = counter_rej + 1;
                            counter_rej_2_way = counter_rej_2_way + 1;
                            break
                        end
                    end
                end
            end

        end
        counter(j) = counter_rej_2_way/N;

        % compute each state's probability after N observations
        for x = 1 : n
            px_est(j,x) = sum(state_counter(:,x))./N ;
        end
    end
    disp(' Simulations completed'), disp('');

    %%
    p_five_arr_rejected = counter_rej /(N*M);
    p_five_arr = counter_arr / (N*M);
    p_five_arr_rejected_2_way = mean(counter);

    save('4thquestion','p_five_arr_rejected','p_five_arr');
end

fprintf('\n The estimated probability that at least five arriving parts are rejected over the interval [t_delta; 2.5*t_delta] is %f \n',p_five_arr_rejected);
