%% Analysis on peaks - xcode
data = csvread('input.csv');
[y1, x1] = findpeaks(data, 'MINPEAKDISTANCE', 400, 'MINPEAKHEIGHT', 0.5);
csvwrite('output.csv', length(x1)  );
[m,n] = size(x1);
if m == 1
  y1 = y1';
  x1 = x1';
end
[x1/32, x1, y1]
csvwrite('output2.csv', [x1/32, x1, y1])
exit();
