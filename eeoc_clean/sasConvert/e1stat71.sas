libname mylib '/myPathHere/';
proc export data = mylib.e1stat71.sas7bdat
outfile = '/myPathHere/e1stat71.csv'
dbms = csv
replace
;
run;
