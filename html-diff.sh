#! /bin/bash

exec diff \
	--unchanged-line-format='' \
	--old-line-format='<span style="font-size: 100pt; color: red">-</span>%L' \
	--new-line-format='<span style="font-size: 100pt; color: green">+</span>%L' \
	"$@"
