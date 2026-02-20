clear; clc; close all;

%% 1. Setup Parameters
Fs = 1000;              % Sampling frequency (Hz)
T = 2;                  % Duration (seconds)
t = 0:1/Fs:T-1/Fs;      % Time vector
L = length(t);          % Length of signal
nfft = 2^nextpow2(L);   % Next power of 2 for efficient FFT
f = Fs*(0:(nfft/2))/nfft; % Frequency vector

% Initialize figure
figure('Name', 'Power Spectral Density of Signals', 'NumberTitle', 'off');

%% 2. Define Signals
signals = cell(8,1);
names = {'Pulse', 'Triangle', 'Sine', 'Cosine', 'Exp(-5t)', 'Sinc(5t)', ...
         'Modulated Sine 1', 'Modulated Sine 2'};

signals{1} = abs(t-1) <= 0.2;                               % Pulse (centered at 1s)
signals{2} = (1 - abs(t-1)) .* (abs(t-1) <= 1);             % Triangle
signals{3} = sin(2*pi*10*t);                                % Sine (10 Hz)
signals{4} = cos(2*pi*10*t);                                % Cosine (10 Hz)
signals{5} = exp(-5 * t);                                   % Decaying Exponential
signals{6} = sinc(5*(t-1));                                 % Sinc
signals{7} = sin(2*pi*10*t) .* sin(100*t);                  % Modulated 1
signals{8} = (sin(2*pi*10*t) + sin(2*pi*20*t)) .* sin(100*t);% Modulated 2

%% 3. Calculate PSD and Plot
for i = 1:8
    % Compute FFT
    X = fft(signals{i}, nfft);
    
    % Calculate PSD: |X(f)|^2 / (Fs * L)
    % This normalizes the power relative to the sampling frequency and length
    psd_val = (1/(Fs*L)) * abs(X(1:nfft/2+1)).^2;
    psd_val(2:end-1) = 2*psd_val(2:end-1); % Conserve energy for single-sided spectrum
    
    % Plotting in Decibels (dB/Hz) for better visibility of dynamic range
    subplot(4, 2, i);
    plot(f, 10*log10(psd_val + eps), 'LineWidth', 1.2); % added eps to avoid log(0)
    title(names{i});
    xlabel('Freq (Hz)'); ylabel('dB/Hz');
    grid on;
    axis([0 200 -100 10]); % Focus on lower frequencies where the action is
end