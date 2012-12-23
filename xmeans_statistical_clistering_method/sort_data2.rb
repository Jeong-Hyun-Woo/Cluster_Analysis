 # -*-coding: utf-8 -*-


require "time"
#Time_interval = ARGV[2].to_i
@timeslot = []               #timeslot_pを格納して２次元配列にする
@num_pp = []				#面倒なので説明パス．プロトコルの数かなんか


=begin
########################################
↓wiresharkから生成したCSVファイルを逸脱度計算しやすいように
ソートしたもの
########################################
=end


def time_slice
    
    time = []           #時間入れる配列(分まで)
    second = []         #時間入れる配列(マイクロ秒まで)
	protocol = []       #plotocol_3を入れる配列

    
    f = File::open(ARGV[0],'r')
		f.each do | line|
			x = []          #一列の各要素を入れておく配列
			next if line.index('/n')
				x = line.split(/,/)
			if x[0] == "t"
				protocol << "t"
			#end

=begin
			if x[2] == 'TCP'
				if x[8].to_s.include?("SYN") == true
					protocol << 'TCP-SYN'
				elsif x[8].to_s.include?("FIN") == true
					protocol << 'TCP-FIN'
				else
					protocol << 'TCP-OTHER'
				end
=end
			else
				protocol << x[2].to_s
			end
		end
    f.close
	#p protocol			###############確認用################

	timslot =[]
	ts =  []
	t = 0

	a=0
	for i in 0...protocol.size
		case protocol[i]
		when "TCP"
			timslot << 0.to_i
		when "HTTP"
		if i == 15 || i == 16
		print "うぉぉぉっぉぉっぉぉぉ\n"
		end
			timslot << 1.to_i
		when "t"
		#print a,"スロット\n"
		a += 1
			ts<<timslot
			timslot =[]
		when "ARP"
			timslot << 2.to_i	
		else
			timslot << 3.to_i
		end
	end
	@num_pp = 4
#=end
=begin
		case protocol[i]
		when 'TCP-SYN'
			timslot << 0.to_i
		when 'TCP-FIN'
			timslot << 1.to_i
		when 'TCP-OTHER'
			timslot << 2.to_i
		when 'UDP'
			timslot << 3.to_i
		when 'TELNET'
			timslot << 4.to_i
		when 'ARP'
			timslot << 5.to_i
		when 'DNS'
			timslot << 6.to_i
		when 'ICMP'
			timslot << 7.to_i
		when 'SMNP'
			timslot << 8.to_i
		when 'SMTP'
			timslot << 9.to_i
		when 'FTP'
			timslot << 10.to_i
		when 'FTP-DATA'
			timslot << 11.to_i
		when 'SSHV1'
			timslot << 12.to_i
		when 't'
			ts<<timslot
			timslot =[]
		else
			timslot<<13.to_i
		end
	end
	@num_pp = 14
=end
        
	###################カウント####################
	count_p = []				#タイムスロットにプロトコルがいくつあるのか数えたものを入れておく
	count = Array.new(@num_pp){0}
		
	
	for t in 0...30 #タイムスロット数分まわす
		for i in 0...@num_pp
			for n in 0...ts[t].size
				if ts[t][n] == i
					count[i]+=1
				end
			end
		end
		count_front = [] #一時カウントしたものを預かる配列
		count.each do |c|
			count_front << c
		end
		count_p << count_front
		count = Array.new(@num_pp){0}
	end
	p count_p


#=begin
            
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
            f.print"TCP,HTTP,ARP,OTHER\n"
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
#=end
end




if ARGV[0].nil?&&ARGV[0].nil?
    p "ERROR：InputFileを入力してください。"
    exit
end
if ARGV[1].nil?&&ARGV[1].nil?
    p "ERROR：OutputFileを入力してください。"
    exit
end
#=begin
if ARGV[2].nil?&&ARGV[2].nil?
    p "ERROR：OutputFile(R)を入力してください。"
    exit
end
#=end
time_slice



