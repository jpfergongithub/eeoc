libname mylib '/myPathHere/';
proc export data = mylib.e1stat96.sas7bdat
outfile = '/myPathHere/e1stat96.csv'
dbms = csv
replace
;
run;
