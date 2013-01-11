#max -> Report2A
#make2d -> is10

#[1]
#(a) (0,8,)4,-1,1
def s(a,i,j)
	return i.step(j-1).reduce(0){|s,i|s+=a[i]}
end
#(b) O(N)
#(c) O(N^3)
def mss(a,x,y)
	m = 0
	x.step(y-1){|i|
		i.step(y-1){|j|
			m = max(m,s(a,i,j))
		}
	}
	m
end
#(d)
# i   0 1 2 3 4 5 6 7 8 9
# sum 8 4 0 2 6 1 6 9 2 10
# t   8 8 8 8 8 8 8 9 9 10
def mss0(a,m)
	t = 0
	sum = 0
	m.times{|i|
		sum = sum + a[i]
		if sum > t
			t = sum
		elsif sum < 0
			sum = 0
		end
		p [sum,t]
	}
	t
end
#(e) O(N)

#[2]
def pow_binary(x,y)
	z = 1
	while y != 0
		while y % 2 == 0
			x = x * x
			y = y / 2
		end
		y = y - 1
		z = z * x
	end
	z
end
#f(2,4) => 16, f(3,5) => 243 (a) therefore, f(a,b) => a**b (b)
#要するにバイナリ方法で累乗を計算している。

#[3]
#(a) (b) explained in is06.
def escapesteps(x,y)
	n = 0
	escaped = false
	while !escaped
	r = rand()
	dx = cos(2*Math::PI*r)
	dy = sin(2*Math::PI*r)
	x1 = x + dx
	y1 = y + dy
	if x1 < 0
		if -1 < y && y < 1 # (c) I don't know which is correct: < or <=
			escaped = true
		else
			x = -x1 # (d)
			y = y1
		end
	else
		x = x1 # (d)
		y = y1
	end
	n+=1
	end
	n
end

#[4]
def gain(i,j) return j end #yay?

def maxGain(i,j,m,n)
	if i < 1 || i > m || j < 1 || j > n
		0.0
	else
		if i == 1
			gain(1, j)
		else
			gain(i,j)+max(maxGain(i-1,j-1,m,n),max(maxGain(i-1,j,m,n),maxGain(i-1,j+1,m,n))) #(a)
		end
	end
end
#(b) m^3 (order should be correct, but I'm not sure)

#(c)
def calculateTotal(m,n)
	totalGain = make2d(m+1, n+2)
	1.step(m){|i|
		totalGain[i][0] = 0
		totalGain[i][n+1] = 0
		1.step(n){|j|
			if i == 1
				totalGain[i][j] = gain(i,j)
			else
				totalGain[i][j] = gain(i,j)+max(totalGain[i-1][j-1],max(totalGain[i-1][j],totalGain[i-1][j+1]))
			end
		}
	}
	totalGain
end
