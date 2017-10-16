source( 'common.R' )

.rankhospital <- function( state, outcomeName, ranking )
{
  ordered <- .rank( state, outcomeName )
  resultCount <- nrow( ordered )
  actualRanking <-
    if( ranking == 'best' ) 1 
    else if( ranking == 'worst' ) resultCount
    else ranking
  if( actualRanking > resultCount ) 
  {
    NULL  
  } else {
    ordered[ actualRanking, ]
  }
}

rankhospital <- function( state, outcomeName, ranking )
{
  row <- .rankhospital( state, outcomeName, ranking )
  ifelse( is.null( row ), NA, row[ , 'Hospital.Name' ] )
}
