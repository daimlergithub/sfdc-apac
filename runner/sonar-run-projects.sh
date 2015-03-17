#!/bin/bash

for dir in /opt/sonar-projects/*; do
        if [ -f $dir/sonar-project.properties ]; then
                cd $dir && ant -f ../antbuild.xml analyse
        fi
done

