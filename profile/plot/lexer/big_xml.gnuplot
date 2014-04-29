#!/usr/bin/env gnuplot

set title "Lexing 10MB of XML"

set xlabel "Sample"
set ylabel "Memory (MB)"

set yrange [0:*]

set term qt persist
set grid

set style line 1 lc rgb "#0060ad" lt 1 lw 2 pt 7 ps 1

plot "profile/samples/lexer/big_xml.txt" \
    using 0:($1 / 1024 ** 2) \
    with linespoints ls 1 \
    title "Memory"

# vim: set ft=gnuplot:
