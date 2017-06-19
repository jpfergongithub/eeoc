libname mylib '/myPathHere/';
proc export data = mylib.e1stat05.sas7bdat
outfile = '/myPathHere/e1stat05.csv'
dbms = csv
replace
;
run;
