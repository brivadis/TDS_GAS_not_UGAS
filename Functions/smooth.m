function [Ty, y] = smooth(u, Tw, eps)

    y = u;
    Ty = Tw;

    n = size(Tw, 1);
    ts = find(diff(u))';
    nts = size(ts, 2);

    for k = 1:nts
        i = ts(k);
        t = Tw(i);
        i1 = i;
        while (i1 > 0) && (t - Tw(i1) < eps)
            i1 = i1-1;
        end
        i1 = max(0, i1 + 1);
        i2 = i+1;
        while (i2 <= n) && (Tw(i2) - t < eps)
            i2 = i2+1;
        end
        i2 = min(n, i2 - 1);
        if i1 < i2
            for j = i1:i2
                y(j) = interp1([Tw(i1), Tw(i2)], [u(i), u(i+1)], Tw(j));
            end
        else
            y(i1) = u(i1);
        end
    end
end