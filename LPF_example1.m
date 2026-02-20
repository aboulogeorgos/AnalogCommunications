clear; clc; close all;

%% 1. Parameters & Filter Setup
Fs = 1000;              % Sampling Freq
T_total = 2;            % Duration
t = 0:1/Fs:T_total-1/Fs;
L = length(t);
f = Fs*(0:(L/2))/L;

% Define R and C
R = 1000;               % 1 kOhm
C = 10e-6;              % 10 uF
tau = R*C;              % Time constant
fc = 1/(2*pi*tau);      % Cutoff frequency (~15.9 Hz)

% Define Transfer Function H(s) = 1 / (tau*s + 1)
num = 1;
den = [tau 1];
sys = tf(num, den);

%% 2. Define Input Signals
inputs = {
    abs(t-0.5) <= 0.2,                          % 3.1 Pulse
    (1 - abs(t-1)) .* (abs(t-1) <= 1),          % 3.2 Triangle
    sin(2*pi*10*t),                             % 3.3 Sine (Below fc)
    cos(2*pi*50*t),                             % 3.4 Cosine (Above fc)
    exp(-5*t),                                  % 3.5 Exponential
    sinc(5*(t-1)),                              % 3.6 Sinc
    sin(2*pi*10*t).*sin(2*pi*100*t),            % 3.7 Modulated 1
    (sin(2*pi*10*t)+sin(2*pi*20*t)).*sin(2*pi*100*t) % 3.8 Modulated 2
};
names = {'Pulse','Triangle','Sine','Cosine','Exp','Sinc','Mod 1','Mod 2'};

%% 3. Simulation and PSD Calculation
figure('Name', 'RC Filter Analysis', 'Units', 'normalized', 'Position', [0.1 0.1 0.8 0.8]);

for i = 1:8
    u = inputs{i};
    
    % Time Domain Response
    y = lsim(sys, u, t);
    
    % Power Density (PSD) Calculation
    U_fft = fft(u)/L;
    Y_fft = fft(y)/L;
    psd_in = abs(U_fft(1:L/2+1)).^2;
    psd_out = abs(Y_fft(1:L/2+1)).^2;
    
    % Plotting Time Domain
    subplot(8, 2, 2*i-1);
    plot(t, u, 'r', t, y, 'b', 'LineWidth', 1);
    title([names{i} ' (Time Domain)']);
    if i==8, xlabel('Time (s)'); end
    legend('In', 'Out', 'FontSize', 7);
    
    % Plotting PSD (Frequency Domain)
    subplot(8, 2, 2*i);
    semilogy(f, psd_in, 'r', f, psd_out, 'b', 'LineWidth', 1);
    hold on; xline(fc, '--k', 'f_c'); hold off;
    title([names{i} ' (PSD)']);
    grid on; axis tight;
    if i==8, xlabel('Freq (Hz)'); end
end