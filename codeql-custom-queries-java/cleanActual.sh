#!/usr/bin/bash

shopt -s globstar

rm **/*.actual

./updateReadme.sh
