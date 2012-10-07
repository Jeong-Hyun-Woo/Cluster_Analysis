# -*-coding: utf-8 -*-

require File.expand_path("../input_data",__FILE__)
require File.expand_path("../calcurate_s",__FILE__)
require File.expand_path("../calcurate_v",__FILE__)
require File.expand_path("../support",__FILE__)
require File.expand_path("../deviate",__FILE__)

@x = []			#通常データ
s = []
k = []			#通常データから求めたクラスタ数
s_avg = []		#通常データから求めたSijの平均
a_sta = []		#通常データから求めたSijの標準偏差

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
	f =open("input_data_#{filename}",'w')
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


=begin
#################################################
	ここからmainメソッドみたいな感じ
	各ファイルのメソッドの呼び出し
#################################################
=end
inp_nom
print "---------------------通常データ-----------------------------------\n"
p @x
print "----------------------------------------------------------------\n"
cal_s(@x)
print "---------------------通常データ(標準化)-----------------------------------\n"
p @x
print "----------------------------------------------------------------\n"

s,k = cal_r(@x)
s_avg,a_sta = cal_nom(s,k)
print "s_avg = ",s_avg,"\n"
print "s_sta = ",a_sta,"\n"
dev(s_avg,a_sta,k)
out_put
