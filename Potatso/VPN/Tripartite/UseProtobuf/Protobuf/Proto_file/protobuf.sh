#/usr/bin/bash

protoc --proto_path=. --python_out=. --js_out=import_style=commonjs,binary:. --java_out=. --objc_out=. ./common.proto ./user.proto ./node.proto
