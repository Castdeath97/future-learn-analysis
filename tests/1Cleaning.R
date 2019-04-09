context("Munge Cleaning Testing")

## @knitr archtypes-clean-tests

archetypesDf = archetypesClean(cyber.security.7.archetype.survey.responses)

test_that("Check if arhcetype clean removed appropriate fields", {
  expect_true(is.null(archetypesDf$responded_at))
  expect_true(is.null(archetypesDf$id))
})

test_that("Check if arhcetype clean fixed ID format to
          character", {
  expect_that(class(archetypesDf$learner_id), equals('character'))
})

## @knitr questions-clean-tests

questionsDf = questionsClean(cyber.security.7.question.response)

test_that("Check if questions clean removed appropriate fields", {
  # Check if redudant quiz_question field was removed
  expect_true(is.null(questionsDf$quiz_question))
  
  # Check if non-unique question type field was removed
  expect_true(is.null(questionsDf$question_type))
  
  # Check if the cloze response field was removed
  expect_true(is.null(questionsDf$cloze_response))
})

test_that("Check if questions clean fixed ID format to
          character", {
  expect_that(class(questionsDf$learner_id), equals('character'))
})

test_that("Check if questions clean fixed date formats", {
  expect_that(class(questionsDf$submitted_at), equals('Date'))
})

test_that("Check if questions clean fixed 'correct' format to
          logical", {
  expect_that(class(questionsDf$correct), equals('logical'))
})

test_that("Check if questions clean dropped rows with empty ID", {
  expect_that(nrow(questionsDf),
              equals(nrow(drop_na(cyber.security.7.question.response, learner_id))))
})


## @knitr steps-clean-tests

stepsDf = stepsClean(cyber.security.7.step.activity)

test_that("Check if steps clean removed appropriate fields", {
  # Check if redudant step field was removed
  expect_true(is.null(stepsDf$step))
})

test_that("Check if steps clean fixed date formats", {
  expect_that(class(stepsDf$first_visited_at),
              equals('Date'))
  expect_that(class(stepsDf$last_completed_at),
              equals('Date'))
})

test_that("Check if steps clean fixed ID format to
          character", {
  expect_that(class(stepsDf$learner_id), equals('character'))
})


## @knitr enrol-clean-tests

countryDf = enrolClean(cyber.security.7.enrolments)
keptFieldsCount = 2

test_that("Check if steps entrol removed appropriate fields", {
  # Check if only learner id and expected country remain
  expect_that(ncol(countryDf), equals(keptFieldsCount))
  expect_true(!is.null(countryDf$learner_id))
  expect_true(!is.null(countryDf$detected_country))
})

test_that("Check if enrol clean removed -- for Not Detected", {
  expect_that(nrow(subset(countryDf, detected_country == '--')), equals(0))
  expect_true(!'--' %in% levels(countryDf$detected_country))
  expect_true('Not Detected' %in% levels(countryDf$detected_country))
})

test_that("Check if enrol clean fixed ID format to
          character", {
  expect_that(class(countryDf$learner_id), equals('character'))
})