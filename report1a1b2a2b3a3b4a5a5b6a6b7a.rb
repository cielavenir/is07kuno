###Report1A

#演習3.b
def enzan(x,y)
	return x+y, x-y, x*y, x/y, x%y
end

=begin
和、差、積、商、剰余を配列で返す。
x,yともに整数の場合、当然ながら商は整数範囲になる。
剰余はxからyを引けるだけ引いた残りとなるようです。
しかし、ごくわずかな誤差が生じる場合があるようなので、実装は「引いた残り」ではないと考えられます。
例: 9%2.7==0.899999999999999, 9%2.8==0.600000000000001
=end

###Report 1B

#演習3.f
#->core.rb Numeric::sqrt

=begin
平方根を返す。
気づいたことは…書くとすれば、整数を入れても強制的に小数になることでしょうか( sqrt(4)は2.0 )
ただMath.sqrtを呼んでいるだけですのでこれ以上はありません…
=end

#演習4
def add(num,step)
	if ((num<0) || (num<step))
		return num
	else
		return add(num-step, step)+step #再帰
	end
end

#実行: printf("%.2f\n",bench 10000{add(2**(x+6)-2**26,2**x)})

=begin
足し算を多数回実行してその時間を計る。
再帰で書いてみようとしたが、Rubyの再帰はあまりうまく行かなかった(stack level too deep)。
なので、2**xを2**(x+6)に達するまで足し続ける方法をとりました。
実行結果(ruby ...rb):
x=21 3.76
x=22 3.85
x=23 3.74
x=24 4.08
x=25 7.91
x=26 10.33
32ビットCPUは-2**31〜2**31-1までの数を扱えるので、x=25からFixnumで扱えなくなりBignum(多倍長整数)で扱うようになる。その結果実行時間が増大する。

※この考察は間違いで、RubyのFixnumは-2**30〜2**30-1です。
=end

###Report 2A

#演習2.c
def positive?(x)
	if !x then return "nil" end
	if x==0 then return "zero" end
	if x>0 then return "positive" end
	return "negative"
end

=begin
コメントした状態でxにnilを渡すとx==0でNoMethodErrorがraiseされる。
コメントをはずしても、xに0を渡すとzeroと表示される。
従って、!xはxがnilか否かの判定しかせず、この点CやPerlとは挙動が異なるようです。
=end

###Report 2B

#演習4.b
=begin
def fact(x)
	if x<0 then return nil end
	ret=1
	2.step(x.floor-1){|i| ret*=i} #|_x_|==0,1のとき実行されない
	return ret
end
=end

#->core.rb Numeric::fact

=begin
階乗を返します。小数を渡した場合はそれを越えない最大の整数に変換されます。x<0の時の処理も一応加えてみました。
ちなみに:
def _fact2(x)
	if x==0 then return 1 end
	return _fact2(x-1)*x
end

def _fact(x)
	if x<0 then return nil end
	return _fact2(x.floor)
end
という実装(再帰)もありますが、今回の趣旨(分岐・繰り返し)とはそれてしまいますので(それからスタックの深さには制限があるようなので)、
解答としては上の方でお願いします。
=end

#演習6
=begin
擬似コード:
isprime: nが素数であるか否か判別
	もしnが2未満なら偽を返す
	iを2から「√(n)を越えない最大の整数」まで変えながら繰り返し
		もしnをiで割った余りが0なら偽を返す
	繰り返し終わり
	正を返す
=end

#実装
=begin
def prime?(n)
	if n<2 then return false end
	2.step(Math.sqrt(n).floor){|i|
		if n%i==0 then return false end
	}
	return true
end
=end

#->core.rb Numeric::prime?

=begin
素数か否か返します。boolを使ってみました。
演習4.bではいちいち小数除けをしましたが、今回から引数の型が指定されている場合は特に小数よけはしないことにします。
「合成数の因数は√nより大きいものと小さいものが対になる」定理を利用してわずかに速くしています。
=end

###Report 3A

#演習2.a
def myabs(x)
	if x<0 then return -x
	else return x end
end

def mysqrt(n,e) #eは小数
	x=n.to_f
	if x<0.0 then return nil end
	if x==0.0 then return 0.0 end
	if x==1.0 then return 1.0 end
	if x<1.0
		a=x
	b=1
	else
		a=0
		b=x
	end
	ret=(a+b)/2.0
	#while (ret*ret-x).abs>e #最初abs(ret*ret-x)とやってしまいエラーに焦る
	while myabs(ret*ret-x)>e #やはりRubyの関数は極力使うべきではないのか…?
		if ret*ret>x then b=ret
	else a=ret end
	ret=(a+b)/2.0
	end
	return ret
end

=begin
nの平方根を、二分法を用い誤差eの範囲で返します。nには小数を入れても動きます。
負数や0、1、1より小さい小数が入ってきても耐えられるようにしました。
ただし、mysqrt(0.01,0.00001)==0.100032958984375などとなってしま
います。残念ながら。
=end

### Report 3B

#演習3.a
def max(a,b) #今になって前回の演習2.aを解く人。
	if a<b then return b
	else return a end
end

#本題
def maximum(a)
	ret=-1073741824
	a.each{|x|
		ret=max(ret,x)
	}
	return ret
end

#修正版
def maximum2(a)
	if a.length == 0 then return nil end
	if a.length == 1 then return a[0] end
	ret=max(a[0],a[1])
	2.step(a.length-1){|i|
		ret=max(ret,a[i])
	}
	return ret
end

=begin
配列の要素の最大値を返します。
maximum()ではFixnumの最低値より低い値しか渡されないと誤った結果になる問題があります
(型宣言が必要な言語では起こらない問題ではあります)。
maximum2()はその対策を施した版です。

前回提出したときは気づいていませんでしたが、maximum()に長さ0の配列を渡しても-1073741824を返すバグがありました。
情報科学の学習においては長さは1以上であるという仮定はすべきでないので、("[].max"と同様)nilを返すよう修正しました。
=end

#演習4
def mysort!(a) #"!" means destructive
	0.step(a.length-2){|i|
		(i+1).step(a.length-1){|j|
			if a[i]>a[j] then a[i],a[j] = a[j],a[i] end
		}
	}
	return a
end

=begin
aを小さい順に並べ替えて出力します。大小比較法です。
=end

###Report 4A

#演習2.d
def binary(n)
	s = n&1==1 ? "1" : "0"
	return (r=n>>1)==0 ? s : binary(r)+s
end

=begin
図(等幅フォントでないと崩れます)
binary(5)->binary(2)->binary(1)
						          |
						          v
"101"    <-"10"    <-"1"
=end

###Report 5A

#演習1
def randarray(n)
	#a = []
	#n.times{a.push(rand(10000))}
	#return a
	n.times.reduce([]){|a,i|a.push(rand(10000))}
end

#def mysort!(a) -> Report 3B

# bench(1){mysort!(randarray(N))}
# N=1000 => 3.76
# N=2000 => 14.27
# N=3000 => 32.19
# (予想通り)O(N^2)であった。

###Report 5B

#def randarray(n)
#	a = []
#	n.times{a.push(rand(10000))}
#	return a
#end

#演習4
def binsort(a) #数字以外のデータが含まれる場合このコードは使用できません…
	x=Array.new(10000) {0} #randarrayと同じ範囲に設定する
	ret=[]
	a.each{|i|
		x[i]+=1 #インクリメントは使えんのかい^^;
	}
	x.length.times{|i|
		x[i].times{
			ret << i
		}
	}
	return ret
end

# ビンソートを行う。
# 以下非常に高速であったためNを10000単位にし、さらに10回ソートさせて計測した。
# (bench(10){binsort(randarray(N))})/10.0
# N=10000 => 0.0454
# N=20000 => 0.075
# N=30000 => 0.1062
# N=40000 => 0.1344
# N=50000 => 0.1625
# N=60000 => 0.1953
# N=70000 => 0.2234
# N=80000 => 0.2563
# N=90000 => 0.2922
# N=100000 => 0.314
# O(N)であった。

#演習6
#組み合わせ
#1.単純計算
#実行時間はrに依存する。fact(N)の計算量はO(N)であるから、
#たとえばr=0とすればfact(n)を2回計算しなければならないため、O(N^2)と予想される。
#def fact(x) -> core.rb Numeric::fact

def comb1(n,r)
	return n.fact/r.fact/(n-r).fact
end

# (bench(10){comb1(N, 0)})/10.0
# N=1000 => 0.0172
# N=2000 => 0.656
# N=3000 => 0.1578
# N=4000 => 0.2656
# N=5000 => 0.4266
# N=6000 => 0.6188
# N=7000 => 0.8671
# N=8000 => 1.1438
# N=9000 => 1.5015
# N=10000 => 1.8391
# 予想通りO(N^2)であった。

#2.再帰(宣言型の考えではパスカルの三角形を下からたどることに相当)
#実行時間はrに非常に依存する。r=0,nならばO(N)となり最速のアルゴリズムであるが、
#r=n/2のときは再起する回数が非常に大きくなるため最遅のアルゴリズムといえる。
def comb2(n,r)
	if r==0 || r==n then return 1 end
	return comb2(n-1, r-1) + comb2(n-1, r) #この数字を記憶しないから遅い…
end

# (bench(10){comb3(N, N/2)})/10.0
# N=12 => 0.0031
# N=14 => 0.0141
# N=16 => 0.0516
# N=18 => 0.1985
# N=20 => 0.7687
# N=22 => 2.9187
# N=24 => 11.2078
# N=26 => 43.064
# 予想もし得なかったが、まさかのO(2^N)であった。
# 呼び出される「たびに」2つ関数を呼ばなければならないことから考えれば当然かも知れませんが…

#3.パスカルの三角形のn段目を求める
#実行時間はrに依存しないのでr=0とした。
#i回目にi+a(aは定数、下の例では3)の大きさを持つ配列を処理するため、計算量はO(N^2)と予想される。
def comb3(n,r)
	a=[0,1,1,0]
	2.step(n){
		x=[0]
		(a.length-1).times{|i|
			x.push(a[i]+a[i+1])
		}
		x.push(0)
		a=x
	}
	return a[r+1]
end

# (bench(10){comb3(N, 0)})/10.0
# N=100 => 0.0141
# N=200 => 0.0703
# N=300 => 0.1578
# N=400 => 0.2843
# N=500 => 0.45
# N=600 => 0.6563
# N=700 => 0.9015
# N=800 => 1.1891
# N=900 => 1.5203
# N=1000 => 1.8797
# 予想通りO(N^2)であった。ただ、1.より100倍遅いのは配列操作の問題であろう。

#4.パスカルの三角形をあらかじめ作り、それを参照する
#O(N^2)の記憶が必要になる代わりに、(三角形生成後の)計算量はO(1)で済む。
def pascal(n)
	$pascal=Array.new(n)
	$pascal[0]=Array.new(2) {1}
	1.step($pascal.length-1){|i|
		$pascal[i]=Array.new(i+2)
		$pascal[i][0]=$pascal[i][i+1]=1
		1.step(i){|j|
			$pascal[i][j]=$pascal[i-1][j-1]+$pascal[i-1][j]
		}
	}
end

def comb4(n,r)
	return $pascal[n-1][r]
end

# pascal(1000)
# bench(100000){comb4(N,N/2)}
# ※以下は100000回処理するのにかかった合計時間です。平均時間はこの1/100000です。非常に高速であることがわかります。
# N=100 => 0.2650
# N=200 => 0.25
# N=300 => 0.2660
# N=400 => 0.25
# N=500 => 0.25
# N=600 => 0.25
# N=700 => 0.25
# N=800 => 0.25
# N=900 => 0.25
# N=1000 => 0.2660
# 予想通りである(その後測りなおすとN=100,300,1000でも0.25と出た)。

#本当はpascal(10000)など実験したかったですが、メモリ不足でした(pascal(1000)でもメモリ使用量は123MBになるらしい)。

###Report 6A

#演習1a
def gauss(a)
	if !a || a.length==0 then return nil end
	n=a.length
	n.times{|i| #各式(i)で
		if a[i][i]==0
			if (i+1).step(n-1){|j|
				if a[j][i]!=0
					i.step(n){|k| a[i][k]+=a[j][k]}
					break
				end
			}
				raise 'given equation is not solvable'
			end
		end
		n.times{|j|
			if j!=i then #式jの
				r = a[j][i] / a[i][i].to_f
				i.step(n){|k| a[j][k] = a[j][k] - a[i][k]*r} #第i項以降を消去
			end
		}
		#p(a)
	}

	n.times{|i| #係数修正
		x=a[i][i].to_f
		a[i].length.times{|j|
			a[i][j] /= x
		}
	}

	return a
end

=begin
確かに1段で解を求めることができたが、[0.0,0.0,2.0,2.0]のようになってしまったので、
係数を修正する作業が必要になってしまった。

※処理が2x3=2でとまってしまうと言う意味です。
=end

###Report 6B

#演習3,4(log2(e)を2^xを0から1まで積分して求める)
#参考:google(1/ln(2)) = 1.44269504
def log2erand(n) #n:試行回数
	c=0
	n.times{
		x=rand(); y=rand()*2
		if y < 2**x then c+=1 end
	}
	return 2.0*c/n
end

def log2egrid(n) #n:x軸の格子数
	c=0
	0.step(1,1/n.to_f){|x|
		0.step(2,1/n.to_f){|y|
			if y < 2**x then c+=1 end
		}
	}
	return c/(n**2).to_f
end

=begin
モンテカルロ法については、n=1000で有効数字2桁、n=10000で3桁、n=100000で4桁ほど保証されるようである。
n=1000000としても精度は向上しなかった。
一方、格子点の方法では、n=100(20000回ループ)で2桁(1.4626)、n=1000(2000000回ループ)で3桁(1.444694)保証される。
つまり、モンテカルロ法はある程度の精度には早く近づくが、それ以上に精度を上げることは難しく、
格子点の方法は、精度が上がるのは遅いが精度を無限大に上げることができるといえる。
このことから、ある程度の精度で十分ならばモンテカルロ法、
細かい精度が必要ならば格子点の方法を使うべきだと言うことがわかる。

※ここでいう無限大とはdoubleの精度の中での意味です。
=end

###Report 7A

#演習2
#dy/dx = f(x,y)を解く
def f(x,y) return 1/(2*y).to_f end #y*(3+x)

def euler(xmin, y, xmax, count)
	h = (xmax-xmin).to_f / count
	count.times{|i|
		x = xmin + h * (i+1)
		y = y + h * f(x,y)
	}
	return y
end

=begin
irb(main):020:0> euler(0,1,1,10)
=> 1.42051979929104
irb(main):021:0> euler(0,1,1,100)
=> 1.41482796736591
irb(main):022:0> euler(0,1,1,1000)
=> 1.41427484589246
irb(main):023:0> euler(0,1,1,10000)
=> 1.41421968916029
irb(main):024:0> euler(0,1,1,100000)
=> 1.41421417503617
=end

def rungekutta2(xmin, y, xmax, count)
	h = (xmax-xmin).to_f / count
	count.times{|i|
		x = xmin + h * (i+1)
		k1 = h * f(x,y)
		k2 = h * f(x+h,y+k1)
		y = y + (k1+k2)/2.0
	}
	return y
end

=begin
irb(main):025:0> rungekutta2(0,1,1,10)
=> 1.41421571099439
irb(main):026:0> rungekutta2(0,1,1,100)
=> 1.41421356445272
irb(main):027:0> rungekutta2(0,1,1,1000)
=> 1.41421356237517
irb(main):028:0> rungekutta2(0,1,1,10000)
=> 1.41421356237309
irb(main):029:0> rungekutta2(0,1,1,100000)
=> 1.41421356237309
=end

def rungekutta4(xmin, y, xmax, count)
	h = (xmax-xmin).to_f / count
	count.times{|i|
		x = xmin + h * (i+1)
		k1 = h * f(x,y)
		k2 = h * f(x+h/2.0,y+k1/2.0)
		k3 = h * f(x+h/2.0,y+k1/2.0)
		k4 = h * f(x+h,y+k3)
		y = y + (k1+2*k2+2*k3+k4)/6.0
	}
	return y
end

=begin
irb(main):030:0> rungekutta4(0,1,1,10)
=> 1.41417536690744
irb(main):031:0> rungekutta4(0,1,1,100)
=> 1.41421319270832
irb(main):032:0> rungekutta4(0,1,1,1000)
=> 1.41421355868887
irb(main):033:0> rungekutta4(0,1,1,10000)
=> 1.41421356233626
irb(main):034:0> rungekutta4(0,1,1,100000)
=> 1.41421356237274
=end

=begin
Euler法とRungeKutta法(2次、4次)です。
fを変えることで他の微分方程式も解けるようにしました。
実行結果を見ると、下のアルゴリズムの方が早く精度を上げられかつ誤
差が少ないことがわかる。
=end

