function y = g(x, u, A0, A1)
    y = (1 + x(1).^2 + x(2).^2) .* (u*A1 + (1-u)*A0) * x;
end