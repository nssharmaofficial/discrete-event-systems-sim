%% question 2

close all
%% check range condition

fprintf('The limit state probs range is between: [%f; %f]\n', pi_range(1),pi_range(2));
for i = 1 : length(pi)
    if (pi(i)>(pi_range(2)) || pi(i)<(pi_range(1)))
        fprintf('This value %f is out of range for state i=%d \n',pi(i), i);
    end
end

%% check time condition
T = 0:0.01:50; %min
% PI = [];
PI = zeros(length(T),n);

i=1;
for t=T
%   PI(end+1,:) = pi0 * expm(Q*t);
    PI(i,:) = pi0 * expm(Q*t);
    i=i+1;
end


%% check on delta interval
for time = length(T) : -1 : 1
        if max(abs(PI(end,:)-PI(time,:)))>=delta
            t_delta=time/100;
            fprintf('This is t_delta [minutes] = %f \n', t_delta);
            break
        end
end

%% plot limit state probabilities
figure(1);
plot(T,PI);
xlabel('time [minutes]');
ylabel('State probabilities');
title('Limit state probabilities');

xl = xline(t_delta,'r-.',{'t_\delta'}); % steady state mark
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
xlim([0 t_delta+10]);
legend('\pi_1','\pi_2','\pi_3','\pi_4','\pi_5','\pi_6','\pi_7','\pi_8','\pi_9','\pi_1_0','\pi_1_1');

%save('Data_test_on_Eps','lambda','mu1','mu2','eps','t_delta');
