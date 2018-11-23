# Below directories are responsible

  - gltv1 (To clone and push)
  - gltv2 (To clone and push)

##### how to execute
## Jump in gltv1 or gltv2, see the example for gltv1
### To clone all repository
### It will pickup all MS name from glt-jenkins-seed-jobs-devops repo using file glt-jenkins-seed-jobs-devops
  - cd gltv1
  - ./clone-all-gltv1.sh

## Make the changes in this file to get updates, like here I was using statup.sh file to update for all MS repo. Make changes in the script as per your requirement
  - ./get.sh

## Once we executed "get.sh" then execute below script to Push the changes for all MS. Make changes in the script as per your requirement
  - ./push-check-gltv1.sh
