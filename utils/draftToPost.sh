#########################################################################
# File Name: dToP.sh
# Author: ma6174
# mail: ma6174@163.com
# Created Time: Wed 14 Sep 2016 01:52:54 PM UTC
#########################################################################
#!/bin/bash

base=~/zblog/
file=$1;
date=$2;

if [ ! "$date" ];then
    date=$(date +%Y-%m-%d)
fi

from="$base""_drafts/""$file";
to="$base""_posts/""$date""-""$file";
mv  $from $to;

