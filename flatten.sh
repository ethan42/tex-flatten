#!/bin/bash

tmp=/tmp/tex-flatten
cp $1 $tmp

while true; do
    inputs=`grep -v '%' $tmp | grep -o '\\input{.*}' | cut -f 2 -d '{' | cut -f 1 -d '}'`
    if [ "$inputs" == "" ]; then
        break
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

sed -i 's,\\begin{lstlisting},\\begin{verbatim},g' $tmp
sed -i 's,\\end{lstlisting},\\end{verbatim},g' $tmp
sed -i 's,\\uline,\\underline,g' $tmp
sed -i 's,\\squish,,g' $tmp

cat $tmp
