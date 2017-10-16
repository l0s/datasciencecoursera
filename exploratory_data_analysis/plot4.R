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

coalCodeIndicators <-
  SCC$EI.Sector %in% sectors[ grep( 'coal', sectors, ignore.case=TRUE ) ] |
  SCC$SCC.Level.Three %in%
    levelThreeClassifiers[ grep( 'coal', levelThreeClassifiers,
                                 ignore.case=TRUE ) ] |
  SCC$SCC.Level.Four %in%
    levelFourClassifiers[ grep( 'coal', levelFourClassifiers,
                                ignore.case=TRUE ) ] |
  SCC$Short.Name %in%
    shortNames[ grep( 'coal', shortNames, ignore.case=TRUE ) ]
combustionCodeIndicators <-
  SCC$SCC.Level.One %in%
    levelOneClassifiers[ grep( 'combustion', levelOneClassifiers,
                               ignore.case=TRUE ) ] |
  SCC$SCC.Level.Two %in%
    levelTwoClassifiers[ grep( 'combustion', levelTwoClassifiers,
                               ignore.case=TRUE ) ] |
  SCC$SCC.Level.Four %in%
    levelFourClassifiers[ grep( 'combustion', levelFourClassifiers,
                                ignore.case=TRUE ) ] |
  SCC$Short.Name %in%
    shortNames[ grep( 'combustion', shortNames, ignore.case=TRUE ) ]
coalCombustionCodes <- SCC[ coalCodeIndicators & combustionCodeIndicators, ]

aggregation <-
  aggregate( Emissions ~ year,
             NEI[ NEI$SCC %in% coalCombustionCodes$SCC,
                  c( 'year', 'Emissions' ) ],
             sum )
lineOfBestFit <- lm( Emissions~year, aggregation )

png( filename='plot4.png' )
plot( Emissions~year, aggregation )
abline( coef=coef( lineOfBestFit ) )
dev.off()
