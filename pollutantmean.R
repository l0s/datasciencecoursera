pollutantmean <- function( directory, pollutant, id=1:332 )
{
  files <- sprintf( "%s/%03s.csv", directory,id )
  dataframes <- lapply( files, read.csv )
  combine <- function( x, y )
  {
    merge( x, y, all=TRUE )
  }
  dataframe <- Reduce( combine, dataframes )
  measurements <- dataframe[ pollutant ][ !is.na( dataframe[ pollutant ] ) ]
  mean( measurements )
}
