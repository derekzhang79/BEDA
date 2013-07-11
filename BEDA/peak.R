library(PROcess)
data <- read.csv('input.csv')
dt <- data.frame( cbind( 1:nrow(data), data ) )
dt
names(dt) <- c("t", "v")
dt$t = dt$t / 32
jpeg('baseline.jpg')
f <-bslnoff(dt,method="loess",plot=T, bw=0.1)
dev.off()
jpeg('peaks.jpg')
pks <- isPeak(f, SoN=2, span=81, sm.span=11, plot=T, zerothrsh=2, area.w=0.3, ratio = 0.5)
dev.off()
pks$v <- dt$v
pks <- pks[pks$peak == T, cbind("mz", "v", "area")]
numPks <- nrow(pks)

write.table(numPks, file='output.csv', row.names=F, col.names=F)