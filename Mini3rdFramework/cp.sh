target_dirs=(/Users/Wuquancheng/Documents/workspace/code/ChEdu/iOS/CHEdu-Reading/Frameworks/ /Users/Wuquancheng/Documents/workspace/code/scene/scene/Frameworks/)
for target_dir in ${target_dirs[*]}
do
if [ -f './Build/libMini3rdFramework.a' ]; then
  cp ./Build/libMini3rdFramework.a $target_dir
  echo 'cp ./Build/libMini3rdFramework.a sccuessfull'
else
   echo 'Not found ./Build/libMiniLiteFramework.a'
fi

if [ -f './Build/libMini3rdFramework_release.a' ]; then
   cp ./Build/libMini3rdFramework_release.a $target_dir
   echo 'cp ./Build/libMini3rdFramework_release.a sccuessfull'
else
  echo 'Not found ./Build/libMiniLiteFramework_release.a'
fi	
done



