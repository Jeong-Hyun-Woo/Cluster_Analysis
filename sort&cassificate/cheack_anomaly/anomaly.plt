set xrange [0:31]
set grid
unset logscale y
set xlabel "time slot" font "Times-Roman,25"
set ylabel "deviation" font "Times-Roman,25"
set key spacing 4 font "Times-Roman,25"

set terminal postscript eps enhanced color
#set output "d_5_3_10_11_9_11_p4_k.eps"
#set output "d_5m_3m_10_11_p4_k.eps"
set output "d_5m_3m_9_10_9_11_p4_x.eps"


plot "./d_5m_3m_9_10_9_11_x.txt" index 0 using 1:2 with points ps 3 pt 7 lc 2 title "normally", "./d_5m_3m_9_10_9_11_x.txt" index 1 using 1:2 with points ps 3 pt 7 lc 1 title "anomaly" , 4.425434818769749 lw 3 lt 1 lc 3 title "threshold"


#plot "./d_5_3_10_11_p4_k.txt" index 0 using 1:2 with points ps 3 pt 7 lc 2 title "normally", "./d_5_3_10_11_p4_k.txt" index 1 using 1:2 with points ps 3 pt 7 lc 1 title "anomaly" , 6.1208586404937675 lw 3 lt 1 lc 3 title "threshold"

#plot "./d_5_3_10_11_9_11_p4_k.txt" index 0 using 1:2 with points ps 3 pt 7 lc 2 title "normally", "./d_5_3_10_11_9_11_p4_k.txt" index 1 using 1:2 with points ps 3 pt 7 lc 1 title "anomaly" , 5.627791235263556 lw 3 lt 1 lc 3 title "threshold"

set output
set terminal x11
