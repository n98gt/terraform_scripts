#!/usr/bin/env bash
# dir should not conaint «── » in its name
# set -eu
readonly dirs_with_decription=`find . -name ".desc"`

# echo "$dirs_with_decription"
# printf %q "$IFS"

readonly tree_output=`tree -idNf --noreport`
tree_output_indent=`tree -dN --noreport`
while IFS= read -r line
do
    # echo $line
    content=`cat "${line}"`
    echo "${content}"
    dirname=${line%/*}
    line_number=`echo "$tree_output" |grep -m1 -nP "^${dirname}$" | cut -f1 -d:`
    # line_number=`echo "$tree_output" |grep -m1 -nP "^${dirname}$" `


    # tree_output=${tree_output/"${dirname}"/"${dirname}: ${content}"}
    tree_output_indent=`sed -e "${line_number}s/.*/$content/" < "$tree_output_indent"`
    # OIFS="$IFS"
    # IFS=$'/'
    # for dir in $dirname
    # do
    #     # echo 123
    #     echo "-----------current dir is: ${dir}"
    #     echo "$tree_output" |grep -m1 -P "^./$dir"
    #     # echo "$tree_output" |grep -m1 -oP New

    # done
    # IFS="$OIFS"
done <<< "$dirs_with_decription"

# echo "${tree_output_indent}"

# echo $IFS
# printf %q "$IFS"

# readonly test_dir='./temporary_instance_directories/ec2_instance_setup/vpc/.desc'
# readonly dirname=${test_dir%/*}
# # echo

# echo `dirname $test_dir`



# OIFS="$IFS"
# IFS=$'/'
# for word in $line
# do
#     echo $word
# done
# IFS="$OIFS"

# construct_jq_command(){
#     echo
# }

# └──
