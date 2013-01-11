def make2d(h,w)
	#a=Array.new(h)
	#a.map!{|e|
	#	e=Array.new(w,0)
	#}
	#return a
	Array.new(h){Array.new(w,0)}
end

#[1]
def combination_pascal(n,k)
	c=make2d(n+1,n+1)
	for i in 0..n
		c[i][0]=c[i][i]=1 #(a)
		for j in 1..(i-1)
			c[i][j]=c[i-1][j-1]+c[i-1][j]
		end
	end
	return c[n][k]
end

#(b) c[2][1]=2,c[3][1]=3,c[3][2]=3
#(c) iが0-nのループで、jが1-(i-1)のループだから、計算量はO(n^2) (実際はその半分)

def combination_recursive(n,k)
	if k > n then return 0
	elsif  k == 0 then return 1
	else return combination_recursive(n-1,k-1)+combination_recursive(n-1,k)
	end
end

#(d) (3,2)((2,1)(*(1,0),(1,1)(*(0,0),(0,1))),(2,2)((1,1)(*(0,0),(0,1)),(1,2)))
#(e) 前者はパスカルの三角形を描ききってから求める(O(n^2))が、後者は右側の再起はすぐに処理を返す。よってO(n)となる。

#[2]
#usually, use a.uniq and a.group_by{|e|e}/a.count
def intcount(a, b, c)
	for i in 0..(a.length()-1)
		x = a[i]
		j=0
		while b[j] != 0 && b[j] != x
			j=j+1
		end
		if b[j] == 0
			b[j] = x
			c[j] = 1
		else
			c[j] = c[j] + 1
		end
	end
end
#(a) O(nm)

#(b)
#similar to std::unique.
def intcount_unique(a, b, c)
	x=a[0]
	j=0
	1.step(a.length-1){|i|
		if x!=a[i] then
			b[j]=x
			c[j]+=1
			x=a[i]
			j+=1
		else
			c[j]+=1
		end
	}
	b[j]=x
	c[j]+=1
end

#[3] (a) (c) explained in is06.
#(b) 0.3と0.1はいずれも2で割り切れないため、ごく小さい丸めが行われて保存される。丸められたものを3倍しても同じにはならない。
#(d) 解が小さくなるとき、b>0のとき-b+sqrt(d)が、b<0のとき-b-sqrt(d)が0に近くなり有効桁数が落ちる事態が発生する。そのためfb()では有効桁数が落ちる側の解についてもう片方の解から間接的に求める手法をとっている。

#[4]
#(a) (a) (m,n)に移動できるのは(m,n-1),(m-1,n),(m-1,n-1)のみ。T(0,0)=0,T(i,0)=T(j,0)=1 #i,jの位置が逆である、誤植
#(b)
def tmn(m,n)
	c=make2d(m+1,n+1)
	1.step(m){|i| c[i][0]=1}
	1.step(n){|j| c[0][j]=1}
	1.step(m){|i|
		1.step(n){|j|
			c[i][j]=c[i][j-1]+c[i-1][j]+c[i-1][j-1]
		}
	}
	return c[m][n]
end
