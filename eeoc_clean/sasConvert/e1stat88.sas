libname mylib '/myPathHere/';
proc export data = mylib.e1stat88.sas7bdat
outfile = '/myPathHere/e1stat88.csv'
dbms = csv
replace
;
run;
