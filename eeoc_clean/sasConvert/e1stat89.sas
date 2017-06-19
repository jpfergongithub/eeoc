libname mylib '/myPathHere/';
proc export data = mylib.e1stat89.sas7bdat
outfile = '/myPathHere/e1stat89.csv'
dbms = csv
replace
;
run;
