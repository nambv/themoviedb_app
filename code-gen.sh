agrs=''
if [[ $1 == '-f' ]]
then
    agrs='--delete-conflicting-outputs'
fi
dart run build_runner build ${agrs}