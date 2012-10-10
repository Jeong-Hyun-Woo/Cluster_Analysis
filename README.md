statistical_clistering_method
======================
概要は省略

sorting_packetフォルダにはファイル読み込みをするためパケット数を操作するプログラムになっている。
 
使い方
------
### main.rb ###
読み込むファイルを指定する必要があります。このプログラムのためのファイルの生成は後のsorting_packetフォルダで行います。
また、実行後にdev_【ファイル名】.txtとR_k_【ファイル名】.txtというtxtファイルが生成されます。使用方法は以下の通りです。

	$ ruby main.rb 【通常状態ファイル名】【異常を含むファイル名】【Rで読み込むファイル名】
 (注)Rubyは1.9.3以降を使用する必要があります。

### sorting_packet/read_in_packet.rb ###
(注)未完成

予定ではWireshark等でキャプチャしたものをTsharkで変換テキストファイルを読み込むようにする予定。一種類のプロトコルについて一定時間ごとに区切りファイルに出力する。
 
	$ ruby read_in_packet 【入力ファイル名】 【出力ファイル名】

###sample###
現在使用可能なファイル

Gnuplotでのプロットについて
----------------
main.rbで生成されたファイルと同じディレクトリに移動して以下のようにしてください。


↓対数表示にしてR(k)のプロット

	gnuplot> set logscale y
	gnuplot> plot 'R(k)_test.txt' using 1:2 with linespoints lt 3 lw 3 pt 5 ps 2 

↓元の表示にして逸脱度をプロット

	gnuplot> set autoscale
	gnuplot> plot 'dev_test.txt' using 1:2 with linespoints lt 3 lw 3 pt 5 ps 2

↓タイムスロット毎のパケット数のプロット(現段階)

	gnuplot> plot 'input_data_test.txt' using 1:2 with linespoints lt 3 lw 1 pt 0 ps 2,'input_data_test.txt' using 1:3 with linespoints lt 1 lw 1 pt 0 ps 3,'input_data_test.txt' using 1:4 with linespoints lt 2 lw 1 pt 0 ps 2

	

