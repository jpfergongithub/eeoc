libname mylib '/myPathHere/';
proc export data = mylib.e1stat78.sas7bdat
outfile = '/myPathHere/e1stat78.csv'
dbms = csv
replace
;
run;
