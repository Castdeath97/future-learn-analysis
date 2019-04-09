context("Munge Aggregation and Merge Testing")

## @knitr steps-aggregate-tests

week1MaxSteps = 19
week2MaxSteps = 23
week3MaxSteps = 20
stepsAggDf = stepsAgg(stepsDf)

test_that("New fields are created 
          after steps aggregation", {
  expect_false(is.null(stepsAggDf$week1_completed_steps))
  expect_false(is.null(stepsAggDf$week2_completed_steps))
  expect_false(is.null(stepsAggDf$week3_completed_steps))
})

test_that("completed steps can't be more than actual
          after steps aggregation", {
  expect_that(max(stepsAggDf$week1_completed_steps),
              equals(week1MaxSteps))
  expect_that(max(stepsAggDf$week2_completed_steps),
              equals(week2MaxSteps))
  expect_that(max(stepsAggDf$week3_completed_steps),
              equals(week3MaxSteps))
})

test_that("no NAs after steps aggregation", {
    expect_that(length(stepsAggDf[is.na(stepsAggDf)]), equals(0))
})

test_that("IDs are unique after steps aggregation", {
  expect_that(length(unique(stepsAggDf$learner_id)), 
              equals(length(stepsAggDf$learner_id)))
})

## @knitr questions-aggregate-tests

questionsAggDf = questionsAgg(questionsDf)

test_that("New fields are created 
          after questions aggregation", {
  expect_false(is.null(questionsAggDf$week1_total_marks))
  expect_false(is.null(questionsAggDf$week2_total_marks))
  expect_false(is.null(questionsAggDf$week3_total_marks))
  expect_false(is.null(questionsAggDf$week1_total_attempts))
  expect_false(is.null(questionsAggDf$week2_total_attempts))
  expect_false(is.null(questionsAggDf$week3_total_attempts))
})

test_that("No NAs after questions aggregation", {
  expect_that(
    length(questionsAggDf[is.na(questionsAggDf)]), equals(0))
})

test_that("IDs are unique after questions aggregation", {
  expect_that(length(unique(questionsAggDf$learner_id)),
              equals(length(questionsAggDf$learner_id)))
})

## @knitr merge-tests

progressByArchetypeDf = mergeDfs(archetypesDf, questionsAggDf, stepsAggDf)
countryProgressByArchetypeDf = countryMergeDfs(progressByArchetypeDf, countryDf)

test_that("No NAs after merge", {
  expect_that(
    length(progressByArchetypeDf[is.na(progressByArchetypeDf)]), equals(0))
})

test_that("IDs are unique after merge", {
  expect_that(length(unique(progressByArchetypeDf$learner_id)), 
              equals(length(progressByArchetypeDf$learner_id)))
})

test_that("No NAs after country merge", {
  expect_that(
    length(countryProgressByArchetypeDf[is.na(countryProgressByArchetypeDf)]), equals(0))
})

test_that("IDs are unique country after merge", {
  expect_that(length(unique(countryProgressByArchetypeDf$learner_id)), 
              equals(length(countryProgressByArchetypeDf$learner_id)))
})