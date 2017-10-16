## This first line will likely take a few seconds. Be patient!
NEI <- readRDS( 'summarySCC_PM25.rds' )
SCC <- readRDS( 'Source_Classification_Code.rds' )

NEI <- NEI[ NEI$fips == '24510', c( 'year', 'Emissions' ) ]
aggregation <- aggregate( Emissions ~ year, NEI, sum )
lineOfBestFit <- lm( Emissions~year, aggregation )
png( file='plot2.png' )
plot( Emissions~year, aggregation )
abline( lineOfBestFit )
dev.off()
