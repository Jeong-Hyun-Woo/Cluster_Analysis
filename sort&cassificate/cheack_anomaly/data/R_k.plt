
set xrange [1:30]
set logscale y
set xlabel "time slot" font "Times-Roman,25"
set ylabel "R(k)" font "Times-Roman,25"


set terminal postscript eps enhanced color
set output "R(k)_d_5_3_10_11_9_11_p4_k.eps"

plot "/Users/kohei/Desktop/analysis_method_of_deviation/statistical_clistering_method/result/R(k)/R(k)_d_5m_10_11_p4.txt" using 1:2 with linespoints lw 3 lc 1 lt 1 pt 7 ps 2 title "R(k)"

set output
set terminal x11
