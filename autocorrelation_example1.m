clear; clc; close all;

%% 1. Setup Parameters
Fs = 1000;              % Sampling frequency
T = 2;                  % Duration
t = -T:1/Fs:T;          % Time vector centered at 0

% Initialize a figure for plotting
figure('Name', 'Autocorrelation of Various Signals', 'NumberTitle', 'off');

%% 2. Define Signals
signals = cell(8,1);
names = {'Pulse', 'Triangle', 'Sine', 'Cosine', 'Exp(-5t)', 'Sinc(5t)', 'Modulated Sine 1', 'Modulated Sine 2'};

% 1. Pulse (Rectangular)
signals{1} = abs(t) <= 0.5; 

% 2. Triangle
signals{2} = (1 - abs(t)) .* (abs(t) <= 1);

% 3. Sine (10 Hz)
signals{3} = sin(2*pi*10*t);

% 4. Cosine (10 Hz)
signals{4} = cos(2*pi*10*t);

% 5. Exponential (Decaying)
signals{5} = exp(-5 * abs(t)); % Using abs(t) to ensure it decays both ways for a stable window

% 6. Sinc(5t)
signals{6} = sinc(5*t);

% 7. sin(2*pi*10*t) * sin(100*t)
signals{7} = sin(2*pi*10*t) .* sin(100*t);

% 8. Combined Modulated Signal
signals{8} = sin(2*pi*10*t) .* sin(100*t) + sin(2*pi*20*t) .* sin(100*t);

%% 3. Calculate and Plot
for i = 1:8
    % Calculate autocorrelation
    % 'coeff' normalizes the sequence so that the auto-correlation at zero lag is 1.0.
    [R, lags] = xcorr(signals{i}, 'coeff');
    tau = lags/Fs; % Convert lags to time offset (tau)
    
    % Plotting
    subplot(4, 2, i);
    plot(tau, R, 'LineWidth', 1.2);
    title(names{i});
    xlabel('\tau (lag)'); ylabel('R_{xx}(\tau)');
    grid on;
    axis tight;
end