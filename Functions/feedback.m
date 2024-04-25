function u = feedback(w)
    u = double(w(:,1).*w(:,2)>=0);
end