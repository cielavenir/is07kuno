#core.rb
#load this file first.

require 'pathname'
require 'cgi'

def bench(count, &block)
	t = Process.times.utime
	count.times{yield}
	return Process.times.utime-t
end

class Object
	public
	def assureArray
		return self.is_a?(Array) ? self : [self]
	end
	def extract(h,overwrite=false)
		h.each{|k,v|
			if overwrite || !self.instance_variable_defined?('@'+k) then
				self.instance_variable_set('@'+k,v) #k should always be String
			end
		}
	end
end
=begin
#this "function" breaks OO call
def assureArray(x)
	return x.is_a?(Array) ? x : [x]
end
=end

class Integer
	def to_binary_little(b)
		ret=''
		n=self
		b.times{|i|
			ret+=(n&0xff).chr
			n>>=8
		}
		return ret
	end

	def to_binary_big(b)
		ret=''
		n=self
		b.times{|i|
			ret+=( (n>>( 8*((b-1)-i)) )&0xff ).chr
		}
		return ret
	end

	def gcd(x)
		n=self
		if n<x then n,x = x,n end
		if x<=0 then return n end
		while (q=n%x)!=0 do
			n=x;x=q
		end
		return x
	end

	def fact
		ret=1
		2.step(self){|i|ret*=i}
		return ret
	end

	def comb(r)
		if r==0 then return 1 end
		n=self
		ret=1
		if r>n/2 then r=n-r end
		r.times{|i|
			ret=ret*(n-i)/(i+1)
		}
		return ret
	end

	def perm(r)
		if r==0 then return 1 end
		n=self
		ret=1
		r.times{|i|
			ret=ret*(n-i)
		}
		return ret
	end
end

class Numeric
	def sqrt() return Math.sqrt(self) end

	def cbrt
		if rubyversion>=1009000001 then return Math.cbrt(self) end
		return self**(1/3.0)
	end

	def gamma(x=524288) #2**19 #definition
		if rubyversion>=1009000001 then return Math.gamma(self,x) end
		return mygamma(x)
	end

	def mygamma(x=524288)
		#very big error... only consideration.
		r=x.to_f**(self.to_f/2)/self.to_f
		1.step(x){|i|
			r=r*i/(self+i)
		}
		r*=x.to_f**(self.to_f/2)
		return r
	end

	def prime?
		if self<2 then return false end
		if self==2 then return true end
		if self&1==0 then return false end
		3.step(self.sqrt,2){|i|
			if self%i==0 then return false end
		}
	return true
	end

	def radtodeg() return self*180/Math::PI end
	def degtorad() return self*Math::PI/180 end

	def sin() return Math.sin(self) end
	def cos() return Math.cos(self) end
	def tan() return Math.tan(self) end
	def log(x=Math::E) return Math.log(self)/Math.log(x) end
end

class Array
	def sum
=begin
	ret=0
	self.length.times{|i| ret+=self[i]}
	return ret
=end
	self.reduce(&:+)
	end

	def sumfib(x) #used by fib.rb
		return self.length.times.reduce(0){|r,i|r+=self[i]*x**i}
	end

	def average() return self.sum.to_f/self.length end
	def duplicate() return self.uniq.select{|i| self.index(i) != self.rindex(i)} end
=begin
	def squeeze
		if self.length==0 then return [] end
		a=[self[0]]
		1.step(self.length-1){|i| if self[i]!=self[i-1] then a.push(self[i]) end}
		return a
	end
=end
	def squeeze!() self.replace(self.squeeze) end	
end

class String
	def resolve(enc="UTF-8") #must be called if you use regexp for Mechanize::Page#body
		self.force_encoding(enc) if RUBY_VERSION >= '1.9'
		return self
	end
	def uriEncode() CGI.escape(self) end
	def uriDecode() CGI.unescape(self) end
	def realpath()  Pathname(self).realpath.to_s end
	def dirname()   Pathname(self).dirname.to_s end
end

#String.encode for Ruby1.8 http://www.ownway.info/Blog/2011/06/ruby-182-stringencode-1.html
if RUBY_VERSION < '1.9.0' then
	begin
		#raise "You selected to avoid LGPL in any ways"
		require 'iconv' #if iconv is loadable
		class String
			@encoding = nil
			#def set_encoding(encoding)
			#	@encoding = encoding
			#end

			def encode(to_encoding, from_encoding)
=begin
				if from_encoding == nil
					if @encoding == nil
						f_encoding = Kconv::AUTO
					else
						f_encoding = @encoding
					end
				else
					f_encoding = get_kconv_encoding(from_encoding)
				end
=end
				result = Iconv::conv(to_encoding, from_encoding, self)
				#result.set_encoding(to_encoding)
				return result
			end
			def encode!(to_encoding, from_encoding) self.replace(encode(to_encoding, from_encoding)) end
		end
	rescue
		require 'kconv' #fallback to kconv

		class String
			@encoding = nil
			#def set_encoding(encoding)
			#	@encoding = encoding
			#end

			def encoding
				if @encoding != nil
					return @encoding
				else
					case Kconv.guess(self)
						when Kconv::JIS
							return "ISO-2022-JP"
						when Kconv::SJIS
							return "Shift_JIS"
						when Kconv::EUC
							return "EUC-JP"
						when Kconv::ASCII
							return "UTF-8"
							#return "ASCII"
						when Kconv::UTF8
							return "UTF-8"
						#when Kconv::UTF16
						#	return "UTF-16BE"
						when Kconv::UNKNOWN
							return nil
						when Kconv::BINARY
							return nil
						else
							return nil
					end
				end
			end

			#def encode(to_encoding, from_encoding = nil, options = nil)
			def encode(to_encoding, from_encoding)
				if from_encoding == nil
					if @encoding == nil
						f_encoding = Kconv::AUTO
					else
						f_encoding = @encoding
					end
				else
					f_encoding = get_kconv_encoding(from_encoding)
				end

				result = Kconv::kconv(self, get_kconv_encoding(to_encoding), f_encoding)
				#result.set_encoding(to_encoding)
				return result
			end
			def encode!(to_encoding, from_encoding) self.replace(encode(to_encoding, from_encoding)) end

			def get_kconv_encoding(encoding)
				if encoding != nil
					case encoding.upcase
						when "ISO-2022-JP"
							return Kconv::JIS
						when "SJIS"
							return Kconv::SJIS
						when "SHIFT_JIS"
							return Kconv::SJIS
						when "Shift_JIS"
							return Kconv::SJIS
						when "CP932"
							return Kconv::SJIS
						when "WINDOWS-31J"
							return Kconv::SJIS
						when "EUC-JP"
							return Kconv::EUC
						when "ASCII"
							return Kconv::ASCII
						when "UTF-8"
							return Kconv::UTF8
						#when "UTF-16BE"
						#	return Kconv::UTF16
						else
							raise "Unsupported Encoding: You must prepare iconv or use Ruby 1.9."
							#return Kconv::UNKNOWN
					end
				end
			end
		end
	end
end

class Hash
	def to_query
		a=Array.new
		self.each{|k,v|
			v.assureArray.each{|e|
				a.push(k+'='+e.to_s.uriEncode)
			}
		}
		return a.join('&')
	end
end

class CGI
	def to_query
		a=Array.new
		self.params.each{|k,v|
			v.each{|e|
				a.push(k+'='+e.to_s.uriEncode)
			}
		}
		return a.join('&')
	end
	def to_hash
		h={}
		self.params.each{|k,v|
			if v.length==0 then next end
			if v.length==1 then h[k]=v[0];next end
			h[k]=v
		}
		return h
	end
end

#func
def gcd(a,b) return a.gcd(b) end
def fact(a) return a.fact end
#def gamma(a) return a.gamma end
#def mygamma(a) return a.mygamma end
def degtorad(a) return a.degtorad end
def radtodeg(a) return a.radtodeg end
def comb(a,b) return a.comb(b) end
