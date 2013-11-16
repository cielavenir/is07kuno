def make1d(n) Array.new(n) end

#[1]
#(a) 階乗
#(b)
def is12f(n)
	if n >= 2
		n * is12f(n - 1)
	else
		1
	end
end

def is12f2(n)
	1.step(n).reduce(:*)
end

#(c) フィボナッチ数
def is12g(n)
	if n >= 2
		is12g(n - 1) + is12g(n - 2)
	else
		1
	end
end

#(d)
def is12h(n)
	result = make1d(n+1)
	i = 0 ###
	while i<=n ###
		if i >= 2
			result[i] = result[i-1]+result[i-2] ###
		else
			result[i] = 1
		end
		i = i+1 ###
	end
	result[n] ###
end

#[2]
def mindiff(a)
	0.step(a.size-2).map{|i|
		(i+1).step(a.size-1).map{|j|(a[i]-a[j]).abs}.min
	}.min
end
def mindiff_sorted(a)
	a.each_cons(2).map{|x,y|y-x}.min
end
def mindiff2(a)
	mindiff_sorted(a.sort) # RubyのsortはO(nlogn)であるので、全体のオーダーもO(nlogn)となる。
end

#[3]
#解けませんでした。この年の受講だったら落としてるな--;

#[4]
def post2(a, b, m, n, as, bs)
	if as != "" && as == bs
		as
	elsif n == 0
		""
	else
		k = 0
		p = ""
		while p == "" && k < m
			p = post2(a, b, m, n-1, as+a[k], bs+b[k])
			k = k + 1
		end
		p
	end
end
def post(a,b,nmax)
	raise if a.size!=b.size
	post2(a,b,a.size,nmax,'','')
end

#(a)
#01100011000000 ∴ 1,0,0,1,2,0,0,2,2,2
#(b) "11011"
#(c)
#a=配列a,b=配列b,m=配列aの大きさ,n=検索段数,as=''(空文字列),bs=''
#返値=結果文字列もしくは''(検索失敗時)
#(d) O(m^n)