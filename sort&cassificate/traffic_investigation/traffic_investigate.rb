 # -*-coding: utf-8 -*-
require File.expand_path("../array",__FILE__)
require File.expand_path("../calcurate_s",__FILE__)


#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#textデータのタイムスロット毎の平均，標準偏差を求め出力
#正規化しての平均，標準偏差も出力
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-

$x = []
s_x =[]



def in_put()
	in_v =[]	#value
	in_n =[]	#number
	in_p =[]	#protocol


	if ARGV[0].nil?
		p "ERROR：第一引数に【通常データ】ファイル名を入力してください。"
		exit
	end

	f = File::open(ARGV[0],'r')
	f.each do | line|
		next if line.index('/')
		if line == "t\n"
			$x << [in_v,in_n,in_p]
			in_v=[]
			in_n=[]
			in_p=[]
		end
		if line.include?("\t")==true
			in_v << line.to_f
			line.slice!(0,line.index("\t"))
			in_p << line.to_i
		end
	end
	f.close
end


def packet_inv
	avg = Array.new($x.size){0}
	std = Array.new($x.size){0}

	for i in 0...$x.size
		avg[i] = $x[i][0].avg
		std[i] = $x[i][0].standard_deviation
	end
	output(avg,std,0)
end 


def standardization_inv()
	s_avg = Array.new($x.size){0}
	s_std = Array.new($x.size){0}
	
	s_x = cal_s($x)

	for i in 0...s_x.size
		s_avg[i] = s_x[i][0].avg
		s_std[i] = s_x[i][0].standard_deviation
	end
	output(s_avg,s_std,1)
end


def output(a,s,n) 
	filename = File.basename(ARGV[0])

	if n == 0
	f =open("traffic_#{filename}",'w')
	elsif n ==1
	f =open("traffic_standardization_#{filename}",'w')
	end
		f.print "=======AVERAGE=======\n"
		for y in 0...a.size
			f.print a[y],"\n"
		end
		
		
		f.print "=======STANDARD_DEVIATION=======\n"
		for z in 0...s.size
			f.print s[z],"\n"
		end

	f.close



end

in_put()
packet_inv()
standardization_inv()