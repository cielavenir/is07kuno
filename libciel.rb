module LibCiel
	VERSION='0.0.0.1'
end

module Kernel
	def zip(a) a.shift.zip(*a) end
end

module Enumerable
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

#Make sure to load enumerable/lazy prior, on Ruby 1.9 or below.
#Enumerable::Lazy in Ruby 1.9 (if enumerable/lazy is loaded)
#Enumerator::Lazy in Ruby 2.0+
class Enumerator
	begin
	Lazy.class_eval{
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
	def rotate(count=1)
		count=self.length+count if count<0
		self.slice(self.length-count,count)+self.slice(0,self.length-count)
	end
	def rotate!(count=1) self.replace(self.rotate(count)) end
end

class Hash
	def exists_rec?(a)
		#if a.length<1 then return false
		if !self.include?(a[0]) then return nil end           #if not found
		if a.length==1 then return self[a[0]] end             #if found and last
		if !self[a[0]].is_a?(Hash) then return nil end #if not last and child not hash
		return self[a[0]].exists_rec?(a[1..-1])               #check child
	end
	def patch(par)
		h=self.dup
		par.each{|k,v|h[k]=v}
		return h
	end
end

begin
module DBI
	class << self
		def connect_transaction(driver_url, user=nil, auth=nil, params=nil, &block)
			x=connect(driver_url, user, auth, params)
			begin
				x.transaction(&block)
			ensure
				x.disconnect
			end
		end
	end
	class DatabaseHandle
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
rescue NameError=>e; end