map <- list()
map[[ 'heart attack' ]] <-
  'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack'
map[[ 'heart failure' ]] <-
  'Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure'
map[[ 'pneumonia' ]] <-
  'Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia'

outcome <-
  read.csv( 'outcome-of-care-measures.csv', colClasses='character' )

outcome[ , map[[ 'heart attack' ]] ] <-
  as.numeric( outcome[ , map[[ 'heart attack' ]] ] ) 
outcome[ , map[[ 'heart failure' ]] ] <-
  as.numeric( outcome[ , map[[ 'heart failure' ]] ] ) 
outcome[ , map[[ 'pneumonia' ]] ] <-
  as.numeric( outcome[ , map[[ 'pneumonia' ]] ] ) 

.rank <- function( state, outcomeName )
{
  outcomeColumn <- map[[ outcomeName ]]
  if( is.null( outcomeColumn ) ) 
  {
    stop( 'invalid outcome' )
  }
  filtered <-
    outcome[ outcome[ 'State' ] == state
             & !is.na( outcome[ outcomeColumn ] ), ]
  if( nrow( filtered ) == 0 )
  {
    stop( 'invalid state' )
  }
  filtered[ with( filtered,
                  order( filtered[ outcomeColumn ],
                          filtered[ 'Hospital.Name' ] ) ), ]
}
