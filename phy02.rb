#最小２乗法を用いて傾きを求める

def min2(a,b)
	if a.length != b.length then return nil end
	if a.length < 2 then return nil end
	x=[]
	1.step(a.length-1){|i|
		x.push((b[i]-b[i-1])/(a[i]-a[i-1]))
	}
	return x.average
end
