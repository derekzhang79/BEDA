%% Analysis on peaks - xcode
data = csvread('input.csv');
data = exp_smooth(data, 0.01)
[y1, x1] = findpeaks(data, 'MINPEAKDISTANCE', 500);
csvwrite('output.csv', length(x1)  );
[m,n] = size(x1);
if m == 1
  y1 = y1';
  x1 = x1';
end
[x1/8, x1, y1]
csvwrite('output2.csv', [(x1/8)/(1440*60), x1/8, x1, y1])
exit();
