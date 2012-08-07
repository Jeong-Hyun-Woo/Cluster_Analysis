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


	ss = []
	dev_k = []	#逸脱度を入れておく配列

	for i in 0...@x.size	
		ss << [s[0][i][0],s[0][i][1],s[1][i]]
	end
	#print "\n\n\nss = ",ss,"\n\n\n"	#確認用

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

end