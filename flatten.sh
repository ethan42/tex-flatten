#!/bin/bash

tmp=/tmp/tex-flatten
cp $1 $tmp

while true; do
    inputs=`grep -v '%' $tmp | grep -o '\\input{.*}' | cut -f 2 -d '{' | cut -f 1 -d '}'`
    if [ "$inputs" == "" ]; then
        cat $tmp
        exit 0
    fi
   echo $inputs

    # Replace loop
    sedline=""
    for input in $inputs; do
        escinput=`echo $input | sed 's,\/,\\\/,g'`
        sedline="-e \"/input{$escinput}/ {
                  r $input.tex
                  d}\" $sedline"
    done

    /bin/bash -x -c "sed -i $sedline $tmp" &> /dev/null
done

