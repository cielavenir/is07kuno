#[1]
def inner(a, b)
=begin
	if a.empty?
		0
	else
		a[0]*b[0] + inner(a[1..-1], b[1..-1])
	end
=end
	a.zip(b).reduce(0){|s,(x,y)|s+x*y}
end
def add(a, b)
=begin
	if a.empty?
		[]
	else
		[a[0]+b[0]] + add(a[1..-1], b[1..-1])
	end
=end
	a.zip(b).map{|x,y|x+y}
end
def vmmult(v, a)
	vmmult1(v, a.transpose)
end
def vmmult1(v, a)
	if a.empty?
		[]
	else
		inner(v,a[0]) + vmmult1(v,a[1..-1])
	end
end
def mmmult(a, b)
	mmmult1(a, b.transpose)
end
def mmmult1(a, b)
	if a.empty?
		[]
	else
		vmmult(a[0],b) + mmmult1(a[1..-1],b)
	end
end

# 穴埋めが親切ですね…

#[2]
#(1) P(t,a)=P(t-1,a-1)*p+P(t-1,a+1)*q
#(2) 同じ関数を何度も呼び出すから
#(3)
def P_loop(t,a)
	p=0.7
	q=0.3

	prob = make2d(t+1,11)
	for j in 0..10
		if j == 5
			prob[0][j] = 1 ###
		else
			prob[0][j] = 0 ###
		end
	end
	for i in 1..t
		for j in 0..10
			if j == 0 || j == 1
				prob[i][j] = prob[i-1][j+1]*q ###
			elsif j == 9 || j == 10
				prob[i][j] = prob[i-1][j-1]*p ###
			else
				prob[i][j] = prob[i-1][j-1]*p+prob[i-1][j+1]*q ###
			end
		end
	end
	prob[t][a]
end
#(4) O(nt)
#(5) 略

#[3] (理論中心の問題)

#[4]
#(1)
def is14f2()
	max = 0
	for i in 0..N-2
		rcvr_i = C[i][0] # 初めの捜査官を i 番目の盗賊に配置して回収できる金額
		for j in i+1 ..N-1
			rcvr_j = C[j][1] # 次の捜査官を j 番目の盗賊に配置して回収できる金額
			rcvr = rcvr_i + rcvr_j
			if max < rcvr
				max = rcvr
			end
		end
	end
	max
end
#(2) O(N^3)
#(3) rcvr[n-1][m-1]+C[n-1][m-1]
#(4)
def is14g()
	rcvr = make2d(N+1,M+1)
	for i in 1..N
		for j in 1..N
			rcvr[i][j]=max(rcvr[i-1][j],C[i-1][j-1])
		end
	end
	rcvr[N][M]
end
