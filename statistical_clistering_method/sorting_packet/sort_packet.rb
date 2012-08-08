# -*-coding: utf-8 -*-

=begin
read_in_packet.rbで作ったファイルを読み込んで、タイムスロット毎に
 分け、プロトコル識別番号を振り新しいファイルを作る。
=end

@x = []
@y = []
@z = []

Packet_num =12  #一つのタイムスロットの数を管理

	if ARGV[0].nil?&&ARGV[0].nil?
		p "ERROR：入力ファイル名を入力してください。"
		exit
	end
	if ARGV[1].nil?&&ARGV[1].nil?
		p "ERROR：入力ファイル名を入力してください。"
		exit
	end
	if ARGV[2].nil?&&ARGV[2].nil?
		p "ERROR：入力ファイル名を入力してください。"
		exit
	end
	if ARGV[3].nil?&&ARGV[3].nil?
		p "ERROR：入力ファイル名を入力してください。"
		exit
	end
=begin
		if ARGV[4].nil?&&ARGV[4].nil?
		p "ERROR：入力ファイル名を入力してください。"
		exit
	end
=end

#ファイルにパケット数の羅列を書き込む
	f = File::open(ARGV[0],'r')
	f.each do | line|
		next if line.index('/')
			@x << line.to_i
	end
	f.close


	f = File::open(ARGV[1],'r')
	f.each do | line|
		next if line.index('/')
			@y << line.to_i
	end
	f.close
	

	f = File::open(ARGV[2],'r')
	f.each do | line|
		next if line.index('/')
			@z << line.to_i
	end
	f.close
	
	
	#ファイルにパケット数の羅列を書き込む
	
	filename = File.basename(ARGV[3])
	f = File.open("#{filename}",'w')
	i  = 0
	for n in 0...@x.size
		i+=1
		f.print @x[n],"\t",0,"\n"
		f.print @y[n],"\t",1,"\n"
		f.print @z[n],"\t",2,"\n"
			f.puts "t\n"

=begin
		if i == Packet_num
			i = 0
			f.puts "t\n"
		end
=end
	end
	f.close
	
	#タイムスロットごとのパケット数を書き込む
	
	x=y=z=s=0
=begin	
	
	filename = File.basename(ARGV[4])
	f = File.open("#{filename}",'w')
	i  = 0
	for n in 0...@x.size
		i+=1
		x+=@x[n]
		y+=@y[n]
		z+=@z[n]

		if i == Packet_num
			i = 0
			s+=1
			f.print s,"\t",x,"\t",y,"\t",z,"\n"
			x=y=z=0
		end
	end
	f.close
=end	
	
	