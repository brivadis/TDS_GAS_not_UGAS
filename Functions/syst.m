function dstate = syst(state, state_delay, A0, A1, c)

    x = state(1:2);
    z1 = state(3);
    z2 = state(4);

    z1_d1 = state_delay(3, 1);
    z2_d2 = state_delay(4, 2);
    
    dx = c*phi(z2_d2)*g(x, phi(z1_d1), A0, A1) + c*(1-phi(z2_d2))*A0*x;
    dz1 = - z1;
    dz2 = - z2;

    dstate = [dx; dz1; dz2];
end