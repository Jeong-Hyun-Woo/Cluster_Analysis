# -*-coding: utf-8 -*-
require File.expand_path("../array",__FILE__)

=begin
#################################################
	逸脱度の計算をする。
	また、その結果をファイルに出力するメソッド
#################################################
=end

def dev(s,c_k)
	#print "\n\n\ns = ",s,"\n\n\n"		#確認用
	#print "\n\n\nk = ",c_k,"\n\n\n"	＃確認用

	pro = 0		#プロトコル数


	ss = []
	dev_k = []	#逸脱度を入れておく配列

	for i in 0...@x.size	
		ss << [s[0][i][0],s[0][i][1],s[1][i]]
	end
	#print "\n\n\nss = ",ss,"\n\n\n"	#確認用

	s_t_i = Array.new(ss.size){[]}
	for tim in 0...ss.size			#タイムスタンプでループ
		for i in 0..ss[tim][1].max		#プロトコル番号でループ
		pro = ss[tim][1].max
			for n in 0...ss[tim][0].size
				if ss[tim][1][n] == i
					s_t_i[tim] << ss[tim][0][n]
				end
			end
		end	
	end	
	#p s_t_i
	
	s_j_i = Array.new(c_k){Array.new(pro+1){[]}}
	s_j_i_avg = Array.new(c_k){Array.new(pro+1){[]}}
	s_j_i_sta = Array.new(c_k){Array.new(pro+1){[]}}

	for tim in 0...ss.size			#タイムスタンプでループ
		for k in 1..c_k				#クラスタ番号でループ
			for i in 0..ss[tim][1].max		#プロトコル番号でループ
				for n in 0...ss[tim][0].size
					if ss[tim][1][n] == i&&ss[tim][2][n]==k
						s_j_i[k-1][i] << ss[tim][0][n]
					end
				end
				s_j_i_avg[k-1][i] = s_j_i[k-1][i].avg
				
				
				
				#非常用試しの措置，G言語のkmeans関数を改良した方が結果に対する影響が出にくくてよい
				
				if s_j_i[k-1][i].standard_deviation == 0
				s_j_i_sta[k-1][i] = 0.000000000001
				else
				s_j_i_sta[k-1][i] = s_j_i[k-1][i].standard_deviation
				end
				#p s_j_i[k-1][i]
			end
		end
	end
	
=begin
	p s_j_i						#確認用
	print "\ns_j_i_avg\n"		#確認用 
	p s_j_i_avg					#確認用
	print "\ns_j_i_sta\n" 		#確認用
	p s_j_i_sta					#確認用
	print "\n\n"				#確認用
=end	
	sigma_s =[]
	front_dev = []
	dev = []
	for tim in 0...ss.size
		for j in 0...c_k
			for i in 0...pro+1
					sigma_s << ((s_t_i[tim][i] - s_j_i_avg[j][i])/s_j_i_sta[j][i])**2
			end
			#p sigma_s		#確認用
			front_dev << Math::sqrt(sigma_s.inject(:+))
			sigma_s = []
		end
=begin		
		print "\n\nfront_dev\n"
		p front_dev		#確認用
		print "\n\n" 
=end			
		dev << front_dev.min
		front_dev = []
	end		
		print "\n\n\ndev = ",dev,"\n"
				
											
		##############################ファイル出力部分############################################	
	filename = File.basename(ARGV[0])
	f =open("dev_#{filename}",'w')
		dev.each_index do |i|
			f.print i+1,"\t",dev[i],"\n"
		end
	f.close
	##########################################################################################

		
					
	
=begin
///////////////////////////////////前バージョン///////////////////////////////////////
	for tim in 0...ss.size			#タイムスタンプでループ
		for k in 1..c_k				#クラスタ番号でループ
			b=[]	#計算した逸脱度を一時、配列に入れる
			dev =[]
			for i in 0..ss[tim][1].max		#プロトコル番号でループ
				a=[]	#プロトコルごとに分けたものを一時、配列に入れておく
				for n in 0...ss[tim][0].size
					if ss[tim][1][n] == i&&ss[tim][2][n] == k
						a << ss[tim][0][n]		#一つのプロトコルを取り出す
					end
				end
				#print "\n\n\na = ",a,"\n\n\n"	#確認用
				if a[0] != nil
					for n in 0...a.size
						b << ((a[n] - a.avg) / a.standard_deviation)**2
					end
					#print "\n\n\nb = ",b,"\n\n\n"	#確認用
				end
			end
			if b[0] != nil
				dev << Math::sqrt(b.inject(:+))
			end
		end
		if dev[0] != nil
			dev_k << dev.min
		end	
	end
	print "\ndev = ",dev_k,"\n\n\n"	#各タイムスロットの逸脱度の出力

	
	#################################ファイル出力部分############################################	
	filename = File.basename(ARGV[0])
	f =open("dev_#{filename}",'w')
		dev_k.each_index do |i|
			f.print i+1,"\t",dev_k[i],"\n"
		end
	f.close
	##########################################################################################

=end
end