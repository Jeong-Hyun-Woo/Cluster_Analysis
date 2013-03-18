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
    #############ファイル入力部分###############
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
	###########################################
    
	c = Array.new(@x[0][1].max+1){[]}
 	y.each_index do |i|
		for n in 0..y[i][1].max
			a = []		#一時的に値を押し込んでおく
			for j in 0...@x[i][1].size
				if y[i][1][j] == n
					a << y[i][0][j]
				end
			end
			c[n] << a.inject(:+)

		end
	end

	##############ファイル出力部分#################
	filename = File.basename(ARGV[1])
	f =open("result/input/input_ano_#{filename}",'w')
		c[0].each_index do |i|
			for n in 0...c.size
				if n == 0 
					f.print i+1,"\t",c[n][i],"\t"
				elsif n == c.size-1
					f.print c[n][i],"\n"
				else
					f.print c[n][i],"\t"
				end
			end
		end
	f.close
	############################################
	return y
end


def dev(s_j_i_avg,s_j_i_sta,c_k)

    y = []
	y2 = []
    y = ano
    print "---------------------異常データ-----------------------------------\n",y,"\n---------------------------------------------------------------\n"
    y2 = y
	s_t_i = 	s_j_i = Array.new(y.size){Array.new(y[0][1].size){[]}}
	sigma_s =[]
	front_dev = []
	front_dev2 = []
	dev = []
	cal_s(y)
    print "Y = \n"
	for i in 0...y.size
	if i %5 ==0
	print "\n"
	end
	print y[i][0],"\n"
	end
#=begin
    ##############ファイル出力部分#################
	filename = File.basename(ARGV[1])
    for i in 0...y.size
	f =open("result/anomaly_values/ano_#{i}_#{filename}",'w')
        for n in 0...y[i][0].size
            f.print n,"\t",n+0.5,"\t",y[i][0][n],"\n"
        end
	f.close
    end
	############################################
#=end
	for tim in 0...y.size
		for p in 0...y[tim][1].size
			for n in 0...y[tim][0].size
				if y[tim][1][n] == p
					s_j_i[tim][p] = y[tim][0][n]
				end
			end
		end
	end

	
	for tim in 0...y.size			#タイムスロットでループ
	#print "timeslot = ",tim,"=========================================\n"
		for j in 0...c_k			#クラスタでループ			
		#print "j = ",j,"\n"
			for i in 0...y[0][1].size		#プロトコルでループ
			#p s_j_i_sta[j][i]
			
			#################テスト#########################################
			#if   s_j_i_sta[j][i] == 0
			#print "aaa\n"
			#	 xx = (s_t_i[tim][i] - s_j_i_avg[j][i]) / 1				
			#else
			#print "bbb\n"
				 xx = (s_t_i[tim][i] - s_j_i_avg[j][i]) / s_j_i_sta[j][i]
			#end
			###############################################################
				 sigma_s << xx**(2)
				#print s_t_i[tim][i]," - ",s_j_i_avg[j][i]," = ",s_t_i[tim][i]-s_j_i_avg[j][i],"\n"
			end
			#p sigma_s							######確認用######
			front_dev << Math::sqrt(sigma_s.inject(:+))
			sigma_s = []
		end

		
		#print "\n\nfront_dev\n"					######確認用######
		#print "\n",front_dev,"\n\n"				######確認用######		
		dev << front_dev.min
		front_dev2 << front_dev
		front_dev = []
	end		
		print "\ndev = ",dev,"\n"			######確認用######
				
											
	##############################ファイル出力部################################
	filename = File.basename(ARGV[1])
	f =open("result/dev/dev_#{filename}",'w')
		dev.each_index do |i|
			f.print i+1,"\t",dev[i],"\n"
		end
	f.close
	##########################################################################
    return y2,y,dev,front_dev2
end