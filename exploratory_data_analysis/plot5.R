NEI <- readRDS( 'summarySCC_PM25.rds' )
NEI$type <- factor( NEI$type )
NEI$year <- factor( NEI$year )

SCC <- readRDS( 'Source_Classification_Code.rds' )
SCC$Last.Inventory.Year <- factor( SCC$Last.Inventory.Year )

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

aggregation <-
  aggregate( Emissions ~ year,
             NEI[ NEI$SCC %in% motorVehicleCodes &
                  NEI$fips == '24510',
                  c( 'year', 'Emissions' ) ],
             sum )
lineOfBestFit <- lm( Emissions~year, aggregation )

png( filename='plot5.png' )
plot( Emissions~year, aggregation )
abline( coef=coef( lineOfBestFit ) )
dev.off()
