# -*-coding: utf-8 -*-
require File.expand_path("../array",__FILE__)

=begin	
################################################
通常状態のデータからSijの平均と分散を計算して返す
################################################
=end


def cal_nom(s,c_k)
	#print "\n\n\ns = ",s,"\n\n\n"		######確認用######
	#print "\n\n\nk = ",c_k,"\n\n\n"	######確認用######
	pro = 0		#プロトコル数
	ss = []		#並ぶ変えに使う配列
	dev_k = []	#逸脱度を入れておく配列

	for i in 0...@x.size	
		ss << [s[0][i][0],s[0][i][1],s[1][i]]
	end
	#print "\n\n\nss = ",ss,"\n\n\n"	######確認用######

	s_t_i = Array.new(ss.size){[]}
	for tim in 0...ss.size				#タイムスタンプでループ
		for i in 0..ss[tim][1].max		#プロトコル番号でループ
		pro = ss[tim][1].max
			for n in 0...ss[tim][0].size
				if ss[tim][1][n] == i
					s_t_i[tim] << ss[tim][0][n]
				end
			end
		end	
	end	
	#p s_t_i							######確認用######
	
	s_j_i = Array.new(c_k){Array.new(pro+1){[]}}
	s_j_i_avg = Array.new(c_k){Array.new(pro+1){[]}}
	s_j_i_sta = Array.new(c_k){Array.new(pro+1){[]}}

	
	for k in 1..c_k				#クラスタ番号でループ
		for i in 0..pro			#プロトコル番号でループ
			for tim in 0...ss.size			#タイムスタンプでループ
				for n in 0...ss[tim][0].size
					if ss[tim][1][n] == i&&ss[tim][2][n]==k
						s_j_i[k-1][i] << ss[tim][0][n]
					end
				end
			end
		
			s_j_i_avg[k-1][i] = s_j_i[k-1][i].avg
			
			#if s_j_i[k-1][i].standard_deviation == 0
			#s_j_i_sta[k-1][i] = 1
			#else
			s_j_i_sta[k-1][i] = s_j_i[k-1][i].standard_deviation
			#end
			 
		end
	end
	print "標準偏差\n"
	for u in 0...s_j_i_sta.size
		p s_j_i_sta[u]
	end
	print "\n平均\n"
	#for s in 0...s_j_i_sta
		p s_j_i_avg
	#end
	print "\n\n"
	
	##################棒グラフに出力するためのファイル出力##############
	
	
#=begin
	filename = File.basename(ARGV[1])
		for i in 0...s_j_i_sta.size
		
		f = File.open("result/cluster/cluster_#{i}_#{filename}",'w')
			for j in 0 ...s_j_i_sta[i].size
				if i%2 ==0
					j2 = j
				else
					j2 = j+0.5
				end
				f.print j2,"\t",s_j_i_avg[i][j],"\t",s_j_i_sta[i][j],"\n"
			end
		f.close



		end
#=end
	
	
	
	
	
	
	
	
	#############################################################
	
	return s_j_i_avg,s_j_i_sta
end
	