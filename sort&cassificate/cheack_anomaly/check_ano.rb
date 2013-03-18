# -*- coding: utf-8 -*-

require File.expand_path("../array",__FILE__)
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#
#求めた逸脱度から検定を行い異常を検知するメソッド？
#
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-

Gosa = 4		#標準偏差の何倍まで正常とするかの定義
$dev_x = []		#逸脱度を格納する配列  正常値のみ
$dev_y = []		#逸脱度を格納する配列　異常値含む


def input_dev()
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#逸脱度のファイルを読み込んでくるメソッド
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-

	if ARGV[0].nil?
		p "ERROR：第1引数に攻撃を含まない【逸脱度データ】ファイル名を入力してください。"
		exit
	end
		if ARGV[1].nil?
		p "ERROR：第2引数に攻撃を含む【逸脱度データ】ファイル名を入力してください。"
		exit
	end


	#正常データの逸脱度を読み込む
	f = File::open(ARGV[0],'r')
		f.each do | line|
			next if line.index('/n')
			x = line.split(/\t/)
			$dev_x << x[1].to_f
		end
	f.close
	
		
	
	#異常を含むデータの逸脱度を読み込む
	f2 = File::open(ARGV[1],'r')
	f2.each do | line|
		next if line.index('/n')
		y = line.split(/\t/)
		$dev_y << y[1].to_f
	end
	f2.close
	
	
	$dev_x.each do |a|
		p a
	end
	
	print "-------------------------------\n" 
	
	$dev_y.each do |b|
		p b
	end

end




def check()
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#異常があるかのチェックを行うメソッド
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
	avg_c = 0				#その名の通り平均
	sta_c = 0				#その名の通り標準偏差
	check_value_max = 0		#異常判定を行うときの正常の上限
	check_value_min = 0		#異常判定を行うときの正常の下限
	anomaly_value = []
	normally_value = []
	r_dev = []
	
	avg_c = $dev_x.avg
	sta_c = $dev_x.standard_deviation
	
	check_value_max = avg_c + (sta_c * Gosa)
#=begin
	check_value_min = avg_c - (sta_c * Gosa)
	check_value_min = 0

	if check_value_min < 0
		check_value_min = 0
	end 
	
	print "正常範囲 => ",check_value_min," ≤ x ≤ ",check_value_max,"\n"
#=end

	#print "正常範囲 : x ≤ ",check_value_max,"\n"

	$dev_y.each_with_index do |d,i|
		#r_dev << (d - avg_c) / sta_c
		r_dev << d
		
		if r_dev[i] <= check_value_min || r_dev[i] >= check_value_max
			normally_value << [i,nil]
			anomaly_value << [i,r_dev[i]]
			print "異常	タイムスロット[",i+1,"] = ",r_dev[i],"\n"
		else 
			normally_value << [i,r_dev[i]]
			anomaly_value << [i,nil]
		end
	end
	#p r_dev	確認用
	dev_output(anomaly_value,normally_value,check_value_max)
	
end



def dev_output(anomaly_value,normally_value,check_value_max)
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#結果をテキスト形式かCSV形式で出力したい
#できれば，正常と異常を色分けできるようにしておきたい
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
	 
	if ARGV[2].nil?
		p "ERROR：第3引数に出力ファイル名を入力してください。"
		exit
	end


	filename = File.basename(ARGV[2])
	
	
	f =open("#{filename}",'w')
	f.print "\#normally\n"
	normally_value.each_index do |n|
		f.print normally_value[n][0]+1,"\t",normally_value[n][1],"\n"
	end
	f.print "\n\n\#anomaly\n"
	anomaly_value.each_index do |a|
		f.print anomaly_value[a][0]+1,"\t",anomaly_value[a][1],"\n"
	end
	


	f.print "\n\n\#threshold\n"
	f.print check_value_max,"\n"
	f.close



end



#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-
#メインメソッド的なもの
#☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-☆=-


input_dev()
check()