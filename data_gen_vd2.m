%% this function is used to answer the 7th question
% generation of termination 2nd event

function [vd2_sim] = data_gen_vd2(M)
    load Saved_data\dati_gruppo_07.mat
    
    [F_vd2,X_vd2] = ecdf(Vd2);
    U = unifrnd(0,1,1,M);
    vd2_sim = interp1(F_vd2,X_vd2,U);
end
