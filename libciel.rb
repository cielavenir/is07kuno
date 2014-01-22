module LibCiel
	#Version string
	VERSION='0.0.0.2'
end

class Object
	#PHPic extract(). Hash will be injected into self as instance variables (@var).
	def extract(h,overwrite=false)
		h.each{|k,v|
			if overwrite || !self.instance_variable_defined?('@'+k) then
				self.instance_variable_set('@'+k,v) #k should always be String
			end
		}
	end
end

module Kernel
	#Pythonic zip. The same as a.shift.zip(*a).
	def zip(a) a.shift.zip(*a) end
end

module Enumerable
	#Squeezes the same element. This behaves like C++ unique().
	#To get the similar result to Array#uniq, you need to sort it prior.
	# Calculation order is O(n).
	def squeeze
		r=[]
		cur=nil
		self.each{|e|
			if r.empty?||cur!=e
				r<<e
				cur=e
			end
		}
		r
	end
end

class Enumerator
	begin
	Lazy.class_eval{
		#Enumerator.Lazy version of Enumerable#squeeze.
		#Enumerator.Lazy is evaluated as Enumerable::Lazy on Ruby 1.9 + enumerable/lazy, otherwise Enumerator::Lazy.
		# To use this method, on Ruby <2.0, you need to require enumerable/lazy or backports before requiring libciel.
		def squeeze
			first=true
			cur=nil
			self.class.new(self){|y,v|
				if first||cur!=v
					y<<v
					first=false
					cur=v
				end
			}
		end
	}
	rescue NameError=>e; end
end

class Array
	#Enumerates permutation of Array.
	#Unlike Array#permutation, there are no duplicates in generated permutations.
	#Instead, elements must be comparable.
	def permutation2(n=self.size)
		return to_enum(:permutation2,n) unless block_given?
		return if n<0||self.size<n
		a=self.sort
		yield a.dup[0,n]
		loop{
			a=a[0,n]+a[n..-1].reverse
			k=(a.size-2).downto(0).find{|i|a[i]<a[i+1]}
			break if !k
			l=(a.size-1).downto(k+1).find{|i|a[k]<a[i]}
			a[k],a[l]=a[l],a[k]
			a=a[0,k+1]+a[k+1..-1].reverse
			yield a.dup[0,n]
		}
	end
end

class String
	#Rotate string to the left with count.
	#Specifying negative number indicates rotation to the right.
	def rotate(count=1)
		count+=self.length if count<0
		self.slice(count,self.length-count)+self.slice(0,count)
	end
	#Destructive version of String#rotate
	def rotate!(count=1) self.replace(self.rotate(count)) end
end

class Hash
	#nil safe version of Hash#[].
	# h.exists_rec?(['hello','world']) is the same as h['hello'].try.send(:[],'world').
	def exists_rec?(a)
		#if a.length<1 then return false
		if !self.include?(a[0]) then return nil end           #if not found
		if a.length==1 then return self[a[0]] end             #if found and last
		if !self[a[0]].is_a?(Hash) then return nil end #if not last and child not hash
		return self[a[0]].exists_rec?(a[1..-1])               #check child
	end
	#Returns self.dup with overwriting par.
	def patch(par)
		h=self.dup
		par.each{|k,v|h[k]=v}
		return h
	end
end

module DBI
	#connect-transaction-disconnect triplet.
	# To use this method, you need to require dbi before requiring libciel.
	def self.connect_transaction(driver_url, user=nil, auth=nil, params=nil, &block)
		x=connect(driver_url, user, auth, params)
		begin
			x.transaction(&block)
		ensure
			x.disconnect
		end
	end

	class DatabaseHandle
		#execute-map,count-finish triplet.
		# To use this method, you need to require dbi before requiring libciel.
		def execute_immediate(stmt,*bindvars,&block)
			sth=execute(stmt,*bindvars)
			ret=0
			begin
				if block then ret=sth.map(&block).count end
			ensure
				sth.finish
			end
			ret
		end
	end
end
