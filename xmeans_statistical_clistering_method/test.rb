# -*- coding: utf-8 -*-

require "rsruby"
require File.expand_path("../array",__FILE__)

=begin
 #################################################
 x-means方を用いた場合にどうなるかのテスト用
 #################################################
=end


@x = []		#元の入力データ(ただし、正規化している)
@s =[]		#逸脱度の処理の方に値を渡すための変数
@k =1		#クラスタ数管理をする変数

def test
    km =[]		#クラスタリングした結果を入れる配列
    #¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    #R言語の処理xとは別にmatrix型のデータを読み込んでクラスタリングし，その値をkmに返す

    filename = ARGV[0]
    rr = RSRuby::instance   #R言語使用に必要
    
    
    km = rr.eval_R(<<-RCOMMAND)
    a <- read.csv("#{filename}")
    source('./xmeans.R')
    xmeans(a,2,20)
    RCOMMAND
    #¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬¬
    print "クラスタサイズ = ",km["size"].size,"\n"
    print "CLUSTER = \n",km["cluster"],"\n"
    print "CENTER = \n",km["centers"],"\n"
    print "SIZE = \n",km["size"],"\n"
end
test