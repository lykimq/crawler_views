#!/usr/bin/env bash

npm_fetch(){
    npm install node-fetch
}

run(){
    node crawler.js
}

report(){
    run >& report.txt
}

case "$1" in 
npm_fetch)
 npm_fetch
 ;;
run)
 run
 ;;
report)
 report
 ;;
esac