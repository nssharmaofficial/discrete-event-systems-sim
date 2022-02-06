%% 5-th question
% Verifing λeff = μeff

load Saved_data\Mean_and_Variance_N10000.mat
pi_est = x_mean_10000;

lambda_eff = lambda*(pi_est(1)+pi_est(2)+pi_est(3)+pi_est(5)+pi_est(9));
mu2_eff = mu2*(pi_est(2)+pi_est(4)+pi_est(5)+pi_est(7)+pi_est(8)+pi_est(9)+pi_est(10)+pi_est(11));

if abs(lambda_eff-mu2_eff) <= 0.001
    fprintf('The condition λeff = μeff is verified with difference %f\n',abs(lambda_eff-mu2_eff));
    fprintf('λeff corresponds to  %f [arrivals/minutes] \n',lambda_eff);
    fprintf('μeff corresponds to  %f [services/minutes] \n',mu2_eff);
    disp('The number of observations needed was N = 10000, with M=1000 estimations');
else
    fprintf('The difference between λeff and μeff exceeds 0.001, indeed it is %f \n',abs(lambda_eff-mu2_eff));
end
