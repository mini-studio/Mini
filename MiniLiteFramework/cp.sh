target_dirs=(/Users/Wuquancheng/Documents/workspace/code/ChEdu/iOS/CHEdu-Reading/Frameworks/ /Users/Wuquancheng/Documents/workspace/code/scene/filmcrew/Frameworks/)
for target_dir in ${target_dirs[*]}
do
if [ -f './Build/libMiniLiteFramework.a' ]; then
  cp ./Build/libMiniLiteFramework.a $target_dir
  echo 'cp ./Build/libMiniLiteFramework.a sccuessfull'
else
   echo 'Not found ./Build/libMiniLiteFramework.a'
fi

if [ -f './Build/libMiniLiteFramework_release.a' ]; then
   cp ./Build/libMiniLiteFramework_release.a $target_dir
   echo 'cp ./Build/libMiniLiteFramework_release.a sccuessfull'
else
  echo 'Not found ./Build/libMiniLiteFramework_release.a'
fi	
done



