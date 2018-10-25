project=Mini3rdFramework
sdk=$2
if ( [ "$1" = "-c" ] );then
xcodebuild clean -configuration Debug  -sdk iphoneos${sdk}
xcodebuild clean -configuration Debug  -sdk iphonesimulator${sdk}
xcodebuild clean -configuration Release  -sdk iphoneos${sdk}
xcodebuild clean -configuration Release  -sdk iphonesimulator${sdk}
fi

xcodebuild -configuration Debug  -sdk iphoneos${sdk}
xcodebuild -configuration Debug  -sdk iphonesimulator${sdk}
xcodebuild -configuration Release  -sdk iphoneos${sdk}
xcodebuild -configuration Release  -sdk iphonesimulator${sdk}


debug_iphoneos_lib=Build/Debug-iphoneos/lib${project}.a
debug_iphonesimulator_lib=Build/Debug-iphonesimulator/lib${project}.a
release_iphoneos_lib=Build/Release-iphoneos/lib${project}_release.a
release_iphonesimulator_lib=Build/Release-iphonesimulator/lib${project}_release.a
linkedDebugLib=Build/lib${project}.a
linkedReleaseLib=Build/lib${project}_release.a
lipo -create "$debug_iphoneos_lib" "$debug_iphonesimulator_lib" -output "$linkedDebugLib"
lipo -create "$release_iphoneos_lib" "$release_iphonesimulator_lib" -output "$linkedReleaseLib"

rm -fr Build/Headers
mkdir Build/Headers
src_dir=${project}/Classes/
dist_dir=Build/Headers/${project}
rm -fr $dist_dir
mkdir -p $dist_dir
echo $src_dir
echo $dist_dir
cp -fr $src_dir $dist_dir
find $dist_dir/ -name "*.svn" |xargs rm -rf
find $dist_dir/ -name "*.git" |xargs rm -rf
find $dist_dir/ -name "*.*"|grep -v '\.h$' |xargs rm -rf

rm -fr Build/Debug-*
rm -fr Build/Release-*
rm -fr Build/*.build
