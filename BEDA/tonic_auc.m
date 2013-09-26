%% tonic_auc.m
data = csvread('input.csv');
data = exp_smooth(data, 0.01)

rate = 32;
window_len = 60 * rate; % a number of data per window
start_index = 1;
N = length(data);

x1 = [];
y1 = [];

sum_output = 0;
num_output = 0;
while start_index < N
  end_index = start_index + window_len - 1;
  if end_index > N
    end_index = N;
  end
  window_data = data(start_index:end_index);
  value = getFeatures1Dcont(window_data, 'auc');
  %             fprintf('%d to %d = %f\n', start_index, end_index, value);
  start_index = start_index + window_len * 0.5;
  x1 = [x1; start_index];
  y1 = [y1; value];
  sum_output = sum_output + value;
  num_output = num_output + 1;
end

output = sum_output / num_output
csvwrite('output.csv', output);
csvwrite('output2.csv', [(x1/32)/(1440*60), x1/32, x1, y1])
exit();
