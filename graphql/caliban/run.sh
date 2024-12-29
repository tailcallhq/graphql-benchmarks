#!/bin/bash

set -e

pwd
cd graphql/caliban
JAR_FILE=$(find . -name "scala-caliban-assembly*")
java -Xms4G -Xmx4G -jar $JAR_FILE
