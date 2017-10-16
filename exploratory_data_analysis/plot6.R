NEI <- readRDS( 'summarySCC_PM25.rds' )
SCC <- readRDS( 'Source_Classification_Code.rds' )

sectors <- unique( SCC$EI.Sector )
levelOneClassifiers <- unique( SCC$SCC.Level.One )
levelTwoClassifiers <- unique( SCC$SCC.Level.Two )
levelThreeClassifiers <- unique( SCC$SCC.Level.Three )
levelFourClassifiers <- unique( SCC$SCC.Level.Four )
shortNames <- unique( SCC$Short.Name )

motorVehicleIndicators <-
  SCC$EI.Sector %in%
    sectors[ grep( 'Vehicles', sectors, ignore.case=TRUE ) ] |
  SCC$SCC.Level.Two %in%
    levelTwoClassifiers[ grep( 'Vehicles', levelTwoClassifiers,
                               ignore.case=TRUE ) ] |
  SCC$SCC.Level.Two %in%
    levelTwoClassifiers[ grep( 'Off-highway', levelTwoClassifiers,
                               ignore.case=TRUE ) ] |
  SCC$SCC.Level.Three %in%
    levelThreeClassifiers[ grep( 'Trucks', levelThreeClassifiers,
                                 ignore.case=TRUE ) ] |
  SCC$SCC.Level.Three %in%
    levelThreeClassifiers[ grep( 'Motorcycle', levelThreeClassifiers,
                                 ignore.case=TRUE ) ] |
  SCC$SCC.Level.Four %in%
    levelFourClassifiers[ grep( 'Vehicles', levelFourClassifiers,
                                ignore.case=TRUE ) ]

motorVehicleCodes <- SCC[ motorVehicleIndicators, 'SCC' ]
motorVehicleEmissions <-
  NEI[ NEI$SCC %in% motorVehicleCodes, c( 'year', 'fips', 'Emissions' ) ]

baltimoreAggregation <-
  aggregate( Emissions ~ year,
             motorVehicleEmissions[ motorVehicleEmissions$fips == '24510',
                                    c( 'year', 'Emissions' ) ],
             sum )
baltimoreRegression <- lm( Emissions~year, baltimoreAggregation )
losAngelesAggregation <-
  aggregate( Emissions ~ year,
             motorVehicleEmissions[ motorVehicleEmissions$fips == '06037',
                                    c( 'year', 'Emissions' ) ],
             sum )
losAngelesRegression <- lm( Emissions~year, losAngelesAggregation )

png( filename='plot6.png' )
par( mfrow=c( 1, 2 ) )
plot( Emissions~year, baltimoreAggregation, main='Baltimore' )
abline( coef=coef( baltimoreRegression ) )
plot( Emissions~year, losAngelesAggregation, main='Los Angeles' )
abline( coef=coef( losAngelesRegression ) )
dev.off()
