%% this function is used to answer the 7th question
% generation of termination 1st event

function [vd1_sim] = data_gen_vd1(M)
    load Saved_data\dati_gruppo_07.mat
    
    [F_vd1,X_vd1] = ecdf(Vd1);
    U = unifrnd(0,1,1,M);
    vd1_sim = interp1(F_vd1,X_vd1,U);
end


