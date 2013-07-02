data <- read.csv('input.csv')
output <- sd(data[,1])
write.table(output, file='output.csv', row.names=F, col.names=F)
