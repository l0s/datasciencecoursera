library( ggplot2 )

NEI <- readRDS( 'summarySCC_PM25.rds' )
NEI <- NEI[ NEI$fips == '24510', c( 'year', 'type', 'Emissions' ) ]
NEI$type <- factor( NEI$type )
NEI$year <- factor( NEI$year )

aggregation <- aggregate( Emissions ~ year + type, NEI, sum )
g <- ggplot( aggregation, aes( x=year, y=Emissions ) )

p <- g +
  geom_point() +
  geom_smooth( aes( group=1 ), method='lm' ) +
  facet_wrap( ~ type, nrow=2, ncol=2, scales='free' )

png( filename='plot3.png' )
print( p )
dev.off()
