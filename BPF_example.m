clear; clc; close all;

%% 1. Parameters & Filter Setup
Fs = 1000;              % Sampling Freq
T_total = 2;            % Duration
t = 0:1/Fs:T_total-1/Fs;
L = length(t);
f = Fs*(0:(L/2))/L;

% Define Bandpass Filter Specifications
f_center = 60;          % Center frequency (Hz)
bw = 20;                % Bandwidth (Hz)
[num, den] = butter(2, [f_center-bw/2, f_center+bw/2]/(Fs/2), 'bandpass');
sys = tf(num, den, 1/Fs); % Discrete-time system

%% 2. Define Input Signals
% (Adjusting frequencies to interact interestingly with a 60Hz BPF)
inputs = {
    abs(t-0.5) <= 0.05,                         % Pulse (Short)
    (1 - abs(t-1)) .* (abs(t-1) <= 1),          % Triangle
    sin(2*pi*60*t),                             % Sine (Exactly at center)
    sin(2*pi*10*t),                             % Sine (Far below - should be blocked)
    exp(-5*t),                                  % Exponential (Mostly low freq)
    sinc(50*(t-1)),                             % Sinc (Wide freq spread)
    sin(2*pi*10*t).*cos(2*pi*60*t),             % Modulated 1 (Carrier at 60Hz)
    sin(2*pi*150*t)                             % Sine (Far above - should be blocked)
};
names = {'Pulse','Triangle','60Hz Sine','10Hz Sine','Exp','Sinc','Modulated 60Hz','150Hz Sine'};

%% 3. Simulation and PSD Calculation
figure('Name', 'Bandpass Filter Analysis', 'Units', 'normalized', 'Position', [0.1 0.05 0.8 0.9]);

for i = 1:8
    u = inputs{i};
    
    % Filter the signal
    y = filter(num, den, u);
    
    % Power Density (PSD)
    U_fft = fft(u)/L;
    Y_fft = fft(y)/L;
    psd_in = abs(U_fft(1:L/2+1)).^2;
    psd_out = abs(Y_fft(1:L/2+1)).^2;
    
    % Plotting Time Domain
    subplot(8, 2, 2*i-1);
    plot(t, u, 'r', t, y, 'b', 'LineWidth', 1);
    title([names{i} ' (Time)']);
    axis tight;
    if i==8, xlabel('Time (s)'); end
    
    % Plotting PSD
    subplot(8, 2, 2*i);
    semilogy(f, psd_in, 'r', f, psd_out, 'b', 'LineWidth', 1);
    hold on; 
    xline(f_center - bw/2, '--k'); xline(f_center + bw/2, '--k'); 
    hold off;
    title([names{i} ' (PSD)']);
    grid on; xlim([0 200]);
    if i==8, xlabel('Freq (Hz)'); end
end