def max(a,b)
	if a<b then return b
	else return a end
end

def exp5a_riron(v)
	return 1.893*10**-9*v**2 #6mm
	#return 1.773*10**-9*v**2 #6.2mm
end

def exp5a
	a=[0.000,7.84*10**-5,1.764*10**-4,3.136*10**-4,4.802*10**-4,6.762*10**-4,9.31*10**-4,1.2054*10**-3,1.5288*10**-3,1.8816*10**-3]
	ret=(a[1]-exp5a_riron(200)).abs/exp5a_riron(200)
	1.step(9){|i|
		ret=max(ret,(a[i]-exp5a_riron((i+1)*100)).abs/exp5a_riron((i+1)*100))
	}
	return ret*100
end
# => 3.5393555203381

def exp5b_riron(i)
	return 1.88*10**-5*i**2 #4mm
	#return 1.343*10**-5*i**2 #6mm
end

def exp5b
	a=[3.43*10**-5,1.519*10**-4,2.94*10**-4,5.047*10**-4,7.693*10**-4,1.0878*10**-3]
	ret=(a[0]-exp5b_riron(1)).abs/exp5b_riron(1)
	6.times{|i|
		ret=max(ret,(a[i]-exp5b_riron(i+1)).abs/exp5b_riron(i+1))
	}
	return ret*100
end
# => 101.994680851064 誤差102%。なんだって〜
