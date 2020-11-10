---------
  Chapter 7
---------
  
  ---------------
  JOBDUR Data Set
---------------
  
  /* The data set is analyzed in Output 5.9 of P.D. Allison, "Survival
    Analysis Using the SAS System: A Practical Guide."               */
  
  
  data jobdur;
input dur event ed prestige salary;
cards;
1 1 7 3 19
4 1 14 62 17
5 0 16 70 18
2 1 12 43 135
3 1 9 18 12
1 1 11 31 12
1 1 13 26 6
1 1 10 1 4
2 1 12 28 17
3 1 7 25 4
3 1 13 45 15
3 1 17 65 10
3 1 11 37 13
1 1 7 10 9
5 0 11 67 10
2 1 13 45 17
2 2 11 78 8
5 0 11 42 18
2 1 12 24 30
2 1 12 30 9
1 1 10 6 6
1 1 12 23 26
2 1 9 18 8
2 1 14 36 17
3 1 12 42 12
5 1 15 72 6
3 1 12 48 14
2 1 13 52 12
3 1 12 49 105
1 1 9 9 22
1 1 14 37 4
2 1 12 16 7
2 2 10 64 89
1 2 9 73 19
1 2 11 93 16
3 1 8 37 15
4 2 15 100 26
4 1 10 39 32
5 0 17 88 19
1 2 13 50 16
2 1 13 28 15
5 1 18 81 5
5 1 13 51 22
3 1 12 27 17
5 0 17 84 33
1 1 7 23 21
1 2 16 84 26
3 2 17 100 18
4 1 18 46 27
2 1 9 41 7
5 0 18 80 14
2 1 13 30 13
2 1 6 25 6
1 1 15 34 9
3 1 13 40 18
1 2 12 80 38
3 1 13 46 30
3 2 10 63 8
1 1 13 10 7
4 1 17 55 40
3 1 14 50 12
2 1 15 52 7
5 0 14 74 9
1 2 13 85 21
1 1 7 12 16
1 1 16 38 5
5 0 13 67 11
3 1 9 45 15
1 1 11 21 8
5 0 16 68 29
1 2 13 98 35
5 1 12 44 11
5 0 12 52 29
5 0 12 51 53
2 1 9 1 31
2 2 8 36 10
2 1 11 18 8
1 1 8 10 5
1 1 11 10 3
2 1 13 34 14
5 0 15 53 13
1 1 9 42 9
3 1 12 54 15
4 1 10 45 13
5 0 14 63 79
3 2 8 54 27
5 0 15 49 64
4 1 11 50 23
2 1 13 26 9
4 1 17 69 10
3 2 13 90 19
3 1 12 47 14
5 0 14 40 106
5 0 13 71 7
4 1 12 47 51
1 1 11 25 21
5 0 10 52 15
1 1 9 22 19
1 1 16 40 13
1 1 10 17 37
;


/* The following program is found on page 213 of */
  /* "Survival Analysis Using the SAS System, by Allison." */
  
  /* Create the dataset for Discrete Survival */
  data jobyrs;
set jobdur;
do year=1 to dur;
if year=dur and event=1 then quit=1;
else quit=2;
output;
end;
run;

/* Explore the data */
  proc freq data=jobdur; tables dur*event; run;
proc lifetest data=jobdur plots=(s);
time dur*event(0,2); run;

/* Cox regression model with ties=discrete */
  proc phreg data=jobdur;
model dur*event(0,2) = ed prestige salary  / ties=discrete;
run;

/* The following program is found on page 214 of */
  /* "Survival Analysis Using the SAS System, by Allison." */
  /* (modified from Proc Probit to Proc Logistic)  */
  /* (program on page 237 of 2nd edition)  */
  
  
  proc logistic data=jobyrs;
class year / param=reference;
model quit = ed prestige salary year;
run;

/* Calculate predicted hazards */
  /* Use the SAS trick of adding "fake data" with the covariates desired to get
predicted probabilities.  Set the outcome variable to missing for these data lines. */
  data new_data;
ed=12; salary=15; quit=.; fake=1;
do prestige=45,60;
do year=1 to 5; output; 
end; 
end;
run;
proc print data=new_data; run;
/*proc print data=get_hazard; run; */
  data both; set jobyrs new_data; if fake=. then fake=0; 
drop dur event; run;
proc print data=both; run;

proc logistic data=both;
class year  / param=reference;
model quit = ed prestige salary year;
output out=pred_probs predicted=preds;  /* Note OUTPUT statement */
  run;
proc print data=pred_probs; where fake=1; run;

/*proc sort data=pred_probs; by prestige year; run;*/
  axis1 label=(h=2.5 font=arial  a=90 'Hazard') value=(h=1.5 f=arial);
axis2 label=(h=2.5 font=arial 'Year') value=(h=1.5 f=arial);
legend1 across=1 position=(inside top left) label=(f=arial h=2) value=(f=arial h=2) offset=(5,-5);
proc gplot data=pred_probs; where fake=1;
symbol1 L=1 i=join w=4 color=blue;
symbol2 L=3 i=join w=4 color=red;
plot preds*year=prestige / vaxis=axis1 haxis=axis2 legend=legend1; run;

/* Testing Ed * Year Interaction */
  proc logistic data=both;
class year  / param=reference;
model quit = ed prestige salary year ed*year;
run;








