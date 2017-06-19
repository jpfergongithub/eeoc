libname mylib '/myPathHere/';
proc export data = mylib.e1stat84.sas7bdat
outfile = '/myPathHere/e1stat84.csv'
dbms = csv
replace
;
run;
