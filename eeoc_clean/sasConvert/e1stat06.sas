libname mylib '/myPathHere/';
proc export data = mylib.e1stat06.sas7bdat
outfile = '/myPathHere/e1stat06.csv'
dbms = csv
replace
;
run;
