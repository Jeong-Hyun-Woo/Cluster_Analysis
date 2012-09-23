# -*-coding: utf-8 -*-

=begin
#################################################
	ファイルを読み込みデータ配列@xに押し込んでいるだけ
#################################################
=end

@x =[]

def inp_d
	if ARGV[0].nil?
		p "ERROR：入力ファイル名を入力してください。"
		exit
	end
	in_v =[]
	in_p =[] 

	f = File::open(ARGV[0],'r')
	f.each do | line|
		next if line.index('/')
		if line == "t\n"
			@x << [in_v,in_p]
			in_v=[]
			in_p=[]
		end
		if line.include?("\t")==true
			in_v << line.to_f
			line.slice!(0,line.index("\t"))
			in_p << line.to_i
		end
	end
	f.close
	#p @x
end