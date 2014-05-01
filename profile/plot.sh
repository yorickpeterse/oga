#!/usr/bin/env bash

sample_file="$1"
plot_script="$2"

if [[ ! -f "$sample_file" ]]
then
    echo "The sample file ${sample_file} does not exist"
    exit 1
fi

if [[ ! -f "$plot_script" ]]
then
    echo "The gnuplot script ${plot_script} does not exist"
    exit 1
fi

gnuplot -e "sample_file='${sample_file}'" "${plot_script}"
