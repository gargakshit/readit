#!/bin/bash

echo "Building macos..."
flutter build macos --release

echo "Building android..."
flutter build apk --release --split-per-abi
flutter build appbundle --release