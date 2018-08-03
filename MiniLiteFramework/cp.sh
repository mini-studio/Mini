target_dir=/Users/Wuquancheng/Documents/workspace/ChEdu/iOS/CHEdu-Reading/Frameworks/
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
