library( plyr )

workingDirectory <- 'work'
outFile <- paste( c( workingDirectory, '/tidy.txt' ), collapse='' )
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

readSubjects <- function( subjectFile )
{
  read.table( paste( c( datasetDirectory, subjectFile ), collapse='' ),
              col.names='subject_id', header=FALSE, row.names=NULL )
}
readMeasurements <- function( measurementsFile )
{
  read.table( paste( c( datasetDirectory, measurementsFile ),
                     collapse='' ),
              strip.white=TRUE, col.names=features$feature_name,
              header=FALSE, row.names=NULL, check.names=TRUE )
}
readActivityFactors <- function( activitiesFile )
{
  activities <-
    read.table( paste( c( datasetDirectory, activitiesFile ), collapse='' ),
                strip.white=TRUE, col.names='activity_id', header=FALSE,
                row.names=NULL ) 
  as.vector( factor( activities$activity_id,
                     labels=activityLabels$activity_name ) )
}
# Read test data
testSubjects <- readSubjects( '/test/subject_test.txt' )
testMeasurements <- readMeasurements( '/test/X_test.txt' )
testActivityFactors <- readActivityFactors( '/test/y_test.txt' )

# Read training data
trainingSubjects <- readSubjects( '/train/subject_train.txt' )
trainingMeasurements <- readMeasurements( '/train/X_train.txt' )
trainingActivityFactors <- readActivityFactors( '/train/y_train.txt' )

# Merge the training and test sets to create one data set ( Instruction 1 )
allSubjects <- rbind( testSubjects, trainingSubjects )
allMeasurements <- rbind( testMeasurements, trainingMeasurements )
allActivityFactors <- c( testActivityFactors, trainingActivityFactors )

# Extract only the measurements on the mean and standard deviation for each
# measurement ( Instruction 2 )
relevantFeatures <-
  sort( c( grep( 'mean', features$feature_name, ignore.case=TRUE ),
           grep( 'std', features$feature_name, ignore.case=TRUE ) ) )
measurements <-
  cbind( allSubjects,
         # Use descriptive activity names to name the activities in the
         # data set.
         # Appropriately label the data set with descriptive activity names
         # ( Instructions 3 and 4 )
         data.frame( activity=allActivityFactors ),
         allMeasurements[ , relevantFeatures ] )

# Create a second, independent tidy data set with the average of each
# variable for each activity and each subject ( Instruction 5 )
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
tidy <- ddply( measurements, c( 'subject_id', 'activity' ), aggregate )
unaggregatedFeatureNames <-
  as.vector( features[ relevantFeatures, 'feature_name' ] )
colnames( tidy ) <-
  c( 'subject', 'activity',
     unlist( lapply( unaggregatedFeatureNames, labelAggregation ) ) )

write.table( tidy, file=outFile, row.names=FALSE, fileEncoding='UTF-8' )
