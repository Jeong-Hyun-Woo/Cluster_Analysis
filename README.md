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

### sort_data.rb ###

mainで使用するために、mysqlから時間毎に分けたCSVファイルを読み込み
タイムスロット毎のプロトコルを種別毎に分けてカウントし、main.rbで使用する2つのファイルを作成する。
(時間分けもできるが処理時間がかかるため、コメントアウトしている。)
 
	$ ruby sort_data.rb 【入力ファイル名】 【出力ファイル名】【出力ファイル名(R言語用CSVファイル)】

### sort_data2.rb ###

sort_data.rbのwiresharkから作成したCSVファイルを振り分ける版。
12種類に分類する。使用方法はsort_data.rbを同様。

	$ ruby sort_data2.rb 【入力ファイル名】 【出力ファイル名】【出力ファイル名(R言語用CSVファイル)】

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

	

