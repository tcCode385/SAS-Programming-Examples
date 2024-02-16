%let raw=/home/u62174441/RawData;
%let SASdat=/home/u62174441/my_shared_file_links/blumj/BookData/SASData;
%let OutPath=/home/u62174441/output;
libname BookData "&SASdat";
filename RawData "&raw";

/** Basic Statistical Summaries on Nonzero Mortgage Payments **/
/** Set up the combined data **/
data Ipums2005_2010_2015;
  set BookData.Ipums2005Basic(in = in2005)
      BookData.Ipums2010Basic(in = in2010)
      BookData.Ipums2015Basic(in = in2015);
  length MetFlag $ 3;
  if in2005 eq 1 then Year = 2005;
    else if in2010 eq 1 then Year = 2010;
    	else if in2015 eq 1 then Year = 2015;
  if Metro in (1,2,3) then MetFlag = 'Yes';
    else if Metro eq 4 then MetFlag = 'No';
      else MetFlag = 'N/A';
run;

/** Univariate Outputs **/
proc univariate data=Ipums2005_2010_2015;
  class Year;
  var MortgagePayment;
  ods select BasicMeasures;
  where MortgagePayment gt 0;
run;

/** Side-by-side Histograms Across Years for Nonzero Mortgage Payments **/
proc sgpanel data=Ipums2005_2010_2015;
  panelby Year / rows=1 novarname;
  histogram MortgagePayment / binstart=250 binwidth=500 scale=proportion fillattrs=(color=magenta) dataskin=gloss;
  colaxis label='Mortgage Payment' valuesformat=dollar8.;
  rowaxis display=(nolabel) valuesformat=percent7.;
  where MortgagePayment gt 0;
run;

/** Boxplot Across Years for Nonzero Mortgage Payments **/
proc sgplot data=Ipums2005_2010_2015;
  vbox MortgagePayment / group=year groupdisplay=cluster extreme nofill Meanattrs=(symbol=Star);
  keylegend / across=3 position=topright location=inside title='' noborder;
  yaxis display=(nolabel) valuesformat=dollar8.;
  where MortgagePayment gt 0;
run;

/** Boxplots Across Years, Separated by Metro Status **/
proc sgpanel data=Ipums2005_2010_2015;
  panelby MetFlag / rows=1 novarname;
  vbox MortgagePayment / group=year groupdisplay=cluster extreme nofill Meanattrs=(symbol=Diamond);
  keylegend / across=3 position=bottom title='';
  rowaxis display=(nolabel) valuesformat=dollar8.;
  where MortgagePayment gt 0 and MetFlag in ('Yes', 'No');
run;

/** Customized Distribution Plots Across Years for Nonzero Mortgage Payments **/
ods exclude all;
proc means data=Ipums2005_2010_2015 min p10 Q1 median Q3 p90 max;
  class year;
  var MortgagePayment;
  where MortgagePayment gt 0;
  ods OUTPUT summary=MPQuantiles;
run;

ods exclude none;
/** Create Plot **/
proc sgplot data=MPQuantiles;
  highlow x=year low=MortgagePayment_Q1 high=MortgagePayment_Q3
   / type=bar legendlabel='Q1 to Q3'  barwidth=.6  fillattrs=(color=cx006D2C) name='Box1';
  highlow x=year low=MortgagePayment_P10 high=MortgagePayment_P90 /
   legendlabel='10th to 90th %-ile' type=bar barwidth=.4 fillattrs=(transparency=0.3 color=cx74C476) name='Box2';
  highlow x=year low=MortgagePayment_Min high=MortgagePayment_Max /
   type=bar legendlabel='Min to Max' barwidth=.2 fillattrs=(transparency=0.3 color=cx50c878) name='Box3'; 
  xaxis values=(2005 2010 2015) display=(nolabel);
  yaxis label='Mortgage Payment' valuesformat=dollar8. values=(0 to 9000 by 1000) offsetmin=0 grid gridattrs=(color=cxdcdcdc);
  keylegend 'Box1' 'Box2' 'Box3' / across=1 position=topright location=inside valueattrs=(size=8pt);
run;


















