#!/bin/sh
clang -fobjc-arc -framework Cocoa -framework QuartzCore icon.m -o icon
./icon
