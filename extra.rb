### Report 11A補
def alignmentsample #増原先生のデータセット(リボヌクレアーゼP)。この文字列はパブリックドメインじゃないと思うんでお気をつけを。
	alignment(
		"AAAGCAGGCCAGGCAACCGCUGCCUGCACCGCAAGGUGCAGGGGGAGGAAAGUCCGGACUCCACAGGGCAGGGUGUUGGCUAACAGCCAUCCACGGCAACGUGCGGAAUAGGGCCACAGAGACGAGUCUUGCCGCCGGGUUCGCCCGGCGGGAAGGGUGAAACGCGGUAACCUCCACCUGGAGCAAUCCCAAAUAGGCAGGCGAUGAAGCGGCCCGCUGAGUCUGCGGGUAGGGAGCUGGAGCCGGCUGGUAACAGCCGGCCUAGAGGAAUGGUUGUCACGCACCGUUUGCCGCAAGGCGGGCGGGGCGCACAGAAUCCGGCUUAUCGGCCUGCUUUGCUU",
		"CGAGCCGGGCGGGCGGCCGCGUGGGGGUCUUCGGACCUCCCCGAGGAACGUCCGGGCUCCACAGAGCAGGGUGGUGGCUAACGGCCACCCGGGGUGACCCGCGGGACAGUGCCACAGAAAACAGACCGCCGGGGACCUCGGUCCUCGGUAAGGGUGAAACGGUGGUGUAAGAGACCACCAGCGCCUGAGGCGACUCAGGCGGCUAGGUAAACCCCACUCGGAGCAAGGUCAAGAGGGGACACCCCGGUGUCCCUGCGCGGAUGUUCGAGGGCUGCUCGCCCGAGUCCGCGGGUAGACCGCACGAGGCCGGCGGCAACGCCGGCCCUAGAUGGAUGGCCGUCGCCCCGACGACCGCGAGGUCCCGGGGACAGAACCCGGCGUACAGCCCGACUCGUCUG")
end

#bench(1){alignmentsample} => 9.12

### 河内谷先生の問題をやってみるぉ
def primes2(n) #report2
	a=Array.new(n+1)
	print 2
	3.step(n,2){|i|
		if !a[i] then #a[i]の初期値はnil
			print " "+i.to_s
			i.step(n,i){|j| a[j]=0}
		end
	}
	puts
end

=begin
[Ruby/irb]
bench(1){primes(100000)}  => 11.34
bench(1){primes2(100000)} => 0.75
[Java]
echo 100000 | time java report12a 46 => 1.00
echo 100000 | time java primes => 0.65
JavaはRubyよりも非常に高速であることが分かった。
また、Rubyは最適化が無いので、効率の良いアルゴリズムが全体の速度に非常に影響を与えることが分かる。
=end

def pattern(s) #report3
	#状態数は決まってるのだから記憶装置付きのオートマトンでも書けば十分でしょw手抜きで済みませんwww
	a=[
		{"0"=>0,"1"=>1},{"0"=>0,"1"=>2},{"0"=>0,"1"=>3},{"0"=>0,"1"=>4},{"0"=>0,"1"=>5},
		{"0"=>0,"1"=>6},{"0"=>0,"1"=>7},{"0"=>0,"1"=>8},{"0"=>0,"1"=>9},{"0"=>0,"1"=>10},
		{"0"=>0,"1"=>11},{"0"=>0,"1"=>12},{"0"=>0,"1"=>13},{"0"=>0,"1"=>14},{"0"=>0,"1"=>15},
		{"0"=>0,"1"=>16},{"0"=>0}
	]
	_s=s+"0"
	cur=0
	f=nil
	_s.each_byte{|c|
		x=a[cur][c.chr]
		if cur!=0 && x==0 then
			if f then print ", " end; f=1
			print "width=#{cur}"
		end
		cur=x
	}
	puts
end

#意外に、JavaやりまくってるとRuby忘れますねw今から試験なのにw
#ちなみに上の製作時間は10分。河内谷先生楽過ぎwww

#PKU1006のAnalysticな解を求めるために作った中国剰余定理solver(x=a[i][0] mod a[i][1]を解く)。
#Fortran書いてるとRubyを忘れるねw
def chinese(a)
	if !a || a.length==0 then return nil end
	ret=0;m=1;
	a.length.times{|i| m*=a[i][1]}
	a.length.times{|i|
		p=a[i][1];q=m/p;s=0
		while s%p!=1 do s+=q end
		ret+=s*a[i][0]
		#p s
	}
	return ret%m,m
end

#第3回演習2b
def newton(n,e)
	r=0.1;s=5
	#nf= lambda{|n|   r**4-2.098746*  r**3-17.98907*  r**2+8.67535*r*67.4253}
	#nfp=lambda{    4*r**3-2.098746*3*r**2-17.98907*2*r+8.67535}
	nf= lambda{|n|   r**2-n}
	nfp=lambda{      2.0*r}
	while (s-r).to_f.abs > e do
	 r=s;s=r-nf.call(n)/nfp.call
	end
	return r
end

def simpson_f(x) return x**2 end
def simpson(xmin, xmax, n)
	s=0; d=(xmax-xmin)/n.to_f
	xmin.step(xmax-d, d){|x| s+=(simpson_f(x)+4*simpson_f(x+d/2.0)+simpson_f(x+d))*d/6}
	return s
end

def fizzbuzz(num=100,a=3,b=5)
	1.step(num){|i|
		if i%a==0
			print "Fizz"; f=1
		end
		if i%b==0
			print "Buzz"; f=1
		end
		if !f then print i end
		puts
	}
end
