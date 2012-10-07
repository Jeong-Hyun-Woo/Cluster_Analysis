# -*-coding: utf-8 -*-
require File.expand_path("../array",__FILE__)
require File.expand_path("../calcurate_s",__FILE__)
require File.expand_path("../input_data",__FILE__)


=begin
#################################################
	逸脱度の計算をする。
	また、その結果をファイルに出力するメソッド
#################################################
=end
#@y = []		#異常データ格納に使う


#~~~~~~~~~~~~~~~~~~~~~~~~~~~異常データの入力~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#なんかうまく代入できなかったのでここで！
def ano
    y = []
	in_v =[]
	in_p =[]
    
    if ARGV[1].nil?
		p "ERROR：第二引数に【異常データ】ファイル名を入力してください。"
		exit
    end
	f = File::open(ARGV[1],'r')
	f.each do | line|
        next if line.index('/')
		if line == "t\n"
			#@y << [in_v,in_p]
			y << [in_v,in_p]
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
    return y
end


def dev(s_j_i_avg,s_j_i_sta,c_k)

    y = []
    y = ano
    print "---------------------異常データ-----------------------------------\n",y,"\n---------------------------------------------------------------\n"
	s_t_i = 	s_j_i = Array.new(y.size){Array.new(y[0][1].size){[]}}
	sigma_s =[]
	front_dev = []
	dev = []
	cal_s(y)
	
	for tim in 0...y.size
		for p in 0...y[tim][1].size
			for n in 0...y[tim][0].size
				if y[tim][1][n] == p
					s_j_i[tim][p] = y[tim][0][n]
				end
			end
		end
	end

	
	for tim in 0...@y.size			#タイムスロットでループ
	#print "timeslot = ",tim,"=========================================\n"
		for j in 0...c_k			#クラスタでループ			
		#print "j = ",j,"\n"
			for i in 0...@y[0][1].size		#プロトコルでループ
			#p s_j_i_sta[j][i]
				 xx = (s_t_i[tim][i] - s_j_i_avg[j][i]) / s_j_i_sta[j][i]
				 sigma_s << xx**(2)
				#print s_t_i[tim][i]," - ",s_j_i_avg[j][i]," = ",s_t_i[tim][i]-s_j_i_avg[j][i],"\n"
			end
			#p sigma_s							######確認用######
			front_dev << Math::sqrt(sigma_s.inject(:+))
			sigma_s = []
		end

=begin		
		print "\n\nfront_dev\n"					######確認用######
		print "\n",front_dev,"\n\n"				######確認用######
=end			
		dev << front_dev.min
		front_dev = []
	end		
		print "\n\n\ndev = ",dev,"\n"			######確認用######
				
											
	##############################ファイル出力部############################################	
	filename = File.basename(ARGV[0])
	f =open("dev_#{filename}",'w')
		dev.each_index do |i|
			f.print i+1,"\t",dev[i],"\n"
		end
	f.close
	##########################################################################################
end