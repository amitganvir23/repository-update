#!/bin/bash
d_path=$(pwd)
project=glt
## repo to get repo list
repo_list_dir=glt-jenkins-seed-jobs-devops
list_branch=revel-develop

git clone ssh://git@github.com/gltin/${repo_list_dir}.git -b $list_branch
cd $repo_list_dir
git pull origin $list_branch
cd $d_path

##Use exsisting file to search
repo_orig_file=app-list-input-withPort.txt

## COpyting file in current location
find $repo_list_dir -name ${repo_orig_file} -exec cp {} . \;

##Create a new file
repofile=repo-list-new.txt

#cat $repo_orig_file | grep -v '^#'| grep -v ^$ |awk '{print $1,$4}' > $repofile
cat $repo_orig_file | grep -Ev '^>|^<|^#|^$|^=|%|^~' | awk '{print $1,$4}' > $repofile

#repofile=repo-list.txt
find $repo_list_dir -name $repofile -type f -exec cp -fv {} . \;

cat $repofile|grep '\-ui' > ui-list.txt
#list=ui-list.txt

cat $repofile|grep -v '\-ui' > no-ui-list.txt
list=no-ui-list.txt

mkdir -v all-MS
###creating dir
for a in $(cat $list|awk '{print $1}');
do
if [ -d all-MS/$a ];then
  echo Directory Exsist: $a
else
  echo "Creating a new dir: $a"
  mkdir -v all-MS/$a
fi
done

### Cloning repos
for i in $(cat $list|awk '{print $1}');
do
cd $d_path
repo=$(grep -w $i $list |awk '{print $2}')

echo "======================================================================================================== [ $i = $repo ]"
##### making correct repo
if [ "$i" == "gms" ];then repo=glt-graph-management;fi
if [ "$i" == "telemetry" ];then repo=glt-telemetry-nfr;fi
if [ "$i" == "bridge-revel-assignment" ];then repo=glt-bridge-revel-assignment;fi
#####
cd all-MS/$i
pwd
required_branch=master
git clone ssh://git@github.com/${project}/${repo}.git -b $required_branch
if [ "$?" != "0" ];then
cd ${repo}
git branch
git pull origin $required_branch
fi

done
