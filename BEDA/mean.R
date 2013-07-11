data <- read.csv('input.csv')
output <- sprintf('%.3f', mean(data[,1]))
write.table(output, file='output.csv', row.names=F, col.names=F)
