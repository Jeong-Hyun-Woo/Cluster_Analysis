statistical_clistering_method
======================
概要は省略

sorting_packetフォルダにはファイル読み込みをするためパケット数を操作するプログラムになっている。
 
使い方
------
### main.rb ###
読み込むファイルを指定する必要があります。このプログラムのためのファイルの生成は後のsorting_packetフォルダで行います。
また、実行後にdev_【ファイル名】.txtとR_k_【ファイル名】.txtというtxtファイルが生成されます。使用方法は以下の通りです。

	$ ruby main.rb 【ファイル名】
 (注)Rubyは1.9.3以降を使用する必要があります。

### sorting_packet/read_in_packet.rb ###
(注)未完成

予定ではWireshark等でキャプチャしたものをTsharkで変換テキストファイルを読み込むようにする予定。一種類のプロトコルについて一定時間ごとに区切りファイルに出力する。
 
	$ ruby read_in_packet 【入力ファイル名】 【出力ファイル名】

###sort_packet.rb###
(注)未完成

read_in_packetで生成したファイルを統合し、main.rbで使用できるファイルを生成する。現在は読み込むファイル数は3つであるが、今後第１引数で読み込むファイルの数を指定し好きな数読み込めるようにする予定。

	$ sort_packet.rb 【入力ファイル名】 【入力ファイル名】 【入力ファイル名】 【出力ファイル名】

###sample###
現在使用可能なファイル

Gnuplotでのプロットについて
----------------
main.rbで生成されたファイルと同じディレクトリに移動して以下のようにしてください。

	逸脱度のプロット
	$gnuplot

	G N U P L O T
	Version 4.6 patchlevel 0    last modified 2012-03-04 
	Build System: Darwin x86_64

	Copyright (C) 1986-1993, 1998, 2004, 2007-2012
	Thomas Williams, Colin Kelley and many others

	gnuplot home:     http://www.gnuplot.info
	faq, bugs, etc:   type "help FAQ"
	immediate help:   type "help"  (plot window: hit 'h')

	Terminal type set to 'x11'
	gnuplot> plot 'R(k)_test.txt' using 1:2 with linespoints lt 3 lw 3 pt 5 ps 2 
