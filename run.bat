@echo off
set location=odin_crawler
cls
odin strip-semicolon %location%
odin test %location%
odin run %location%