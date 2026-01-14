#!/bin/sh

set -e

echo "--- Building hs-base64-encode-lines ---"
cabal build
echo ""

BIN=$(cabal exec -- which hs-base64-encode-lines)

echo "--- Running hs-base64-encode-lines with sample input ---"
echo "Input:"
printf 'hello\nworld\n'
echo ""

echo "Output:"
printf 'hello\nworld\n' | "${BIN}"

echo ""
echo "--- Example Finished ---"
