#library( data.table )
library( plyr )

workingDirectory <- 'work'
zipFile <- paste( c( workingDirectory, '/data.zip' ), collapse='' )
dataFileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
datasetDirectory <-
  paste( c( workingDirectory, '/UCI HAR Dataset' ), collapse='' )
featuresFile <- paste( c( datasetDirectory, '/features.txt' ), collapse='' )
activityLabelsFile <-
  paste( c( datasetDirectory, '/activity_labels.txt' ), collapse='' )

# Set up files and directories

if( !file.exists( workingDirectory ) ) {
  dir.create( workingDirectory )
}

if( !file.exists( zipFile ) ) {
  download.file( dataFileUrl, zipFile, method='curl' )
}
if( !file.exists( datasetDirectory ) ) {
  unzip( zipFile, exdir=workingDirectory )
}

# Read meta data
features <-
  read.table( featuresFile, strip.white=TRUE,
              col.names=c( 'feature_id', 'feature_name' ), header=FALSE )
activityLabels <-
  read.table( activityLabelsFile, strip.white=TRUE,
              col.names=c( 'activity_id', 'activity_name' ), header=FALSE )

# Read test data
testSubjects <-
  read.table( paste( c( datasetDirectory, '/test/subject_test.txt' ),
                     collapse='' ),
              col.names='subject_id', header=FALSE, row.names=NULL )
testMeasurements <-
  read.table( paste( c( datasetDirectory, '/test/X_test.txt' ),
                     collapse='' ),
              strip.white=TRUE, col.names=features$feature_name,
              header=FALSE, row.names=NULL, check.names=TRUE )
testActivities <-
  read.table( paste( c( datasetDirectory, '/test/y_test.txt' ),
                     collapse='' ), strip.white=TRUE,
              col.names='activity_id', header=FALSE,
              row.names=NULL )
testActivityFactors <-
  factor( testActivities$activity_id, labels=activityLabels$activity_name )

# TODO READ training data

# TODO concatenate data frames (Instruction 1)

# Extract only the measurements on the mean and standard deviation for each
# measurement (Instruction 2)
relevantFeatures <-
  sort( c( grep( 'mean', features$feature_name, ignore.case=TRUE ),
           grep( 'std', features$feature_name, ignore.case=TRUE ) ) )
measurements <-
  cbind( testSubjects,
         # Appropriately label the data set with descriptive activity names
         # (Instruction 4)
         data.frame( activityName=as.vector( testActivityFactors ) ),
         testMeasurements[ , relevantFeatures ] )

# Aggregate values (Instruction 5)
aggregate <- function( dataframe )
{
  averageFeature <- function( column )
  {
    mean( dataframe[ , column ] )
  }
  sapply( 3:dim( dataframe )[ 2 ], averageFeature )
}
labelAggregation <- function( unaggregatedLabel )
{
  paste( c( 'avg', unaggregatedLabel ), collapse='_' )
}
tidy <- ddply( measurements, c( 'subject_id', 'activityName' ), aggregate )
unaggregatedFeatureNames <-
  as.vector( features[ relevantFeatures, 'feature_name' ] )
colnames( tidy ) <-
  c( 'subject', 'activity',
     unlist( lapply( unaggregatedFeatureNames, labelAggregation ) ) )
