#平均、実験標準偏差、相対不確かさ

def deltan(a)
	n=a.average
	x=0
	a.length.times{|i| x+=(n-i)**2}
	dn=x.sqrt/(a.length*(a.length-1)).sqrt
	return n,dn,dn/n
end
