#!/bin/bash

INDEX_PATH=index
PACKAGE_PATH=package

rm 00-index.tar.gz 2>/dev/null

rm -r $INDEX_PATH 2>/dev/null

mkdir $INDEX_PATH

for tb in $(find $PACKAGE_PATH -name "*.tar.gz"); do
    if [[ $tb =~ ^$PACKAGE_PATH/(.+)-(.+)\.tar\.gz ]]; then
        pname=${BASH_REMATCH[1]}
        version=${BASH_REMATCH[2]}
        cabal_dir=$INDEX_PATH/$pname/$version
        cabal_file=$INDEX_PATH/$pname/$version/$pname.cabal
        mkdir -p $cabal_dir

        for f in $(tar ztf $tb); do
            if [[ $f =~ .*\.cabal ]]; then
                tar zxOf $tb $f > $cabal_file
            fi
        done

        echo "add to index: "$cabal_file
    fi
done;

ls $INDEX_PATH | xargs tar zcf 00-index.tar.gz -C $INDEX_PATH

echo "success. 00-index.tar.gz updated."
