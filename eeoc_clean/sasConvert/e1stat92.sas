libname mylib '/myPathHere/';
proc export data = mylib.e1stat92.sas7bdat
outfile = '/myPathHere/e1stat92.csv'
dbms = csv
replace
;
run;
