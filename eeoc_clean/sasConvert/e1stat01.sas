libname mylib '/myPathHere/';
proc export data = mylib.e1stat01.sas7bdat
outfile = '/myPathHere/e1stat01.csv'
dbms = csv
replace
;
run;
