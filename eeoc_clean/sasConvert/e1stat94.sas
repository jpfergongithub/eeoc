libname mylib '/myPathHere/';
proc export data = mylib.e1stat94.sas7bdat
outfile = '/myPathHere/e1stat94.csv'
dbms = csv
replace
;
run;
