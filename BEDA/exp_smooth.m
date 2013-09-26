function [output_signal] = exp_smooth(input_signal,alpha)
%EXP_SMOOTH - Computes exponential smoothing of input_signal with alpha
%example:
% [modified_signal] = exp_smooth(skin_conductance,0.08)
% figure;subplot(121);plot(EDA);
% subplot(122);plot(exp_smooth(EDA,0.005))
%Javier Hernandez Rivera, MIT

for i = 2:length(input_signal)
    input_signal(i) = alpha*input_signal(i) + (1-alpha)*input_signal(i-1);
end
output_signal = input_signal;