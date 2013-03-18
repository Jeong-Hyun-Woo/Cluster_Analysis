# -*-coding: utf-8 -*-

require File.expand_path("../input_data",__FILE__)
require File.expand_path("../calcurate_s",__FILE__)
require File.expand_path("../calcurate_v",__FILE__)
require File.expand_path("../support",__FILE__)
require File.expand_path("../deviate",__FILE__)

@x = []			#通常データ
x_front = []
x_after = []
x_ano_front = []
x_ano_after = []
dev = []
front_dev = []
s = []
k = []			#通常データから求めたクラスタ数
s_avg = []		#通常データから求めたSijの平均
a_sta = []		#通常データから求めたSijの標準偏差
km = []

=begin	
################################################
↓ファイル出力の処理
	ここのファイル出力はタイムスロットのパケット数の
	出力をしていると思う。
################################################
=end
def out_put
	
	c = Array.new(@x[0][1].max+1){[]}
	@x.each_index do |i|
		for n in 0..@x[i][1].max
		a = []		#一時的に値を押し込んでおく
			for j in 0...@x[i][1].size

				if @x[i][1][j] == n
					a << @x[i][0][j]
				end
			end
			c[n] << a.inject(:+)

		end
	end

	##############ファイル出力部分#################
	filename = File.basename(ARGV[0])
	f =open("result/input/input_data_#{filename}",'w')
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
end





def result_output(x_front,x_after,k,s_avg,a_sta,x_ano_front,x_ano_after,dev,front_dev,km)
    filename = File.basename(ARGV[1])
	f =open("result/result_#{filename}",'w')

    f.print "##########################通常データ(標準化)##########################\n"
    x_after.each_with_index do |xa,b|
        f.print xa[0],"\n"
        if (b+1)%5==0
            f.print "\n"
        end
    end
    f.print "##########################クラスタ数##########################\n"
    f.print k,"\n"
    f.print "##########################クラスタ数",k,"個の時の平均##########################\n"
    s_avg.each_with_index do |a,l|
        f.print "cl[",l+1,"] = ",a,"\n"
    end
    f.print "##########################クラスタ数",k,"個の時の標準偏##########################\n"
    a_sta.each_with_index do |s,m|
		f.print "cl[",m+1,"] = ",s,"\n"
	end
        f.print "##########################クラスタリング結果##########################\n"
			f.print "km[\"cluster\"] = \n",km["cluster"],"\n"
			f.print "km[\"centers\"] = \n"
			km["centers"].each do |xx|
				f.print xx,"\n"
			end
			f.print "km[\"size\"] = \n",km["size"],"\n"


        f.print "##########################異常データ(標準化)##########################\n"
		x_ano_after.each_with_index do |xaa,t|
			f.print xaa[0],"\n"
			if (t+1)%5==0
				f.print "\n"
			end
		end
        f.print "##########################逸脱度##########################\n"
        dev.each_with_index do | d,i|
			f.print d
			if (i+1)%5 ==0
				f.print "\n"
			end
			f.print "\n"
		end
		f.print "##############################################################\n"
		front_dev.each_with_index do |fd,j|
			f.print "タイムスロット",j," = ",fd,"\n"
		end
	f.close
end

=begin
#################################################
	ここからmainメソッドみたいな感じ
	各ファイルのメソッドの呼び出し
#################################################
=end
@x = inp_nom
print "---------------------通常データ-----------------------------------\n"
for i in 0...@x.size
	p @x[i][0]
end
x_front = @x
print "----------------------------------------------------------------\n"
out_put
cal_s(@x)
print "---------------------通常データ(標準化)-----------------------------------\n"
for i in 0...@x.size
	p @x[i][0]
    x_after << @x[i][0]
end
x_after = @x
print "----------------------------------------------------------------\n"
s,k,km = cal_r(@x)
#p s
s_avg,a_sta = cal_nom(s,k)
#print "s_avg = ",s_avg,"\n"
#print "s_sta = ",a_sta,"\n"
x_ano_front,x_ano_after,dev,front_dev = dev(s_avg,a_sta,k)
result_output(x_front,x_after,k,s_avg,a_sta,x_ano_front,x_ano_after,dev,front_dev,km)
