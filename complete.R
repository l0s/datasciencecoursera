complete <- function( directory, id=1:332 )
{
  files <- sprintf( "%s/%03s.csv", directory,id )
  dataframes <- lapply( files, read.csv )
  count <- function( dataframe )
  {
    sulfateDefined <- !is.na( dataframe[ 'sulfate' ] ) 
    nitrateDefined <- !is.na( dataframe[ 'nitrate' ] ) 
    length( dataframe[ 'Date' ][ sulfateDefined & nitrateDefined ] ) 
  }
  retval <- data.frame( id=id, nobs=sapply( dataframes, count ) )
  colnames( retval ) <- c( 'id', 'nobs' )
  retval
}
