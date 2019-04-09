## @knitr preprocessing1

# data-cleaning 
archetypesDf = archetypesClean(cyber.security.7.archetype.survey.responses)
questionsDf = questionsClean(cyber.security.7.question.response)
stepsDf = stepsClean(cyber.security.7.step.activity)

# data-aggregation
stepsAggDf = stepsAgg(stepsDf)
questionsAggDf = questionsAgg(questionsDf)

# data-merge
progressTypeDf = mergeDfs(archetypesDf, questionsAggDf, stepsAggDf)


## @knitr preprocessing2

countryDf = enrolClean(cyber.security.7.enrolments) # clean
countryProgressDf = countryMergeDfs(progressTypeDf, countryDf) # merge


