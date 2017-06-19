libname mylib '/myPathHere/';
proc export data = mylib.e1stat97.sas7bdat
outfile = '/myPathHere/e1stat97.csv'
dbms = csv
replace
;
run;
