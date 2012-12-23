# -*- coding: utf-8 -*-

require "rsruby"
require File.expand_path("../array",__FILE__)

=begin
#################################################
	x-means法によりクラスタリングを行い結果を返す
#################################################
=end


def cal_r(x)
    km =[]		#クラスタリングした結果を入れる配列
    s =[]		#逸脱度の処理の方に値を渡すための変数
    k =1		#x-meansにより得られたクラスタ数を代入する
    kc = []     #kmcを規定の形に合わせるために要した配列
    kmc = []    #クラスタ番号が小数点表記になるので整数に直して格納したもの
    #¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    #R言語の処理xとは別にmatrix型のデータを読み込んでクラスタリングし，その値をkmに返す
    if ARGV[2].nil?
        p "ERROR：第三引数に【通常データ】ファイル名を入力してください。"
        exit
    end
    
    filename = ARGV[2]
    rr = RSRuby::instance   #R言語使用に必要
    km = rr.eval_R(<<-RCOMMAND)
        a <- read.csv("#{filename}")
        source('./xmeans.R')
        xmeans(a,2,20)
    RCOMMAND
    #¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
                    
    k = km["size"].size
    print "クラスタ数 = ",k,"個\n"
    for i in 0...km["cluster"].size
        kc = []
        for i2 in 0...x[0][0].size
            kc << km["cluster"][i].to_i
        end
        kmc << kc
    end
    #p kc
    p kmc
    s = [x,kmc]
	return s,k
end