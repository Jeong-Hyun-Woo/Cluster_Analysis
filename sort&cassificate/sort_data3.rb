 # -*-coding: utf-8 -*-
require File.expand_path("../array",__FILE__)
 
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#タイムスロット分割シリーズ第３段！！
#菅原さんのDB向け，時間も設定すれば振り分けてくれる！
#但し，処理がちょー重い
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-

require "time"

$start_time					#開始時間を指定し格納する
$interval_time				#指定するタイムスロットの間隔を格納する
$timeslot_num				#指定するタイムスロット数を格納する

$protocol1 = []				#プロトコルを格納する
$protocol2 = []				#1より上位?のプロトコルを格納する
$protocol3 = []				#2より上位?のプロトコルを格納する
$time = []					#秒までの時間をtimeで格納する
$micro_second = []			#マイクロ秒をint型で格納する
$timeslot = []				#分割時にハッシュを格納する

$input_file_name			#入力ファイル名を格納
$output_file_name			#出力ファイル名を格納




def set_time()
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#開始時間，タイムスロットの間隔，タイムスロット数の設定を行う
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-

#=begin
	####ファイルが指定されなかった際のエラー処理####
	if ARGV[0].nil?&&ARGV[0].nil?
		p "ERROR：タイムスロットの開始時間を入力してください。"
		exit
	end
	if ARGV[1].nil?&&ARGV[1].nil?
		p "ERROR：タイムスロットの時間間隔を入力してください。"
		exit
	end
	if ARGV[2].nil?&&ARGV[2].nil?
		p "ERROR：タイムスロットをいくつ作るか入力してください。"
		exit
	end
	####ファイルが指定されなかった際のエラー処理####
	if ARGV[3].nil?&&ARGV[3].nil?
		p "ERROR：InputFile名を入力してください。"
		exit
	end
	if ARGV[4].nil?&&ARGV[4].nil?
		p "ERROR：OutputFile名(text)を入力してください。"
		exit
	end
#=end


	$start_time = Time.parse(ARGV[0])		#第一引数から開始時間を指定する(※但し，指定できるのは秒まで)
	$interval_time = ARGV[1].to_i			#第二引数からタイムスロットの時間間隔を指定する(※但し，秒単位での指定)
	$timeslot_num = ARGV[2].to_i				#第三引数からタイムスロット数の設定を行う
	$input_file_name = ARGV[3]
	$output_file_name = ARGV[4]
end





def input()
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#とりあえず，各要素をそれぞれの変数に押し込む
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
	line_c = 0				#一行目が列の名前になっているので，それの回避用変数


    f = File::open($input_file_name,'r')
		f.each do | line|
			x = []          #一列の各要素を入れておく配列
			next if line.index('/n')
			x = line.split(/,/)
			if line_c != 0
				$time << Time.parse(x[1].to_s.delete("\""))
				$protocol1 << x[2].to_s
				$micro_second << x[2].to_i
				$protocol1 << x[3].to_s
				$protocol2 << x[4].to_s
				$protocol3 << x[5].to_s
			elsif line_c == 0
				line_c = 1
			end
		end
    f.close
end





def partition()

#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#時間を区切る
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-

	time = []					#必要ではないが確認の際に用いる
	protocol1 = []				#(注)グローバルではない
	protocol2 = []				#(注)グローバルではない
	protocol3 = []				#(注)グローバルではない
	ts_count = 1				#タイムスロット数をカウントする変数


	check_time = $start_time
	for i in 0...$time.size
		if ts_count > $timeslot_num
			break
		end
		if i == $time.size-1
			time << $time[i]
			protocol1 << $protocol1[i]
			protocol2 << $protocol2[i]
			protocol3 << $protocol3[i]

			hash ={"time"=>time, "p1"=>protocol1, "p2"=>protocol2, "p3"=>protocol3}
			$timeslot << hash
			check_time += $interval_time
			ts_count += 1
		elsif $time[i] < check_time+$interval_time
			time << $time[i]
			protocol1 << $protocol1[i]
			protocol2 << $protocol2[i]
			protocol3 << $protocol3[i]
		else 
			hash ={"time"=>time, "p1"=>protocol1, "p2"=>protocol2, "p3"=>protocol3}
			$timeslot << hash
			check_time += $interval_time
			ts_count += 1
			#初期化
			hash = Hash.new
			time = []
			protocol1 = []
			protocol2 = []
			protocol3 = []
		end
	end
	#p $timeslot
=begin
####分割できているかの確認用####
	for j in 0...$timeslot.size
		p $timeslot[j]
		print "--------------------------\n"
	end
=end
end





def classification()
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#時間で分割したものをプロトコル種別にカウントする
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
	tcp = Array.new($timeslot.size){0}
	http = Array.new($timeslot.size){0}
	#udp = Array.new($timeslot.size){0}
	arp = Array.new($timeslot.size){0}
	other = Array.new($timeslot.size){0}

	for l in 0...$timeslot.size
		for m in 0...$timeslot[l]["p1"].size
			case $timeslot[l]["p1"][m]
			when "eth"
				case $timeslot[l]["p2"][m]
				when "ip"
					case $timeslot[l]["p3"][m]
					when "tcp"
						tcp[l] += 1
					when "http"
						http[l] += 1
					#when "udp"
						#udp[l] += 1
					else
						other[l] += 1
					end
				when "arp"
					arp[l] += 1
				else
					other[l] += 1
				end
				
			else 
				other[l] += 1
			end			
		end
	end



	#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
	#表示，確認用
	#for i2 in 0...$timeslot.size
	#	print "☆=-☆=-☆=-タイムスロット[",i2,"]☆=-☆=-☆=-\n"
	#	print "TCP =",tcp[i2],"\n"
	#	print "UDP =" ,udp[i2],"\n"
	#	print "ARP =" ,arp[i2],"\n"
	#	print "OTHER =" ,other[i2],"\n"
	#end
	#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
	output(tcp,http,arp,other)
end






def output(tcp,http,arp,other)
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#分割結果をCSVファイルとして出力する
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-

	f = File.open($output_file_name,'w')
		for i in 0...$timeslot.size
			f.print tcp[i],"\t",0,"\n"
			f.print http[i],"\t",1,"\n"
			#f.print udp[i],"\t",1,"\n"
			f.print arp[i],"\t",2,"\n"
			f.print other[i],"\t",3,"\n"
			f.print "t\n"
		end
	f.close




	
=begin		
	if ARGV[5].nil? == false
		f = File.open(ARGV[5],'w')
			f.print"TCP,HTTP,ARP,OTHER\n"
			for i in 0...$timeslot.size
				f.print tcp[i],",",http[i],",",arp[i],",",other[i],"\n"
			end
		f.close
	end
=end	


#=begin 

	if ARGV[5].nil? == false
		ss = Array.new($timeslot.size){[]}
		for i in 0...$timeslot.size
			xx = [tcp[i],http[i],arp[i],other[i]]
			avg = xx.avg
			stv = xx.standard_deviation
			xx.each do |e| 
				ss[i] << (e - avg)/stv
			end
		end


		f = File.open(ARGV[5],'w')
			f.print"TCP,HTTP,ARP,OTHER\n"
			for u in 0...$timeslot.size
				for k in 0...xx.size
					if k == xx.size-1
						f.print ss[u][k],"\n"
					else 
						f.print ss[u][k],","
					end
				end
			end
		f.close
	end

end
#=end 

	
	
	





#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#Javaで言うところのmainメソッド
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-


set_time()
input()
partition()
classification()

