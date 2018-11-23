#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'

d_path=$(pwd)
export project=$1

if [ ! -z $project ] && [ "glt" == "$project" ] || [ "gltv2" == "$project" ];then
 echo $project
 if [ "glt" == "$project" ];then export repo_orig_file=app-list-input-withPort.txt;fi
 if [ "gltv2" == "$project" ];then export repo_orig_file=app-list-input-withPort-REVEL.txt;fi
else
 echo "Enter your project name glt and gltv2, example: ./${0} glt";exit 0;
fi

error_clone_file_name=error_clone_ms
rm -fv $error_clone_file_name

## repo to get repo list
repo_list_dir=glt-jenkins-seed-jobs-devops
list_branch=revel-develop

git clone ssh://git@github.com/gltin/${repo_list_dir}.git -b $list_branch
cd $repo_list_dir
git pull origin $list_branch
cd $d_path

## COpyting file in current location
find $repo_list_dir -name ${repo_orig_file} -exec cp {} . \;

##Create a new file
repofile=repo-list-new.txt

cat $repo_orig_file | grep -Ev '^>|^<|^#|^$|^=|%|^~' | awk '{print $1,$4}' > $repofile

#repofile=repo-list.txt
find $repo_list_dir -name $repofile -type f -exec cp -fv {} . \;

cat $repofile|grep '\-ui' > ui-list.txt

cat $repofile|grep -v '\-ui' > no-ui-list.txt
list=no-ui-list.txt

repo_dir="${project}/all-MS"
mkdir -pv $repo_dir

###creating dir
for a in $(cat $list|awk '{print $1}');
do
if [ -d ${repo_dir}/$a ];then
  echo Directory Exsist: $a
else
  echo "Creating a new dir: $a"
  mkdir -v ${repo_dir}/$a
fi
done

### Cloning repos -------------------
for i in $(cat $list|awk '{print $1}'|grep -e imc -e rbassignment -e telemetry );
#for i in $(cat $list|awk '{print $1}');
do
 cd $d_path
 repo=$(grep -w $i $list |awk '{print $2}')

 echo "======================================================================================================== [ $i = $repo ]"
 ##### making correct repo
 if [ "$i" == "gms" ];then repo=glt-graph-management;fi
 if [ "$i" == "telemetry" ];then repo=glt-telemetry-nfr;fi
 if [ "$i" == "bridge-revel-assignment" ];then repo=glt-bridge-revel-assignment;fi
 #####
 cd ${repo_dir}/$i
 pwd
 required_branch=master
 echo "Clone the repo -->"
 git clone ssh://git@github.com/${project}/${repo}.git -b $required_branch
 if [ "$?" != "0" ];then
  echo "Pull the changes"
  cd ${repo}
  if [ "$?" != "0" ];then echo -e "${RED}ERROR Not Found:${NC} $i $repo"; echo $i $repo >> ${d_path}/$error_clone_file_name;continue;fi
  echo stat: $?
  git branch
  git pull origin $required_branch
 fi

done

if [ -f ${d_path}/${error_clone_file_name} ];then echo -e "\n${RED}Error to clone some MS, Please check this file $error_clone_file_name ${NC}";fi
