# coding: utf-8

#[1]
class Time
	def initialize(h,m,s)
		@hour = h
		@minute = m
		@second = s
	end
	def to_string
		return @hour.to_s + '時間 ' + @minute.to_s + "分" + @second.to_s + "秒"
		return @hour.to_s + 'h ' + @minute.to_s + "m " + @second.to_s + "s"
	end
	def to_s() return to_string end
	def advance(n) #問1
		@second += n%60
		if(@second > 59) then
			@minute+=1
			@second-=60
		end
		@minute += n/60%60
		if(@minute > 59) then
			@hour+=1
			@minute-=60
		end
		@hour += n/3600
	end
	def back(n) #問2
		x=n%60
		if(@second - x < 0) then
			@minute-=1
			@second+=60
		end
		@second-=x
		x=n/60%60
		if(@minute - x < 0) then
			@hour-=1
			@minute+=60
		end
		@minute-=x
		@hour-=n/3600
	end
end

#[2]
#問1
def linear(a,v)
	a.length.times{|i|
		if(a[i] == v) then return i end
	}
	return nil
end
#a[a.length]を参照しないように注意。

#問2
#irbでいろいろ試行錯誤してみる^^;
def binary(a,v)
	x=a
	while true do
		n=x.length/2
		if(x[n]==v) then return n end
		if(x.length==1) then return nil end
		if(x[n]<v) then #右側
			x=x[n+1,x.length] #x[x.length]は入らないらしい
		else #左側
			x=x[0,n]
		end
	end
end

#Rubyの機能を使わないならこっち
def binary(a,v)
	len=a.length
	index=0
	while true do
		n=len/2 + index
		if a[n]==v then return n end
		if len==1 then return nil end
		if a[n]<v then #右側
			len=index+len-n-1
			if len==0 then return nil end #len==2で右側に入る場合は配列中に存在し得ない
			index=n+1
		else #左側
			len=len/2 # =n-index
		end
	end
end

#[4]
$atm_is06 = [
	{"0" => 0, "1" => 1, "2" => 0},
	{"0" => 1, "1" => 0, "2" => 1, :final => true}
]
