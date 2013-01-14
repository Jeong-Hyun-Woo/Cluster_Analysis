statistical_clistering_method
x-means法を使用したバージョンはxmeans_statistical_clistering_methodを使用
使用方法は同じ
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

### sort_data.rb ###

mainで使用するために、mysqlから時間毎に分けたCSVファイルを読み込み
タイムスロット毎のプロトコルを種別毎に分けてカウントし、main.rbで使用する2つのファイルを作成する。
(時間分けもできるが処理時間がかかるため、コメントアウトしている。)
 
	$ ruby sort_data.rb 【入力ファイル名】 【出力ファイル名】【出力ファイル名(R言語用CSVファイル)】

### sort_data2.rb ###

wiresharkから作成したCSVファイルを振り分ける。
種類の分類は各自で設定する必要がある。使用方法はsort_data.rbを同様。

	$ ruby sort_data2.rb 【入力ファイル名】 【出力ファイル名】【出力ファイル名(R言語用CSVファイル)】


### sort_data3.rb ###
指定した時間から指定した間隔で指定したタイムスロット数に分割した後に、プロトコル種別毎にカウントする。
	$ ruby sort_data2.rb 【タイムスロット開始時間】 【タイムスロットの時間間隔】 【タイムスロット数】【入力ファイル名】 【出力ファイル名】


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

↓クラスタ毎のプロトコル種別の平均、標準偏差を出力

	gnuplot> unset key
	gnuplot>set xzero axis lt -1
	gnuplot>boxwidth 0.25
	gnuplot>set xrange[0:4]
	gnuplot>plot "cluster_0" using 1:2 with boxes fs solid 0.2, "fcluster_0" using 1:2:3 with errorbars lt 3, "cluster_1" using 1:2 with boxes fs solid 0.2 , "cluster_1" using 1:2:3 with errorbars lt 1


