#!/bin/bash
## export variable to get files from source
repo=glt-learner-course-delivery-kernel
project=glt
branch=ssl-fix
source_file=(startup.sh)

##------------
d_path=$(pwd)
mkdir templates
cd templates
rm -rf changes_files
mkdir changes_files

git clone ssh://git@github.com/${project}/${repo}.git -b $branch
cd $repo
git pull origin $branch

for file in "${source_file[@]}"
do
 echo $file
 cp -vf $file ../changes_files/
 echo $file >> ../changes_files/file_list.txt
done

cd $d_path
