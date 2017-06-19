libname mylib '/myPathHere/';
proc export data = mylib.e1stat74.sas7bdat
outfile = '/myPathHere/e1stat74.csv'
dbms = csv
replace
;
run;
