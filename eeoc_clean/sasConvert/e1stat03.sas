libname mylib '/myPathHere/';
proc export data = mylib.e1stat03.sas7bdat
outfile = '/myPathHere/e1stat03.csv'
dbms = csv
replace
;
run;
