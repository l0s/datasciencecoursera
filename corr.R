source( 'complete.R' )

corr <- function( directory, threshold=0 )
{
  complete_observations <-
    complete( 'specdata', 1:length( list.files( 'specdata' ) ) )
  observation_count_over_threshold <-
    complete_observations[ 'nobs' ] > threshold
  ids <-
    complete_observations[ 'id' ][ observation_count_over_threshold ]
  files <- sprintf( "%s/%03s.csv", directory, ids )
  dataframes <- lapply( files, read.csv )
  my_cor <- function( dataframe )
  {
    cor( dataframe[ 'sulfate' ], dataframe[ 'nitrate' ], #na.rm=TRUE,
         use='complete.obs' )
  }
  sapply( dataframes, my_cor )
}
