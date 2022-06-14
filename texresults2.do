*==============================================================================*
* Title: texresults2
* Author: Angelo Kisil Marino (MIT)
* Purpose: Adapt texresults command to export Stata results to Latex macros 
		// and construct tables easily
*==============================================================================*


*==============================================================================*
* 									Program									   *
*==============================================================================*
cap program drop texresults2
program define texresults2
	
	syntax [using], ///
	TEXmacro(string) ///
	[ ///
		replace Append ///
		Variable(string) Nostars Format(string) ///
	]
	
// Parse file action
if !missing("`replace'") & !missing("`append'") {
	di as error "{bf:replace} and {bf:append} may not be specified simultaneously"
	exit 198
}
local action `replace' `append'

// Set default format
if missing("`format'" ) {
	local format %9.3f
}
else local format "`format'"	

// Add backslash to macroname and issue warning if doesn't contain only alph
local isalph = regexm("`texmacro'","^[a-zA-Z ]*$")
local texmacro = "\" + "`texmacro'"
if `isalph' == 0 di as text `""`texmacro'" may not be a valid LaTeX macro name"'

* String to local
local variable `variable'

// Significance stars option
if missing("`nostars'") {
	local pvalue = 2 * ttail(e(df_r), abs(_b[`variable']/_se[`variable']))
	if `pvalue' >= 0.1 {
	local stars ""
	}
	else if `pvalue' < 0.1 & `pvalue' >= 0.05 {
	local stars "*"
	}
	else if `pvalue' < 0.05 & `pvalue' >= 0.01 {
	local stars "**"
    }
	else {
	local stars "***"
}
}

// Coefficient
scalar coef = string(_coef[`variable'], "`format'")
local coef = scalar(coef)

// Standard Error
scalar se = string(_se[`variable'], "`format'")
local se = scalar(se)
	
* Create or modify macros file
*------------------------------------------------------------------------------
file open texresultsfile `using', write `action'
file write texresultsfile "\newcommand{`texmacro'}{$`coef'$}" _n
file write texresultsfile "\newcommand{`texmacro'SE}{$`se'$}" _n
if missing("`nostars'") {
	file write texresultsfile "\newcommand{`texmacro'STAR}{$^{`stars'}$}" _n
}
file close texresultsfile

end 

*==============================================================================*
* 								Working example								   *
*==============================================================================*
sysuse auto, clear
reg mpg trunk weight foreign

texresults2 using results.tex, texmacro(Trunk) variable(trunk) nostars replace
texresults2 using results.tex, texmacro(Weight) variable(weight) format(%9.4f) append
