source( 'common.R' )

best <- function( state, outcomeName )
{
  ordered <- .rank( state, outcomeName )[ , 'Hospital.Name' ]
  head( ordered, n=1 )
}
