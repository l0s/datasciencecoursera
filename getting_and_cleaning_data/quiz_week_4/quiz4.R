gdp <-
  read.csv( 'gdp.csv', header=FALSE, skip=5, nrows=190,
            col.names=c( 'code', 'ranking', 'unknown', 'country',
                         'gdp_string', 'a', 'b', 'c', 'd', 'e' ),
            as.is=TRUE)
ed <- read.csv( 'ed.csv' )
