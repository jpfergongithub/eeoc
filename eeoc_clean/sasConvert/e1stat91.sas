libname mylib '/myPathHere/';
proc export data = mylib.e1stat91.sas7bdat
outfile = '/myPathHere/e1stat91.csv'
dbms = csv
replace
;
run;
