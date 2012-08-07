# -*-coding: utf-8 -*-
require File.expand_path("../array",__FILE__)

=begin
#################################################
	データを正規化するためのメソッド
#################################################
=end

@x = []

def cal_s(x)
    
    
    p=[]     #protocolを一時的に格納
    tim = 0      #タイムスタンプを管理
    @x = x
    
    loop do 
        for n in 0...@x[tim][0].size
            @x[tim][0][n]  = (@x[tim][0][n] - @x[tim][0].avg)/@x[tim][0].standard_deviation
        end
        if tim == @x.size-1 then
            break
        end
        tim +=1
    end
end