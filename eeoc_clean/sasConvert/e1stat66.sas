libname mylib '/myPathHere/';
proc export data = mylib.e1stat66.sas7bdat
outfile = '/myPathHere/e1stat66.csv'
dbms = csv
replace
;
run;
