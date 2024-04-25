function state = initial(t, x0, u_interp, tau_M, eps1, eps2)

    if t <= -1+tau_M
        z10 = 1;
        z20 = 1;
    else

        if t >= 1-tau_M
            z10 = 0;
        else
%             [~, I] = min(abs(Tw - t - 1 + tau_M));
            z10 = u_interp(t+1-tau_M);
        end

        if t > -1+eps2
            z20 = 0;
        else
            z20 = 1 - (t+1)/eps2;
        end
    end

    state = [x0; z10; z20];
   
end