#!/usr/bin/bash

# Autoriser l'execution récursive
shopt -s globstar

# Run les tests
codeql test run **/*.ql

# Nettoyer
rm -r **/*.testproj

# Update
./updateReadme.sh
