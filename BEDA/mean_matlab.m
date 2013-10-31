data = csvread('input.csv');
result = mean(data);
csvwrite('output.csv', result);
exit();


