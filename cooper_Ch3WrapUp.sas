%let raw=/home/u62174441/RawData;
%let SASdat=/home/u62174441/my_shared_file_links/blumj/BookData/SASData;
%let OutPath=/home/u62174441/output;
libname BookData "&SASdat";
filename RawData "&raw";

/** Read in ipums2010Formatted.csv data file, state delimiters, set lengths and other informats **/
filename RawData "&raw";

data Ipums2010Formatted;
  infile RawData("IPUMS2010formatted.csv") dsd;
  input Serial State : $20. City : $40. Metro CountyFIPS CityPop : comma. 
  		Ownership $ MortgageStatus : $45. MortgagePayment : comma. 
  		HomeValue : comma. HHIncome : comma.;
run;

/** Compare ipums2010basic.sas7bat and ipums2010Formatted.csv **/
title 'Output: Compare the Contents of Two Data Sets';
ods exclude comparedifferences;
proc compare base = Bookdata.ipums2010basic compare = IPUMS2010formatted;
run;

/** Compare variables **/
proc compare noprint base = BookData.ipums2010basic
             compare = IPUMS2010Formatted
             out = diff
             outbase outcompare
             outdif outnoequal
             method = absolute
             criterion = 1E-9;
run;
/** variables and records compared and their attributes match **/

/** Preping for Outputs 3.2.1 - .6 and 3.2.8 **/
ods exclude all;
proc freq data= work.ipums2010formatted;
	table City;
	ods output onewayfreqs= work.cityFreqs;
run;

proc freq data= work.ipums2010formatted;
	table State;
	ods output onewayfreqs= work.stateFreqs;
run;

proc freq data= work.ipums2010formatted;
	table MortgagePayment;
	ods output onewayfreqs= work.freqs;
run;

ods exclude none;
/** Outputs 3.2.1 - .2 Listings of Ownership & MortgageStatus Cats & Freqs **/
proc freq data= work.ipums2010formatted;
	table Ownership MortgageStatus;
run;

/** Output 3.2.3 partial listing of City **/
proc print data= work.cityFreqs(obs=8) label noobs;
	var City--cumPercent;
run;

/** Output 3.2.4 partial listing of State **/
proc print data= work.stateFreqs(obs=7) label noobs;
	var State--cumPercent;
run;

/** Output 3.2.5 Quantiles on MortgagePayments **/
proc means data= work.ipums2010formatted n nmiss min p25 p50 p75 max maxdec=1;
	var MortgagePayment;
run;

/** Output 3.2.6 More Percentiles on MortgagePayments **/
proc means data= work.ipums2010formatted n p50 p60 p70 p75 p80 p90 p95 p99 max maxdec=1;
	var MortgagePayment;
run;

/** Format Metro, HHIncome, and MortgagePayment for bar charts **/
proc format;
value Metro
	0 = "Not Identifiable"
	1 = "Not in Metro Area"
	2 = "Metro, Inside City"
	3 = "Metro, Outside City"
	4 = "Metro, City Status Unknown"
;
	
value Income
	low-<0 = "Negative"
	0-<45000 = "$0 to $45K"
	45000-<90000 = "$45K to $90K"
	90000-high = "Above $90K"
;
	
value Mort
	0 = "None"
	1-350 = "$350 and Below"
	351-1000 = "$351 to $1000"
	1001-1600 = "$1001 to $1600"
	1601-high = "Over $1600"
;
run;

/** Output 3.2.7 Charting Mortgage Payments vs. Metro Status **/
proc sgplot data= work.ipums2010formatted;
	hbar MortgagePayment/group=Metro;
	format MortgagePayment Mort.;
	yaxis label="First mortgage monthly payment";
	keylegend / title="Metropolitan status";
run;

/** Output 3.2.8 Cumulative Distribution of Mortgage Payments **/
proc sgplot data= work.Freqs noborder;
	vbar MortgagePayment/response=CumPercent fillattrs=(color=cxCB9EFE) barwidth=1;
	format MortgagePayment Mort.;
	xaxis label="Mortgage Payment";
	yaxis label="Cumulative Percentage" offsetmax=0;
run;

/** Output 3.2.9 Household Income Levels and Mortgage Payments **/
/** preparing twoway table **/
ods exclude all;
proc freq data= work.ipums2010formatted;
	table HHIncome*MortgagePayment;
	format HHIncome Income. MortgagePayment Mort.;
	where MortgagePayment gt 0 and HHIncome ge 0;
	ods output CrossTabFreqs= work.TwoWay;
run;

ods exclude none;
/** create bar chart **/
proc sgplot data= work.TwoWay;
	hbar HHIncome / response=RowPercent group=MortgagePayment groupdisplay=cluster;
	xaxis label="Percent within Income Class" grid gridattrs=(color=gray78) values=(0 to 65 by 5) offsetmax=0;
	yaxis label="Household Income";
	keylegend / position=top across=2 title="Mortgage Payment";
	where HHIncome is not missing and MortgagePayment is not missing;
run;











