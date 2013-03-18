# -*-coding: utf-8 -*-
require File.expand_path("../array",__FILE__)
require "time"

#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#タイムスロット分割シリーズついに最終章！！
#時間も設定すれば振り分けてくれる！ファイルの中で多いプロトコル
#上位【Top】位までをカウント残りはその他でカウントしてくれる！！
#順番はABC順となるはず！！
#但し，処理がちょー重い
#wiresharkから出力したCSVファイル専用
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-


Top = 4					#このファイルのプロトコル上位何個を用いるかを定義


$start_time					#開始時間を指定し格納する
$interval_time				#指定するタイムスロットの間隔を格納する
$timeslot_num				#指定するタイムスロット数を格納する

$protocol1 = []				#プロトコルを格納する
$time = []					#秒までの時間をtimeで格納する
$micro_second = []			#マイクロ秒をint型で格納する
$timeslot = []				#分割時にハッシュを格納する

$input_file_name			#入力ファイル名を格納
$output_file_name			#出力ファイル名を格納

$use_p = []						#今回用いるプロトコルを格納
$other_p = []					#今回用いないプロトコルを格納
$timeslot_p = []


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
	#if ARGV[5].nil?&&ARGV[5].nil?
	#	p "ERROR：OutputFile名(CSV)を入力してください。"
	#	exit
	#end
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
	protocol = Hash.new(0)		#全体のプロトコルのパケット数をカウントするため

    
    #f = File::open(ARGV[0],'r')
    f = File::open($input_file_name,'r')
    f.each do | line|
        x = []          #一列の各要素を入れておく配列
        next if line.index('/n')
        x = line.split(/,/)
		
		if line_c != 0
			$time << Time.parse(x[1].to_s)
			#$micro_second << x[2].to_i
			$protocol1 << x[2].delete("\"")
		elsif line_c == 0
			line_c = 1
		end
		
    end
    f.close
	
	
	
	$protocol1.each do |p|
		if p == "FTP-DATA"
			protocol["FTP"] += 1
		else
			protocol[p] += 1
		end
	end
	
	protocol2 = protocol.sort_by{|key,val| -val}
	#p protocol2
	
	top  = Top
	for p2 in 0...protocol2.size
		if p2 < top
			if protocol2[p2][0] != "TCP"
				$use_p <<  protocol2[p2][0]
				else
				top += 1
			end
		else
			$other_p << protocol2[p2][0]
		end
	end 
	$use_p = $use_p.sort
	p $use_p
	#p $other_p
	#p $protocol
end





def partition()
    
    #☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
    #時間を区切る
    #☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
    
	time = []					#必要ではないが確認の際に用いる
	protocol1 = []				#(注)グローバルではない
	ts_count = 1				#タイムスロット数をカウントする変数
    

	check_time = $start_time
	for i in 0...$time.size
		if ts_count > $timeslot_num
			break
		end
		if i == $time.size-1
			time << $time[i]
			protocol1 << $protocol1[i]

			hash ={"time"=>time, "p1"=>protocol1}
			$timeslot << hash
			check_time += $interval_time
			ts_count += 1
		
		elsif $time[i] < check_time+$interval_time
			time << $time[i]
			protocol1 << $protocol1[i]
        else
			hash ={"time"=>time, "p1"=>protocol1}
			$timeslot << hash
			check_time += $interval_time
			ts_count += 1
			#初期化
			hash = Hash.new
			time = []
			protocol1 = []
        end
	end
	
=begin
     ####分割できているかの確認用####
     for j in 0...timeslot.size
     p timeslot[j]
     print "--------------------------\n"
     end
=end
end





def classification()
    #☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
    #時間で分割したものをプロトコル種別にカウントする
    #☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
	c = 1			#プロトコルの重複を防ぐためのセマフォ的なもの
	prot = Hash.new(0)

	for l in 0...$timeslot.size
		####これがないとなぜかprotの内容が配列に全部渡されないので足しておく####
		$use_p.each do |usep|
			prot[usep]= 0
		end
		
		$timeslot[l]["p1"].each do |p1|
			$use_p.each do |p2|
				#print p1,"\t",p2,"\n" ####
				if p1 == p2
					prot[p2] += 1
					c = 0
				end
				if prot[p2] == nil
					prot[p2] = 0
				end
			end
			if c == 1
				prot["OTHER"] += 1
			end
			c = 1
		end
		
		$timeslot_p << prot.sort_by{|key,val|key}
		prot = Hash.new(0)
	end
    	#p $timeslot_p

	#print "カウントしちゃった！てへぺろ(・ω＜)\n"
	
	
	
	
	output()
end





def output()
    #☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
    #分割結果をCSVファイルとして出力する
    #☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
    
	f = File.open($output_file_name,'w')
		$timeslot_p.each do |tim|
			tim.each_with_index do |p,n|
				f.print p[1],"\t",n,"\t",p[0],"\n"
			end
			f.print "t\n"
		end
	f.close

	



	if ARGV[5].nil? == false
			ss = Array.new($timeslot_p.size){[]}
			p_name = Array.new($timeslot_p[0].size){0}
			$timeslot_p.each_with_index do |tim2,num|
				xx = Array.new(tim2.size){0}
				for i in 0...tim2.size
					xx[i] = tim2[i][1]
					p_name[i] = tim2[i][0]
				end
			
				avg = xx.avg
				stv = xx.standard_deviation

				xx.each do |e| 
					ss[num] << (e - avg)/stv
				end
			end

	ss.each do |qq|
	#p qq
	end

		f = File.open(ARGV[5],'w')
			for w in 0...p_name.size
				if w== p_name.size-1
					f.print p_name[w],"\n"
				else
					f.print p_name[w],","
				end
			end
			
			
			
			for u in 0...$timeslot_p.size
				for k in 0...p_name.size
					if k == p_name.size-1
						f.print ss[u][k],"\n"
					else 
						f.print ss[u][k],","
					end
				end
			end
		f.close
	end
end


#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#Javaで言うところのmainメソッド
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-


set_time()
input()
partition()
classification()
