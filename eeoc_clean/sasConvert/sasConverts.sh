#!/bin/bash
for i in {0..9}
do
    sas e1stat0$i.sas
done
sas e1stat66.sas
for i in {71..99}
do
    sas e1stat$i.sas
done
