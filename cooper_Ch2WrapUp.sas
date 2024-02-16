%let raw=/home/u62174441/RawData;
%let SASdat=/home/u62174441/my_shared_file_links/blumj/BookData/SASData;
%let OutPath=/home/u62174441/output;
libname BookData "&SASdat";
filename RawData "&raw";


/** Read in ipums2010basic.csv data file, set character lengths, and state delimiters **/
filename RawData "&raw";

data Ipums2010basic;
  length State$ 57 City$ 43 MortgageStatus$ 45;
  infile RawData("ipums2010basic.csv") dsd;
  input Serial State$ City$ CityPop Metro 
        CountyFIPS Ownership$ MortgageStatus$ 
        MortgagePayment HHIncome HomeValue;
run;


/** Compare ipums2010basic.sas7bat and ipums2010basic.csv **/
title 'Output: Compare the Contents of Two Data Sets';
ods exclude comparedifferences;
proc compare base = Bookdata.ipums2010basic compare = ipums2010basic;
run;

/** Compare variables **/
proc compare noprint base = BookData.ipums2010basic
             compare = ipums2010basic
             out = diff
             outbase outcompare
             outdif outnoequal
             method = absolute
             criterion = 1E-9;
run;
/** variables and records compared and their attributes match **/


/** Format Metro, HHIncome, and MortgagePayment for tables **/
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


/** Sort Metro, HHIncome, and MortgagePayment for tables **/
proc sort data=ipums2010basic out=work.sorted;
 by Metro HHIncome MortgagePayment descending HomeValue;
run;


/** Create Output 2.2.1 **/
proc means data=ipums2010basic nonobs n mean median std min max;
	class Metro;
	var MortgagePayment;
	label MortgagePayment='Mortgage Payment';
	format Metro Metro.;
	where MortgagePayment ge 100;
run;


/** Create Output 2.2.2 **/
proc means data=ipums2010basic nonobs min median max maxdec=0;
	class Metro HHIncome;
	var MortgagePayment HomeValue;
	label HHIncome='Household Income' MortgagePayment='Mortgage Payment' HomeValue='Home Value';
	format Metro Metro. HHIncome Income.;
	where Metro in (2,3,4) and MortgagePayment ge 100;
run;


/** Create Output 2.2.3 **/
proc freq data=ipums2010basic;
	table HHIncome*MortgagePayment / nopercent nocol;
	label HHIncome='Household Income' MortgagePayment='Mortgage Payment';
	format HHIncome Income. MortgagePayment Mort.;
	where MortgagePayment ^= 0;
run;


/** Create Output 2.2.4 **/
proc freq data=ipums2010basic;
	table Metro*HHIncome*MortgagePayment / nopercent nocol;
	label HHIncome='Household Income' MortgagePayment='Mortgage Payment';
	format Metro Metro. HHIncome Income. MortgagePayment Mort.;
	where Metro = 2 and MortgagePayment ^= 0;
run;

