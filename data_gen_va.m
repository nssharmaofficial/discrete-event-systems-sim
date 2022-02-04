%% this function is used to answer the 7th question
% generation of the arrivals

function [va_sim] = data_gen_va(M)
    load Saved_data\dati_gruppo_07.mat
        
    [F_va,X_va] = ecdf(Va);
    U = unifrnd(0,1,1,M);
    va_sim = interp1(F_va,X_va,U);
end


