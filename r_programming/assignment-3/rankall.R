source( 'rankhospital.R' )

states <- unique( outcome[ , 'State' ] )

rankall <- function( outcomeName, ranking )
{
  rankState <- function( state )
  {
    stateRanking <- .rankhospital( state, outcomeName, ranking )
    if( is.null( stateRanking ) ) data.frame( Hospital.Name=NA, State=state )
    else stateRanking[ , c( 'Hospital.Name', 'State' ) ]
  }
  aggregated <- Reduce( rbind, lapply( states, rankState ) )
  sorted <-
    aggregated[ with( aggregated, order( aggregated[ 'State' ] ) ), ]
  colnames( sorted ) <- c( 'hospital', 'state' )
  rownames( sorted ) <- states
  sorted
}
