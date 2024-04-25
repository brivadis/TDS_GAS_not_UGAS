function y = phi(u)
    y = (u>=0) .* ((u>1) + (u<=1).*u);
end