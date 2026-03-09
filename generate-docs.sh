#!/bin/bash

jazzy \
  --clean \
  --output "docs" \
  --objc \
  --umbrella-header SensingKit/SensingKit.h \
  --framework-root $(pwd) \
  --sdk iphoneos \
  --author "Kleomenis Katevas" \
  --author_url "https://www.sensingkit.com" \
  --source-host github \
  --source-host-url "https://github.com/SensingKit/SensingKit-iOS" \
  --module "SensingKit-iOS"
