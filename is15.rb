#[1]
def tri_rec(n)
	if n<2 ###
		0
	elsif n==2 ###
		1
	else
		tri_rec(n-1)+tri_rec(n-2)+tri_rec(n-3) ###
	end
end

def tri_loop(n)
	p3 = 0
	p2 = 0
	p1 = 1
	c = 1
	for i in 4..n
		p3 = p2
		p2 = p1      ###
		p1 = c       ###
		c = p1+p2+p3 ###
	end
	c
end

require 'matrix'
def tri_mat(n)
	a = make2d(3,3)
	for i in 0..2
		for j in 0..2
			if i==2||j-i==1
				a[i][j] = 1
			else
				a[i][j] = 0
			end
		end
	end
	b = Matrix[*a]**(n+1) ###
	b[0,0]
end

#[2]
#(1) 理論中心の問題
#(2)
def pi(n)
	delta = 1.0 / n
	s = 1.0 / 2.0
	for i in 1..(n - 1)
		s = s + Math.sqrt(1 - (delta*i) ** 2)
	end
	s/n * 4
end
#数値計算の上で誤差が発生するため、nをある程度以上大きくしてもそれ以上円周率には近づかない

#[3]
NS=[
[1, 1, 1, 0, 1, 1],
[1, 0, 0, 1, 1, 1],
[1, 0, 1, 1, 1, 1],
[1, 1, 0, 1, 1, 1],
[1, 1, 1, 1, 0, 1],
[0, 0, 0, 0, 0, 0]
]
WE=[
[1, 1, 1, 1, 1, 0],
[1, 1, 1, 0, 1, 0],
[1, 1, 0, 1, 1, 0],
[1, 1, 1, 1, 1, 0],
[0, 1, 1, 1, 1, 0],
[1, 1, 1, 1, 0, 0]
]
def cp1(y, x)
	if y == 0
		if x == 0
			1
		else
			cp1(0,x-1)*WE[0][x-1]
		end
	else
		if x == 0
			cp1(y-1,0)*NS[y-1][0]
		else
			cp1(y,x-1)*WE[y][x-1]+cp1(y-1,x)*NS[y-1][x]
		end
	end
end

def cp2(y, x)
	count = make2d(y + 1, x + 1)
	for i in 0..y
		for j in 0..x
			count[i][j] = is15calc(i, j, count)
		end
	end
	count[y][x]
end

def is15calc(y, x, count)
	if y == 0
		if x == 0
			1
		else
			count[0][x-1]*WE[0][x-1]
		end
	else
		if x == 0
			count[y-1][0]*NS[y-1][0]
		else
			count[y][x-1]*WE[y][x-1]+count[y-1][x]*NS[y-1][x]
		end
	end
end
