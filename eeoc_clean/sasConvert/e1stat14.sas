libname mylib '/myPathHere/';
proc export data = mylib.e1stat14.sas7bdat
outfile = '/myPathHere/e1stat14.csv'
dbms = csv
replace
;
run;
