%% Analysis on peaks - xcode
data = csvread('input.csv');
[y1, x1] = findpeaks(data, 'MINPEAKDISTANCE', 400, 'MINPEAKHEIGHT', 0.5);
csvwrite('output.csv', length(x1)  );
csvwrite('output2.csv', [x1/32, x1, y1])
exit();
