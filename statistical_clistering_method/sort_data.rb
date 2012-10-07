# -*-coding: utf-8 -*-


require "time"
Time_interval = ARGV[2].to_i
@timeslot = []               #timeslot_pを格納して２次元配列にする
@num_pp = []				#面倒なので説明パス．プロトコルの数かなんか
@count_p = []				#タイムスロットにプロトコルがいくつあるのか数えたものを入れておく
@protocol = []       #plotocol_3を入れる配列



=begin
########################################
↓タイムスロットに切り分けるメソッド
########################################
=end


def time_slice
    
    time = []           #時間入れる配列(分まで)
    second = []         #時間入れる配列(マイクロ秒まで)
	#protocol = []       #plotocol_3を入れる配列

    
    f = File::open(ARGV[0],'r')
    f.each do | line|
        x = []          #一列の各要素を入れておく配列
        next if line.index('/')
        x = line.split(/,/)
        time << Time.parse(x[1])
        second << x[2]
        @protocol << x[5]
    end
    f.close



=begin    
    num_p = 0
    protocol.each_with_index do |pro,p|
        if pro.is_a?(String)
            pc = pro
            for p2 in 0...protocol.size
                if protocol[p2] == pc
                    protocol[p2] = num_p.to_i
                end
            end
            num_p+=1
        end
    end
    @num_pp = num_p
=end
#↓tcp,udp,otherのみバージョン#################

    
    num_p = 0
    for p in 0...@protocol.size
        if @protocol[p] =='tcp'
			@protocol[p] = 0.to_i
		elsif @protocol[p] == 'udp'
			@protocol[p] = 1.to_i
		else
			@protocol[p] = 2.to_i
        end
    end
    @num_pp = 3
##########################################
	#p @protocol

    

    timeslot_p = []             #時間のデータはもういらないがプロトコルの情報は必要なので残しておく
    basetime = time[0]          #一つのタイムスロットの基準となる時間を格納?
    basesecond = second[0]      #↑の小数点以下マイクロ秒まで版
    i_num = 0           #次にな番目の入れるから数えるべきか覚えておくため
    #s = 0;              #basetimeに関する条件分岐に使用。最初のみ「0」が入る
	


=begin
DBの方で時間を区切って持ってくるので↓は今のところ不要
=end
=begin
    protocol.each_with_index do |p3,i|
        if time[i] < basetime + Time_interval
            timeslot_p << p3
        else
            if second[i] < basesecond
                timeslot_p << p3
            else
                @timeslot << timeslot_p
				timeslot_p = []            #timeslotの方に移したので初期化
                basetime = time[i]          #次のbasetimeを代入
                basesecond = second[i]      #次のbasesecondを代入
                timeslot_p << p3

            end
        end
    end


    p @timeslot
    @timeslot.each do |u|
        p u.size		
    end
=end
end


=begin
########################################
↓文字通りプロトコルの仕分け
########################################
=end


def protocol_classification
=begin    
	for p in 0...@timeslot.size
		count = Array.new(@num_pp){0}
		for i in 0...@num_pp
			for n in 0...@timeslot[p].size
				if @timeslot[p][n] == i
						count[i]+=1
				end
			 end
		end
		@count_p << count 
    end
	p @count_p
=end
###################↓↑の代わり###################
	count = Array.new(@num_pp){0}
	for i in 0...@num_pp
		for n in 0...@protocol.size
			if @protocol[n] == i
					count[i]+=1
			end
		end
	end
	@count_p << count 
	p @count_p

end





=begin
########################################
mainっぽい部分↓
########################################
=end


if ARGV[0].nil?&&ARGV[0].nil?
    p "ERROR：入力ファイル名を入力してください。"
    exit
end
if ARGV[1].nil?&&ARGV[1].nil?
    p "ERROR：入力ファイル名を入力してください。"
    exit
end
#=begin
if ARGV[2].nil?&&ARGV[2].nil?
    p "ERROR：入力ファイル名を入力してください。"
    exit
end
#=end
time_slice
protocol_classification


filename = File.basename(ARGV[1])
f = File.open("#{filename}",'w')
    for i in 0...@count_p.size
        for j in 0 ...@count_p[i].size
            f.print @count_p[i][j],"\t",j,"\n"
        end
        f.puts "t\n"
    end
f.close

un = 0
filename = File.basename(ARGV[2])
f = File.open("#{filename}",'w')

    f.print　"p1\tp2\tp3\n"



    for i in 0...@count_p.size
        for j in 0 ...@count_p[i].size
			if un == 3
				f.print "\n"
				un = 1
			else
				f.print @count_p[i][j],"\t"
			end
			un += 0
        end
        f.puts "\n"
    end
f.close