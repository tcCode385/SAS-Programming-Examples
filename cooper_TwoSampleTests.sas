%let raw=/home/u62174441/RawData;
%let SASdat=/home/u62174441/my_shared_file_links/blumj/BookData/SASData;
%let OutPath=/home/u62174441/output;
libname BookData "&SASdat";
filename RawData "&raw";

/** Create PDF File **/
ods pdf file='/home/u62174441/output/cooper_Two_Sample_Tests.pdf';

ods trace on;

/** Mortgage Payments 2005 **/
proc sort data= BookData.Ipums2005Basic out= work.mort2005;
	by State MortgageStatus;
	where State in ('Vermont', 'New Hampshire') and MortgageStatus contains 'Yes';
run;

ods exclude all;
proc means data= work.mort2005 mean sum std stddev stderr;
	where State in ('Vermont', 'New Hampshire') and MortgageStatus contains 'Yes';
	class State MortgageStatus;
	var MortgagePayment;
	ods output summary=mortPayment2005;
run;

data mP2005(keep=State MortgagePayment MortgageStatus mP05mean);
	merge mortPayment2005(in=useThese) work.mort2005;
	by State MortgageStatus;
	if useThese;
	mP05mean=MortgagePayment_Sum/Nobs;
run;

/** Difference of Means 2005 **/
ods select all;
ods graphics off;
title j=center height=14pt 
	  'Test for difference of means of Mortgage Payments for Vermont and New Hampshire Year 2005'; 
title2 j=center height=12pt 
	  'H0: mu_V = mu_NH vs. Ha: mu_V != mu_NH, significance level alpha = 0.05'; 
footnote1 j=left height=12pt
    	 "We see that there is enough evidence to assume the variances are not equal, so we consider the 
    	  Satterthwaite results. 
    	  Since p-value < 0.0001 < alpha = 0.05 we reject the null hypothesis and conclude that there is a difference 
    	  between the mean mortgage payments for Vermont between New Hampshire in the year 2005.";
footnote2 j=left height=12pt " " ; /** I know this is hacky but it is the quickest/easiest solution I have for a double line space **/
footnote3 j=left height=12pt
    	 "95% confidance interval: (301.2, 303.7), we see that zero is not within the confidence interval confirming our 
    	 conclusion that the mortgage payment means for Vermont and New Hampshire are not equal." ;
proc ttest data=mP2005;
class State;
var mP05mean;
run;

/** Mortgage Payments 2010 **/
proc sort data= BookData.Ipums2010Basic out= work.mort2010;
	by State MortgageStatus;
	where State in ('Vermont', 'New Hampshire') and MortgageStatus contains 'Yes';
run;

ods exclude all;
proc means data= work.mort2010 mean sum std stddev stderr;
	where State in ('Vermont', 'New Hampshire') and MortgageStatus contains 'Yes';
	class State MortgageStatus;
	var MortgagePayment;
	ods output summary=mortPayment2010;
run;

data mP2010(keep=State MortgagePayment MortgageStatus mP10mean);
	merge mortPayment2010(in=useThese) work.mort2010;
	by State MortgageStatus;
	if useThese;
	mP10mean=MortgagePayment_Sum/Nobs;
run;

/** Difference of Means 2010 **/
ods select all;
ods graphics off;
title j=center height=14pt 
	  'Test for difference of means of Mortgage Payments for Vermont and New Hampshire Year 2010'; 
title2 j=center height=12pt 
	  'H0: mu_V = mu_NH vs. Ha: mu_V != mu_NH, significance level alpha = 0.05'; 
footnote j=left height=12pt
    	 "We see that there is enough evidence to assume the variances are not equal, so we consider the 
    	  Satterthwaite results. 
    	  Since p-value < 0.0001 < alpha = 0.05 we reject the null hypothesis and conclude that there is a difference 
    	  between the mean mortgage payments for Vermont between New Hampshire in the year 2010.";
footnote2 j=left height=12pt " " ;
footnote3 j=left height=12pt
    	 "95% confidance interval: (389.9, 390.3), we see that zero is not within the confidence interval confirming our 
    	 conclusion that the mortgage payment means for Vermont and New Hampshire are not equal." ;
proc ttest data=mP2010;
class State;
var mP10mean;
run;

/** Mortgage Payments 2015 **/
proc sort data= BookData.Ipums2015Basic out= work.mort2015;
	by State MortgageStatus;
	where State in ('Vermont', 'New Hampshire') and MortgageStatus contains 'Yes';
run;

ods exclude all;
proc means data= work.mort2015 mean sum std stddev stderr;
	where State in ('Vermont', 'New Hampshire') and MortgageStatus contains 'Yes';
	class State MortgageStatus;
	var MortgagePayment;
	ods output summary=mortPayment2015;
run;

data mP2015(keep=State MortgagePayment MortgageStatus mP15mean);
	merge mortPayment2015(in=useThese) work.mort2015;
	by State MortgageStatus;
	if useThese;
	mP15mean=MortgagePayment_Sum/Nobs;
run;

/** Difference of Means 2015 **/
ods select all;
ods graphics off;
title j=center height=14pt 
	  'Test for difference of means of Mortgage Payments for Vermont and New Hampshire Year 2015'; 
title2 j=center height=12pt 
	  'H0: mu_V = mu_NH vs. Ha: mu_V != mu_NH, significance level alpha = 0.05'; 
footnote1 j=left height=12pt
    	 "We see that there is enough evidence to assume the variances are not equal, so we consider the 
    	  Satterthwaite results. 
    	  Since p-value < 0.0001 < alpha = 0.05 we reject the null hypothesis and conclude that there is a difference 
    	  between the mean mortgage payments for Vermont between New Hampshire in the year 2015." ;
footnote2 j=left height=12pt " " ;
footnote3 j=left height=12pt
    	 "95% confidance interval: (280.3, 282.1), we see that zero is not within the confidence interval confirming our 
    	 conclusion that the mortgage payment means for Vermont and New Hampshire are not equal." ;
footnote4 j=left height=12pt " " ;
footnote5 j=left height=12pt    	  
		  "Based on the test results for the three years, I do not believe there is a change in the difference in average 
    	  mortgage payment between the two states across the three years. I believe this since all three tests resulted in 
    	  the rejection of the null hypothesis. Also, the majority of mortgages are between 20 - 30 years so we can 
    	  reasonably assume that most of the mortgage payments in the three datasets did not change significantly enough in 
    	  10 years for there to be a change in differences.";  
proc ttest data=mP2015;
class State;
var mP15mean;
run;


/** ---------- Difference of Propotions Tests ---------- **/
/** 2005 **/
title j=center height=14pt
	  'Test for difference of proportions of Mortgaged Homes for Vermont and New Hampshire Year 2005';
title2 j=center height=12pt 
	  'H0: p_V = p_NH vs. Ha: p_V != p_NH, significance level alpha = 0.05'; 
footnote1 j=left height=12pt
    	 "Since p-value = 0.2695 > 0.05 we fail to reject the null hypothesis and conclude that there is not a difference 
    	 between the propotion of mortgaged homes between Vermont and New Hampshire for the year 2005.";
footnote2 j=left height=12pt " " ;
footnote3 j=left height=12pt
    	 "95% confidance interval: (-0.0023, 0.0070), we see that zero is within the confidence interval confirming our 
    	 conclusion that the proportion of mortgaged homes for Vermont and New Hampshire are equal." ;
proc freq data=work.mort2005;
	where State in ('Vermont', 'New Hampshire') and MortgageStatus contains 'Yes';
	table State*MortgageStatus / nocol format=comma5. chisq riskdiff;
	ods exclude fishersexact;
run;

/** 2010 **/
title j=center height=14pt
	  'Test for difference of proportions of Mortgaged Homes for Vermont and New Hampshire Year 2010';
title2 j=center height=12pt 
	  'H0: p_V = p_NH vs. Ha: p_V != p_NH, significance level alpha = 0.05';
footnote1 j=left height=12pt
    	 "Since p-value = 0.3445 > 0.05 we fail to reject the null hypothesis and conclude that there is not a difference 
    	 between the propotion of mortgaged homes between Vermont and New Hampshire for the year 2010." ; 
footnote2 j=left height=12pt " " ;
footnote3 j=left height=12pt
    	 "95% confidance interval: (-0.0016, 0.0040), we see that zero is within the confidence interval confirming our 
    	 conclusion that the proportion of mortgaged homes for Vermont and New Hampshire are equal." ;
proc freq data=work.mort2010;
	where State in ('Vermont', 'New Hampshire') and MortgageStatus contains 'Yes';
	table State*MortgageStatus / nocol format=comma5. chisq riskdiff;
	ods exclude fishersexact;
run;

/** 2015 **/
title j=center height=14pt
	  'Test for difference of proportions of Mortgaged Homes for Vermont and New Hampshire Year 2015';
title2 j=center height=12pt 
	  'H0: p_V = p_NH vs. Ha: p_V != p_NH, significance level alpha = 0.05';
footnote1 j=left height=12pt
    	 "Since p-value = 0.9619 > 0.05 we fail to reject the null hypothesis and conclude that there is not a difference 
    	 between the propotion of mortgaged homes between Vermont and New Hampshire for the year 2015."; 
footnote2 j=left height=12pt " " ;
footnote3 j=left height=12pt
    	 "95% confidance interval: (-0.0049, 0.0051), we see that zero is within the confidence interval confirming our 
    	 conclusion that the proportion of mortgaged homes for Vermont and New Hampshire are equal." ;
footnote4 j=left height=12pt " " ;
footnote5 j=left height=12pt    	  
		  "Based on the test results for the three years, I do not believe there is a change in the difference in the proportion of 
    	  mortgaged homes between the two states across the three years. I believe this since all three tests resulted in 
    	  failing to reject the null hypotheses. Again, since the majority of mortgages are between 20 - 30 years we can 
    	  reasonably assume that the proportion of mortgaged homes in the three datasets would not change significantly enough in 10 years for 
    	  there to be a change in differences.";    
proc freq data=work.mort2015;
	where State in ('Vermont', 'New Hampshire') and MortgageStatus contains 'Yes';
	table State*MortgageStatus / nocol format=comma5. chisq riskdiff;
	ods exclude fishersexact;
run;

ods pdf close;






