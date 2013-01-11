class Integer
	#p means polynomial.
	def lucasp2(x)
		s=2; t=x
		if self==1 then return x end
		1..step(self-1){|i|
			r=x*t+s; s=t; t=r
		}
		return r
	end

	def lucasp(x)
		if x.to_i==1 then
			if self==0 then return 2 end
			if self<0 && self%2!=0 then return -(-self).lucasp2(1) end
			return abs.lucasp2(1)
		end
		if self<0 then return nil end
		if self==0 then return 2 end
		return lucasp2(x)
	end

	def lucas() return lucasp(1) end

	def padovan2(a)
		if self<0 then return nil end
		if self<a.length then return a[self] end
		r=0
		(a.length-1).step(self-1){|i|
			r=a[0]+a[1]
			(a.length-1).times{|j|a[j]=a[j+1]}
			a[a.length-1]=r
		}
		return r
	end

	def padovan() return padovan2([1,1,1]) end
	def perrin() return padovan2([3,0,2]) end

	def naccip(s,x)
		s-=1;
		if self<0 then return nil end
		if self==0 then return 0 end
		if self==s then return 1 end

		a=Array.new(s+1);
		(a.length-1).times{|j|a[j]=0}
		a[a.length-1]=1

		r=0
		s.step(self-1){
			r=a.sumfib(x)
			(a.length-1).times{|j|a[j]=a[j+1]}
			a[a.length-1]=r
		}
		return r
	end

	def fibp(x)
		if x.to_i==1 then
			if self==0 then return 0 end
			if self<0 && self%2!=0 then return -(-self).naccip(2,1) end
			return abs.naccip(2,1)
		end
		return naccip(2,x)
	end

	def fib() return fibp(1) end
	def pell() return fibp(2) end
	def tribp(x) return naccip(3,x) end
	def trib() return tribp(1) end
	def tetrap(x) return naccip(4,x) end
	def tetra() return tetrap(1) end
	def nacci(s) return naccip(s,1) end
end

#func
def lucas(a) return a.lucas end
def lucasp(a,x) return a.lucasp(x) end
def padovan(a) return a.padovan end
def perrin(a) return a.perrin end
def padovan2(a,l) return a.padovan(l) end
def nacci(a,s) return a.nacci(s) end
def naccip(a,s,x) return a.naccip(s,x) end

def fib(a) return a.fib end
def fibp(a,x) return a.fibp(x) end
def pell(a) return a.pell end
def trib(a) return a.trib end
def tribp(a,x) return a.tribp(x) end
def tetra(a) return a.tetra end
def tetra(a,x) return a.tetrap(x) end
