#!/bin/bash

mb-util --image_format=pbf $1 $2
gzip -d -r -S .pbf $2/*
find $2 -type f -exec mv '{}' '{}'.pbf \;
