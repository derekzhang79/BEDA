data <- read.csv('input.csv')
output <- summary(data)
write.table(output, file='output.csv', row.names=F, col.names=F)
