#!/bin/bash

TAG_ROOT_PATH="/local/"`whoami`"/my_tags/"
TAG_PROJECT_NAME="sofia_lte"
TARGET_PATH=`pwd`

usage()
{
    echo "                                                 "
    echo "Usage: `basename $0` [options]                    "
    echo "      -d   specify directory to store tag files  "
    echo "      -p   specify project name                  "
    echo "                                                 "
    exit
}

while [ $# -gt 0 ]; do
    case $1 in
    "-d")
        shift
        if [ $# -le 0 ] || [[ "$1" == "-"* ]] ;then
            echo "please specifi tag root directory"
            exit
        else
            TAG_ROOT_PATH=$1
        fi
        shift
     ;;

     "-p")
        shift
        if [ $# -le 0 ] || [[ "$1" == "-"* ]] ;then
            echo "please specify project name"
            exit
        else
            TAG_PROJECT_NAME=$1
        fi
        shift
     ;;

     *)
        echo "invalid args"
        usage

    esac
done

TAG_PROJECT_PATH=$TAG_ROOT_PATH$TAG_PROJECT_NAME"/"
if [ ! -d $TAG_PROJECT_PATH ] ; then
    mkdir -p $TAG_PROJECT_PATH
fi

pushd $TAG_PROJECT_PATH 

#find -L $TARGET_PATH  \
#     -path "$TARGET_PATH/arch/*" ! -path "$TARGET_PATH/arch/x86" -prune -o \
#     -path "$TARGET_PATH/tmp*" -prune -o \
#     -path "$TARGET_PATH/samples*" -prune -o \
#     -path "$TARGET_PATH/Documentation*" -prune -o \
#     -path "$TARGET_PATH/scripts*" -prune -o \
#     -iname "*.[chxsS]" -print > cscope.files
find -L $TARGET_PATH -iname "*.[chxsS]" -print > cscope.files
cscope -bqk

popd

pushd $TARGET_PATH
##ctags -R -L $TAG_PROJECT_PATH"cscope.files" -f $TAG_PROJECT_PATH"tags"
ctags -R --c++-kinds=+p --fields=+iaS --extra=+q -L $TAG_PROJECT_PATH"cscope.files" -f $TAG_PROJECT_PATH"tags"
popd


