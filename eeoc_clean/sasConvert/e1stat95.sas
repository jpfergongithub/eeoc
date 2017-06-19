libname mylib '/myPathHere/';
proc export data = mylib.e1stat95.sas7bdat
outfile = '/myPathHere/e1stat95.csv'
dbms = csv
replace
;
run;
