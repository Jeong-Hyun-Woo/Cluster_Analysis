# -*-coding: utf-8 -*-
require "time"


=begin
########################################
いろいろ未完成
菅原様DB専用
↓タイムスロットに切り分けるメソッド(中止)
自力で分けてください
########################################
=end


def time_slice
    
	timeslot = []       #timeslot_pを格納して２次元配列にする
	num_pp = []			#面倒なので説明パス．プロトコルの数かなんか
	#@count_p = []		#タイムスロットにプロトコルがいくつあるのか数えたものを入れておく
	protocol1 = []      #plotocol_3を入れる配列
	protocol2 = []      #plotocol_4を入れる配列
	protocol3 = []      #plotocol_5を入れる配列
	protocol = []
	proto = []
	no = []				#タイムスロットの切れ目の『t』を判別するための配列
    time = []           #時間入れる配列(分まで)
    second = []         #時間入れる配列(マイクロ秒まで)
	count_p = []		#タイムスロットにプロトコルがいくつあるのか数えたものを入れておく


	##############プロトコルの番号付け######################
    
    f = File::open(ARGV[0],'r')
    f.each do | line|
        x = []          #一列の各要素を入れておく配列
        next if line.index('/')
        x = line.split(/,/)
      
		if x[0] == "t"
			no << "t"
			protocol1 << "t"
			protocol2 << "t"
			protocol3 << "t"
		else
			no << 0.to_i
			protocol1 << x[4]
			protocol2 << x[5]
			protocol3 << x[6]
		end
	end
    f.close
#p protocol1
	########################

    num_p = 0
    for p in 0...protocol1.size
		#if no[p] == "t"
			#protocol << proto
			#proto = []
		#else
			if protocol1[p] =="ip"
				if protocol2[p] == "tcp"
				proto << 0.to_i
				elsif protocol2[p] == "udp"
					proto << 1.to_i
				else 
					proto << 3.to_i
				end
			elsif protocol1[p] == "arp"
				proto << 2.to_i
			elsif protocol1[p] == "t"
			protocol << proto
			proto = []
			else
				proto << 3.to_i
			end
		#end
	end
	num_pp = 4

	######################カウント##########################

	count = Array.new(num_pp){0}
	
	p protocol.size
	for t in 0...protocol.size
		for i in 0...num_pp
			for n in 0...protocol[t].size
				if protocol[t][n] == i
					count[i]+=1
				end
			end
		end
		count_front = [] #一時カウントしたものを預かる配列
		count.each do |c|
			count_front << c
		end
		count_p << count_front
		count = Array.new(num_pp){0}
	end
	p count_p


	###################ファイル出力###################
	
	filename = File.basename(ARGV[1])
	f = File.open("input_file/#{filename}",'w')
		for i in 0...count_p.size
			for j in 0 ...count_p[i].size
				f.print count_p[i][j],"\t",j,"\n"
			end
			f.puts "t\n"
		end
	f.close
            
	un = 0
	filename = File.basename(ARGV[2])
	f = File.open("r_csv_file/#{filename}",'w')
	
	##########R言語で読み込むcsvファイルに出力############
	#f.print"TCP-SYN,TCP-FIN,TCP-OTHER,UDP,TELNET,ARP,DNS,ICMP,SMNP,SMTP,FTP,FTP-DATA,SSHV1,OTHER\n"
            f.print"TCP,UDP,ARP,OTHER\n"
		for i in 0...count_p.size
			for j in 0 ...count_p[i].size
				#if un == 13
				if un == 3
					f.print count_p[i][j],"\n"
					un =0
				else
					f.print count_p[i][j],","
				end
				un += 1
			end
			un = 0
		end
	f.close
    #################################################	
end


=begin
########################################
mainっぽい部分↓
########################################
=end


if ARGV[0].nil?&&ARGV[0].nil?
    p "ERROR：入力ファイル名を入力してください。"
    exit
end
if ARGV[1].nil?&&ARGV[1].nil?
    p "ERROR：入力ファイル名を入力してください。"
    exit
end
#=begin
if ARGV[2].nil?&&ARGV[2].nil?
    p "ERROR：入力ファイル名を入力してください。"
    exit
end
#=end
time_slice