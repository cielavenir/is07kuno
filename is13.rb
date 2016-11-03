#coding:utf-8

#[1]
#sort使っちゃうと身もふたもないんですが(本当は尺取り法を使う)
def merge(a,b) (a+b).sort end

#(a)
def mergesort(a)
	n = a.length()
	from = make2d(n,1)
	for i in 0..(n-1)
		from[i][0] = a[i]
	end
	while n > 1
		to = make1d((n+1)/2)
		for i in 0..(n/2-1)
			to[i] = merge(from[i*2],from[i*2+1])
		end
		if !n.even?
			to[(n+1)/2-1] = from[-1] ###
		end
		from = to
		n = from.size ###
	end
	from[0] ###
end

#(c)
#単純整列法:計算量 O(n^2) 元配列以外のメモリは不要
#併合整列法:計算量 O(nlogn) 元配列と少なくとも同じだけのメモリが必要

#[2]
#(a)
def x_sort(a)
	i=0
	while (i+1 < a.length())
		if a[i] > a[i+1]
			s = a[i]
			a[i] = a[i+1]
			a[i+1] = s
		end
		i = i+1
	end
	a
end
#ii: x_sort([3,2,1]) =>  [2, 1, 3]

#(b)
def is13min(a,i,j)
	if i == j
		a[i]
	elsif a[j] < min(a,i,j-1)
		a[j]
	else
		min(a,i,j-1)
	end
end

#i. [1,2,3,4] O(n)
#ii. 左と右の両方を調べれば半分の時間で完了するか(?)

#[3]
#複素数の除算とかわかりません

#[4]
#w,l,dの定義があるので保留
