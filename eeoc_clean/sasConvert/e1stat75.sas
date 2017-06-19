libname mylib '/myPathHere/';
proc export data = mylib.e1stat75.sas7bdat
outfile = '/myPathHere/e1stat75.csv'
dbms = csv
replace
;
run;
