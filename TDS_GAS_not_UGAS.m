clear all;
close all;

addpath('Functions');

% Turn off warnings due to finite-time explosion of ODEs emulated by ode45:
warning('off','all')

tmax = 35; % time of experience

% Define the switching system (7) of ...
% "J.L. Mancilla-Aguilar and H. Haimovich. Forward completeness does
% not imply bounded reachability sets and global asymptotic stability
% is not necessarily uniform for time-delay systems. arXiv preprint
% arXiv:2308.07130, 2023."

A0 = [-0.1, 0.5; -2, 0];
A1 = [0, 2; -0.5, -0.1];
delays = [1, 2];

% Initial condition:
x0 = [0;0.5];




% define figure properties
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.width      = 8;
opts.height     = 4;
opts.fontType   = 'Times';
opts.fontSize   = 9;
P = [1, 2, 4];
Colors = {[0.7 0.7 0.7], [0.6 0.6 0.6], [0 0 0]};


% eps1 = 0.01;
fig = figure;
for p = 1:3
        
    eps1 = 10^(-P(p));
    eps2 = 0.1;

    % Compute the feedback law that induces explosion
    options = odeset('RelTol', 10^(-8));
    Tmax = 100;
    [Tw, ~] = ode45(@(t, w) g(w, feedback(w'), A0, A1), [0, Tmax], x0, options);

    % Parameter c to induce explosion at t=1:
    c = Tw(end);

    % Compute once more the correcponding solution:
    [Tw, w] = ode45(@(t, w) c*g(w, feedback(w'), A0, A1), [0, 1], x0, options);
    u = feedback(w);
    nTinit = 2*size(Tw, 1);
    
    % Not necessary in numerical simulations.:
    % M = 10;
    tau_M =0;
    
    
    % Smmothing process of z_10:
    [Tw_smooth, u] = smooth(u, Tw, eps1);
    u_interp = griddedInterpolant(Tw_smooth,u);
    
    
    % Solve the time delay system:
    f = @(t, state, state_delay) syst(state, state_delay, A0, A1, c);
    sol = dde23(f, delays, @(t) initial(t, x0, u_interp, tau_M, eps1, eps2), [0, tmax]);
    T = sol.x';
    state = sol.y';
    
    % Compute and store the state and its norm:
    Tinit = linspace(-max(delays),0,nTinit)';
    Tinit = Tinit(1:end-1);
    nTinit = nTinit - 1;
    state_init = zeros(nTinit, 4);
    for i = 1:nTinit
        state_init(i, :) = initial(Tinit(i), x0, u_interp, tau_M, eps1, eps2)';
    end
    Ttot = [Tinit; T];
    state_tot = [state_init(:, :); state(:, :)];
    norm_full_state_tot = sqrt(state_tot(:, 1).^2+state_tot(:, 2).^2+state_tot(:, 3).^2+state_tot(:, 4).^2);
    
    % Add to plot:
    plot(Ttot, norm_full_state_tot, 'color', Colors{p}, 'Linewidth', 1.5)
    hold on


end

hold on
% Plot axis y = 1:
plot([-max(delays), tmax], [1, 1], 'black-.', 'Linewidth', 1.5)
axis([0, tmax, 0, 15])

xlabel('Time', 'interpreter', 'latex', 'FontSize', 12)
ylabel('Norm of the state', 'interpreter', 'latex', 'FontSize', 12)
% legend({'$\varepsilon = 10^{-1}$', '$\varepsilon = 10^{-2}$', '$\varepsilon = 10^{-5}$'}, 'interpreter', 'latex', 'FontSize', 14)


% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;
% set text properties
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     9);
% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))

% save:
print('graph', '-dpdf')
print('graph', '-deps')