# texresults2

## Description
Adapts Stata command <a href="https://github.com/acarril/texresults" target="_blank">texresults</a>
 to facilitate export from Stata to LaTex with focus on table construction and ease of updating results in case of changes in specifications.

The idea is to have a LaTex code for the table using the LaTex commands in place of the coefficients, SEs, and significance stars. Uploading a new results.tex will be enough to update the tables, without any having to include any Tex formatting in the Stata code. 

## Main differences
Here, the command is more focused on construction table using LaTex macros. With that in mind, it exports macro not only for the coefficient, but also for the correspondent standard errors and significance stars (`nostar` option is off). 

## Possible improvements
Allow for different significance levels (not only 1, 5, and 10%).
