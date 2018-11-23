#!/bin/bash
export repofile=no-ui-list.txt
#export repofile=error_list.txt

export list=${repofile}
project=gltv2

cp error_list.txt error_list2.txt
rm -f error_list.txt

list=no-ui-list.txt
d_path=$(pwd)

rm -f templates/file_name_counts

for files_name in $(cat templates/changes_files/file_list.txt)
do
  file1=${d_path}/templates/changes_files/${files_name}
  wc -c ${file1} >> templates/file_name_counts
done
  export count_line=$(wc -l templates/file_name_counts|awk '{print $1}')

## Speicy which MS we want to skip, like below i have skipped gms and others MS.
for a in $(cat $list|awk '{print $1}' | grep -ve gms -ve telemetry -ve bridge-revel-assignment);
do
  cd ${d_path}
  repo=$(grep -w $a $list |awk '{print $2}')
#===
if [ "$a" == "gms" ];then repo=glt-graph-management;fi
if [ "$a" == "telemetry" ];then repo=glt-telemetry-nfr;fi
if [ "$a" == "bridge-revel-assignment" ];then repo=glt-bridge-revel-assignment;fi
#===

  cd ${d_path}/all-MS/$a
  if [ -d $repo ];then
   cd $repo
   for i in $(seq 1 ${count_line});
   do 
    orig_count=$(sed -n ${i}p ${d_path}/templates/file_name_counts|awk '{print $1}');
    file_name=$(sed -n ${i}p ${d_path}/templates/file_name_counts|cut -d '/' -f 7);
    echo $orig_count $file_name
   echo "============================================================================== [ $a - $repo ]"
   pwd
   #echo "https://github.com/projects/${project}/repos/${repo}/settings/hooks"
   echo "https://github.com/plugins/servlet/branch-permissions/${project}/${repo}"
   echo "https://github.com/projects/${project}/repos/${repo}/browse/startup.sh"
   git fetch origin master
   git reset --hard origin/master
   count=$(wc -c ${file_name}|awk '{print $1}')
   echo $statu_result
   statu_result=$(git status |grep -c "# Your branch is ahead of 'origin/master' by")
   if [ "$statu_result" -ge "1" ]; then echo "*********************** $a not updated";echo "$a ${repo}" >> ${d_path}/error_list_1.txt;count=0;else echo "Already Updated$a";fi

#================================================================
#####Changes need to do in repo
if [ "$orig_count" == "$count" ]
then
  echo "-----------------------------------"
  echo "$orig_count : $count"
  echo "-----------------------------------"
else
  echo "-----------------------------------"
  echo "$orig_count : $count"

cp -fv ${d_path}/templates/changes_files/${file_name} . #ORIG
git branch
git status
echo "------------"


#================================================================

echo -e "Do you need to continue this script (YES/NO): \c"
read confirm

while true;
do

 if [ "$confirm" == "YES" ] || [ "$confirm" == "yes" ]
 then
  echo "Updatting the changes..."
  git commit -am "Update startup.sh from glt:glt-learner-course-delivery-kernel - branch:ssl-fix" #ORIG
  echo "Commit the changes <===================="
  sleep 5
  git push origin master	#ORIG
  echo "Push the changes <===================="
  echo "https://github.com/projects/${project}/repos/${repo}/browse/startup.sh"
  #git status
   statu_result=$(git status |grep -c "# Your branch is ahead of 'origin/master' by")
   if [ "$statu_result" -ge "1" ]; then echo "*********************** $a not updated";echo "$a ${repo}" >> ${d_path}/error_list_2.txt;count=0;else echo "Already Updated$a";fi
  break
  elif [ "$confirm" == "NO" ] || [ "$confirm" == "no" ]
  then
     echo "Entered NO to exit from the Script.........."
     break
  else
    echo -e "Enter again (YES/NO): \c"
    read confirm
 fi

done

fi
done

else

echo "Repository dose not exsist"

fi

done
