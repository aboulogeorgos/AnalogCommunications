% Demonstration: Energy vs. Power for a Multi-tone Signal
% This script shows that for a persistent signal:
% 1. Total Energy increases linearly with time (tending to infinity).
% 2. Average Power remains constant (finite).
clear; clc;

%% 1. Signal Parameters
Fs = 1000;              % Sampling frequency (Hz)
freqs = [50, 120];      % Frequencies (Hz)
amps  = [2, 1.5];       % Amplitudes
durations = 0.1:0.1:5;  % Observation windows from 0.1s to 5s

% Pre-allocate arrays for results
energy_results = zeros(size(durations));
power_results = zeros(size(durations));

%% 2. Loop through different time windows
for i = 1:length(durations)
    T = durations(i);
    t = 0:(1/Fs):T-(1/Fs);
    
    % Generate signal for the current window
    x = amps(1)*sin(2*pi*t) + amps(2)*sin(2*pi*freqs(2)*t);
    
    % --- THE CALCULATION ---
    % Energy is the integral (sum) of the squared signal. 
    % As the window grows, we add more "squares" to the sum.
    energy_val = sum(abs(x).^2) * (1/Fs);
    
    % Power is Energy divided by Time. 
    % The increase in energy is canceled out by the increase in T.
    power_val = energy_val / T;
    
    % Store results
    energy_results(i) = energy_val;
    power_results(i) = power_val;
end

%% 3. Visualization
subplot(2,1,1);
plot(durations, energy_results, 'r', 'LineWidth', 2);
title('Total Energy vs. Observation Time');
xlabel('Time Window (s)'); ylabel('Energy (Joules)');
grid on;
% JUSTIFICATION: Note how Energy goes UP. If we let time go to 
% infinity, Energy would be infinite. This is why it's NOT an Energy Signal.

subplot(2,1,2);
plot(durations, power_results, 'b', 'LineWidth', 2);
title('Average Power vs. Observation Time');
xlabel('Time Window (s)'); ylabel('Power (Watts)');
ylim([0, sum(amps.^2)]); % Set axis to see stability
grid on;
% JUSTIFICATION: Note how Power stays CONSTANT (around 3.125W). 
% Since Power is finite and non-zero as T -> infinity, it IS a Power Signal.

fprintf('Theoretical Power: %.4f W\n', sum(amps.^2 / 2));
fprintf('Final Calculated Power at T=5s: %.4f W\n', power_results(end));