To load project:

	* Update R
		+ In R Studio GUI: Tool -> Check for Package Updates
		+ In R Studio GUI: Help -> Check for Updates 
	* Change Working Directory to project root
		+ In R Studio GUI: Session -> Set Working Directory -> Choose Directory 
	* Clear environment
		+ In console: rm(lis = ls())
	* Install and load ProjectTemplate
		+ In console: install.packages(ProjectTemplate)
		+ In console: library(ProjectTemplate)
	* Load ProjectManager Project
		+ In console: load.project()
  	    Data cleaning, aggregation and merging should run alongside the project from the 	
  		  munge script (1DataPrepartion.R) when load.project is called

File Structure (Relevent Directories):

	* data: Contains datasets before the Data Preparation stage
	* docs: Contains test documentation as RMarkdown and PDF
	* lib: Helpers.R contains helper functions used in the Data Preparation stage
	* munge: Contains 1DataPreparation.R preprocessing script used for Data Preparation
	* reports: Contains the Data Understanding and Data Preparation stages reports in	RMarkdown and PDF formats
	* tests: Contains the files used to test data cleaning functions (1Cleaning.R) and aggregation + merge functions (2AggregationMerge.R)
	
To run Data Preparation (clean, aggregate and merge):
	* As stated before, call load.project()
	
To run tests:
	* test.project()

To run Data Understanding analysis:
	* Knit the DataUnderstanding.Rmd
