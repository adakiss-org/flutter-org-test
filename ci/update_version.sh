#!/bin/bash
set -e

VERSION_INPUT="$1"
BUILD_FILE="build_number"

if [[ -f "$BUILD_FILE" ]]; then
  CURRENT_BUILD=$(cat "$BUILD_FILE")
else
  CURRENT_BUILD=0
fi

if [[ -n "$VERSION_INPUT" ]]; then
  echo "1" > "$BUILD_FILE"
  echo "version: $VERSION_INPUT+1" > pubspec.yaml.tmp
  sed -i "s/^version:.*/$(cat pubspec.yaml.tmp)/" pubspec.yaml
  echo "Set version to $VERSION_INPUT+1" > .commit_msg
else
  NEXT_BUILD=$((CURRENT_BUILD + 1))
  echo "$NEXT_BUILD" > "$BUILD_FILE"
  VERSION_LINE=$(grep "^version:" pubspec.yaml)
  VERSION_BASE=${VERSION_LINE%%+*}
  sed -i "s/^version:.*/$VERSION_BASE+$NEXT_BUILD/" pubspec.yaml
  echo "Increment build number to $NEXT_BUILD" > .commit_msg
fi
