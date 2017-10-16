gdp <-
  read.csv( 'GDP.csv', header=FALSE, skip=5, nrows=190, strip.white=TRUE )
colnames( gdp ) <-
  c( 'shortcode', 'gdp_rank', 'V3', 'country', 'gdp', 'V6', 'V7', 'V8',
     'V9', 'V10' )
gdp$gdp <- as.numeric( gsub( ',', '', gdp$gdp ) )

ed <- read.csv( 'ed.csv', header=TRUE )

i <-
  merge( gdp, ed, by.x='shortcode', by.y='CountryCode', incomparables=NA )
si <-
  i[ order( i$gdp_rank, decreasing=TRUE ),
     c( 'gdp_rank', 'shortcode', 'country' ) ]

mean( i[ i$Income.Group == 'High income: OECD', 'gdp_rank' ] )
mean( i[ i$Income.Group == 'High income: nonOECD', 'gdp_rank' ] )


