# -*-coding: utf-8 -*-

=begin
sort_packet.rbで操作しやすいファイルを作成する。
=end

@x = []

def inp_d
	if ARGV[0].nil?&&ARGV[0].nil?
		p "ERROR：入力ファイル名を入力してください。"
		exit
	end
if ARGV[1].nil?&&ARGV[1].nil?
		p "ERROR：入力ファイル名を入力してください。"
		exit
	end

	in_v =[]
	in_p =[] 

	f = File::open(ARGV[0],'r')
	f.each do | line|
		next if line.index('/')
			@x << line.to_i
			in_v=[]
	end
	f.close
	
	filename = File.basename(ARGV[1])
	f = File.open("#{filename}",'w')
	i  = 0
	a = 0
	for n in 0...@x.size
		i+=1
		a+=@x[n]
		#f.print @x[n],"¥n"#"\t",2,"\n"
		if i == 12
			f.print a,"\n"#"\t",2,"\n"
			a = 0
			i = 0
			#f.puts "u\n"
		end
	end
	f.close
end

inp_d