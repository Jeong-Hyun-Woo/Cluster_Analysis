# -*-coding: utf-8 -*-

=begin
#################################################
	平均、分散、標準偏差の計算メソッド
#################################################
=end
public

def avg
    inject(0.0){|r,i| r+=i.to_f }/size
end

def variance
    a = avg
    inject(0.0){|r,i| r+=(i.to_f-a)**2 }/size
end

def standard_deviation
    Math.sqrt(variance)
end