library(PROcess)
data <- read.csv('input.csv')
dt <- data.frame( cbind( 1:nrow(data), data ) )
dt
names(dt) <- c("t", "v")
dt$t = dt$t / 32
f <-bslnoff(dt,method="loess",plot=F, bw=0.1)
pks <- isPeak(f, SoN=0, span=81, sm.span=11, plot=F, zerothrsh=0, area.w=0.003)
pks$v <- dt$v
pks <- pks[pks$peak == T, cbind("mz", "v", "area")]
write.table(pks, file='output.csv', row.names=F, col.names=T)