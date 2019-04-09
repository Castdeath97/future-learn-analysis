
## @knitr archetypes-clean

idIndex = 1
responseIndex = 3

archetypesClean = function(df){

  # Remove fields that won't be used (id, responded_at)
  df = df[-responseIndex]
  df = df[-idIndex]
  
  # fix id format
  df$learner_id = as.character(df$learner_id)
  
  return(df)
}

## @knitr questions-clean

clozeIndex = 8
qTypeIndex = 3

questionsClean = function(df){
  
  # Remove empty cloze response field 
  df = df[-clozeIndex]
  
  # Remove question type field (doesn't change)
  df = df[-qTypeIndex]
  
  # Remove redudant quiz_number field
  df = df[-stepFieldIndex]
  
  # Remove rows with id empty fields 
  df = drop_na(df, learner_id)
  
  # fix date format
  df$submitted_at = as.Date(df$submitted_at)
  
  # fix 'correct' field format
  df$correct = as.logical(df$correct)
  
  # fix id format
  df$learner_id = as.character(df$learner_id)
  
  return(df)
}

## @knitr steps-clean

stepFieldIndex = 2

stepsClean = function(df){
  
  # Remove redudant step field
  df = df[-2]
  
  # Replace empty strings with NA to stop date formatting issues
  df$last_completed_at[df$last_completed_at == ''] = NA
  
  # fix date format
  df$first_visited_at = as.Date(df$first_visited_at)
  df$last_completed_at = as.Date(df$last_completed_at)
  
  # fix id format
  df$learner_id = as.character(df$learner_id)
  
  return(df)
}

## @knitr enrol-clean

otherFieldsIndexes = 2:12
enrolClean = function(df){
  
  # Remove unimportant fields
  df = df[-otherFieldsIndexes]
  
  # Replace '--' with NA with not detected
  df$detected_country =
    factor(df$detected_country, levels=c(levels(df$detected_country), 'Not Detected'))
  df$detected_country[as.character(df$detected_country) == '--'] = 'Not Detected'
  
  # Drop unused levels (-- dropped)
  df = droplevels(df)
  
  # fix id format
  df$learner_id = as.character(df$learner_id)
  
  return(df)
}

## @knitr generic-agg

# aggregate function used to aggregate both tables
# takes function to carry aggregation by week on a field
agg = function(df, func){
  
  # add fields for completed steps/marks in all weeks
  df =  left_join(func(df, 1), func(df, 2), by = 'learner_id') %>% 
    left_join(., func(df, 3), by = 'learner_id')
  
  # replace any NAs (dropped off) with 0s
  df[is.na(df)] = 0
  
  return(df)
}

## @knitr steps-agg

# steps aggregate just calls the general aggregates and passes 
# the function it needs to aggregate steps comppleted by week
stepsAgg = function(df){
  agg(df, stepsWeekComp)
}

# function used to aggregate amount of steps completed each week (not na)
stepsWeekComp = function(df, week){
  # subset and aggregate (count completed (not NA))
  weekDf = subset(df, week_number == week)
  comps = aggregate(weekDf$last_completed_at, 
                    list(learner_id= weekDf$learner_id),
                    function(x) sum(!is.na(x)))
  
  # rename default x for completed tasks 
  colnames(comps) =
    c(colnames(comps)[1],
      paste('week', week, '_completed_steps', sep = ''))
  
  return(comps)
}

## @knitr questions-agg

# question aggregate just calls the general aggregates and passes
# the function it needs to aggregate marks (# of correct questions) by week
# and number of tries
questionsAgg = function(df){
  agg(df, questionWeekMarks)
}

# function used to aggregate amount of marks (# of correct questions) 
# earned each week (not na) and attempts 
questionWeekMarks = function(df, week){
  
  # subset and aggregate (count marks by summing (1 is true) and length for attempts)
  weekDf = subset(df, week_number == week)
  marks = aggregate(weekDf$correct,
                    list(learner_id= weekDf$learner_id),
                    function(x) c(sum = sum(x), n = length(x)))
  
  # unpack the vector x and rename
  marks[paste('week', week, '_total_marks', sep = '')] = 
    marks[,2][,1]
  marks[paste('week', week, '_total_attempts', sep = '')] = 
    marks[,2][,2]
  
  # remove vector and top row
  marks = marks[-2]
  marks = marks[-1,]
  
  return(marks)
}

## @knitr merge1
mergeDfs = function(archetypesDf,questionsAggDf, stepsAggDf){
  
  # join by learner id
  progressByArchetypeDf = 
    left_join(stepsAggDf, questionsAggDf, by = 'learner_id')
  
  # replace nas with 0 for incompleted items
  progressByArchetypeDf[is.na(progressByArchetypeDf)] = 0 
  
  # join by learner id for last df
  progressByArchetypeDf = 
    left_join(progressByArchetypeDf, archetypesDf, by = 'learner_id')
  
  # remove NAs for archetype by replacing with unspecified
  progressByArchetypeDf$archetype = 
    fct_explicit_na(progressByArchetypeDf$archetype, 'Unspecified')
  
  return(progressByArchetypeDf)
}

## @knitr merge2
countryMergeDfs = function(progressByArchetypeDf, countryDf){
  
  # join by learner id
  progressByArchetypeDf = 
    left_join(progressByArchetypeDf, countryDf, by = 'learner_id')
  
  # Remove rows with empty fields (single user)
  progressByArchetypeDf = drop_na(progressByArchetypeDf)
  
  return(progressByArchetypeDf)
}