###Report 8A

#演習1
class Buffer
	Cell = Struct.new(:data, :next) unless defined? Cell
	def initialize
		@tail = @cur = Cell.new("EOF", nil)
		@head = @prev = Cell.new("", @cur)
	end
	def end?
		return @cur == @tail
	end
	def top
		@prev = @head; @cur = @head.next
	end
	def forward
		if end? then return end
		@prev = @cur; @cur = @cur.next
	end
	def insert(s)
		@prev.next = Cell.new(s, @cur); @prev = @prev.next
	end
	def subst(str)
		if end? then return end
		a = str.split('/')
		@cur.data[Regexp.new(a[1])] = a[2]
	end
	def read(file)
		File.open(file, "rb"){|f|
			f.each{|s| insert(s)}
		}
		top
	end
	def save(file)
		top
		File.open(file, "wb"){|f|
			while !end? do f.puts(@cur.data); forward end
		}
	end

	#------------------------------#
	def delete
		if end? then return end
		@prev.next = @cur.next; @cur = @cur.next
	end
	def exchange #頭の中がこんがらがって来たので変数多用^^;
		tmp1=@cur
		tmp2=@cur.next
		tmp3=@cur.next.next
		@prev.next=tmp2
		tmp2.next=tmp1
		tmp1.next=tmp3
		@cur=tmp2
	end
	def backward
		tmp=@cur
		top
		while @cur.next!=tmp do forward end
	end
	def reverse
=begin
	1-2 @2-3  3-4  4-5 .5-nil
	1-2 .2-5 @3-4  4-5  5-nil
	1-2  2-5 .3-2 @4-5  5-nil
	1-2  2-5  3-2 .4-3 @5-nil
	1-4  2-5  3-2 .4-3 @5-nil
=end
		top
		last=@tail
		cur=@cur
		tmp=cur.next
		while cur != @tail do
			cur.next=last
			last=cur
			cur=tmp
			tmp=cur.next
		end
		@head.next=last
		top
	end

	#------------------------------#
	def print(l=1)
		tmp=@cur
		l.times{|i|
			puts(" " + tmp.data)
			tmp=tmp.next
			if !tmp then break end
		}
	end
	def rewrite(s)
		@cur.data = s
	end
	def add(s="")
		forward
		tmp = Cell.new(s, @cur);
		@cur = tmp
		@prev.next = @cur
	end
	def goto(l)
		top
		(l-1).times{|i| forward}
	end
	def clear
		system "clear"
	end
end

###Report 8B

#演習2
#クラスについてはReport 8Aで下準備をしておいたので省略^^;
def edit
	e = Buffer.new
	while true do
		printf(">")
		line = gets.chomp
		case line[0..0]
			when "q" then return
			when "t" then e.top; e.print
			when "i" then e.insert(line[1..-1])
			when "l" then e.read(line[1..-1])
			when "w" then e.save(line[1..-1])
			when "s" then e.subst(line[1..-1]); e.print
			#-----#
			when "d" then e.delete
			when "b" then e.backward; e.print
			when "v" then e.reverse
			when "a" then e.add(line[1..-1])
			when "r" then e.rewrite(line[1..-1])
			when "g" then e.goto(line[1..-1].to_i)
			when "p" then i=line[1..-1].to_i; e.print(i==0?1:i)
			when "c" then e.clear
			when "h" then print <<EOM
Help:
q:Quit t:Top i:Insert l:read(Load) w:save(Write) s:Subst d:Delete
b:Backward f:Forward v.reVerse a:Add r:Rewrite g:Goto p:Print c:Clear h:Help
EOM
			when "f" then e.forward; e.print
			else e.forward; e.print
		end
	end
end

#演習6
def benchtable(count1, count2, range, tbl)
	bench(count1){tbl.put(rand(range), "a")}
	bench(count2){tbl.get(rand(range))}
end

class IntStrTable
	Entry = Struct.new(:key, :val) unless defined? Entry
	def initialize() @arr = [] end
	def put(key, val)
		@arr.length.times{|i|
			if @arr[i].key == key then @arr[i].val = val; return end
		}
		@arr.push(Entry.new(key, val))
	end
	def get(key)
		@arr.length.times{|i|
			if @arr[i].key == key then return @arr[i].val end
		}
		return nil
	end
end

class IntStrTable2
	Entry = Struct.new(:key, :val) unless defined? Entry
	def initialize() @arr = [] end
	def put(key, val)
		@arr.length.times{|i|
			if key <= @arr[i].key then
				if key ==@arr[i].key then @arr[i].val = val; return end
				@arr.insert(i, Entry.new(key, val)); return
			end
		}
		@arr.push(Entry.new(key, val))
	end
	def get(key) #is06自作解答より引用^^;
		len=@arr.length
		index=0
		while true do
			n=len/2 + index
			if @arr[n].key==key then return @arr[n].val end
			if len==1 then return nil end
			if @arr[n].key<key then #右側
				len=index+len-n-1
				if len==0 then return nil end #len==2で右側に入る場合は配列中に存在し得ない
				index=n+1
			else #左側
				len=len/2 # =n-index
			end
		end
	end
end

=begin
線形探索(IntStrTable)はO(N)、2分探索(IntStrTable2)はO(logN)である。
全体としてかかる時間は、IntStrTableがO(N^2)、IntStrTable2がO(NlogN)である(N個のデータを検索するため)。

benchtable(1000,1000,100000,IntStrTable.new)
1.43
2.85
=> nil
benchtable(2000,2000,100000,IntStrTable.new)
5.72
11.46
=> nil
benchtable(3000,3000,100000,IntStrTable.new)
13.03
25.84

benchtable(1000,1000,100000,IntStrTable2.new)
0.719999999999999
0.0799999999999983
=> nil
benchtable(2000,2000,100000,IntStrTable2.new)
2.84
0.179999999999993
=> nil
benchtable(3000,3000,100000,IntStrTable2.new)
6.64
0.290000000000006
=> nil

予想通り劇的な速度向上が見られた(1000個のデータを検索するのには10回しかかからない)。
挿入速度が改善されたのはおそらく最後まで検索せずに挿入できているからであろう(となるとRubyの配列の実装はCなどとは大幅に違うことになるが)。
=end

###Report 9A
#演習1
$vars = {}

class Ex91 #後ろと定数名が衝突しないようにする措置

class N
 def initialize(l=nil,r=nil) @left=l; @right=r end
end

class Add < N
	def exec() return @left.exec+@right.exec end
	def to_s() return "(#{@left} + #{@right})" end
end
class Sub < N
	def exec() return @left.exec-@right.exec end
	def to_s() return "(#{@left} - #{@right})" end
end
class Mul < N
	def exec() return @left.exec*@right.exec end
	def to_s() return "(#{@left} * #{@right})" end
end
class Div < N
	def exec() return @left.exec/@right.exec end
	def to_s() return "(#{@left} / #{@right})" end
end
class Lit < N
	def exec() return @left end
	def to_s() return @left.to_s end
end
class Var < N
	def exec() return $vars[@left] end
	def to_s() return @left.to_s end
end

def test
	$vars["x"] = 9
	a = [# (lisp記法)
			Sub.new(Var.new("x"), Lit.new(1)), # (- x 1)
			Sub.new(Var.new("x"), Div.new(Lit.new(5), Lit.new(2.0))), # (- x (/ 5 2.0)) <= x-5/2.0
			Div.new(Sub.new(Var.new("x"), Lit.new(5)), Lit.new(2.0))  # (/ (- x 5) 2.0) => (x-5)/2.0
	]
	a.each{|i| puts(i); puts(i.exec)}
end

end #措置終わり

def test9_1 x=Ex91.new; x.test end

###Report 10A

#演習1
class Stack1
	def initialize(n=100)
		@arr = Array.new(n); @ptr = -1
	end
	def isempty() return @ptr < 0 end
	def push(x)
		if @ptr +1 >= @arr.length then return end
		@ptr += 1; @arr[@ptr] = x
	end
	def pop
		x = @arr[@ptr]; @ptr -= 1; return x
	end
end

class Stack2
	Cell = Struct.new(:data, :next) unless defined? Cell
	def initialize() @cur = @tail = Cell.new("", nil) end
	def isempty() return @cur==@tail end
	def push(x)
		a = Cell.new(x, @cur); @cur=a
	end
	def pop
		if isempty then return nil end
		x = @cur.data; @cur = @cur.next; return x
	end
end

def test1(stk)
	while true do
		printf("> ")
		s = gets.chomp
		if s == "q" then return
		elsif s == "" then puts(stk.pop)
		else stk.push(s)
		end
	end
end

### Report 11A

#演習5
#バイオインフォマティクスは自分が一番興味ある分野だったり。

#第3回演習3再修正版(最大値およびその場所)
def maximum3(a)
	if a.length == 0 then return [nil,0] end
	ret = [a[0],0]
	1.step(a.length-1){|i|
		if ret[0] < a[i] then ret = [a[i],i] end
	}
	return ret
end

def alignment(x, y)
	#initialize
	a = Array.new(x.length+1){Array.new(y.length+1, 0)}
	back = Array.new(x.length+1){Array.new(y.length+1, 0)}
	tx = ""; ty = ""; t=""

	#DP
	1.step(a.length-1){|i| a[i][0] = a[i-1][0] - 2;back[i][0]=[i-1,0,  "a"]}
	1.step(a[0].length-1){|j| a[0][j] = a[0][j-1] - 2;back[0][j]=[0,  j-1,"b"]}
	1.step(a.length-1){|i|
		1.step(a[0].length-1){|j|
			z = maximum3([x[i-1] == y[j-1] ? a[i-1][j-1]+2 : a[i-1][j-1]-1, a[i-1][j]-2, a[i][j-1]-2])
			a[i][j]=z[0];
			case z[1]
				when 0 then back[i][j]=[i-1,j-1,"c"]
				when 1 then back[i][j]=[i-1,j,  "a"]
				when 2 then back[i][j]=[i,  j-1,"b"]
			end
		}
	}

	#trace-back
	n=x.length;m=y.length
	while n!=0||m!=0 do
		t+=back[n][m][2]
		n,m = back[n][m][0],back[n][m][1]
	end
	t.reverse!

	#output
	i=0;j=0
	t.chars{|c|
		case c
			when "c" then tx+=x[i].chr; i+=1; ty+=y[j].chr; j+=1;
			when "a" then tx+=x[i].chr; i+=1; ty+="-";
			when "b" then tx+="-";            ty+=y[j].chr; j+=1;
		end
	}
	puts tx
	puts ty

	return a[x.length][y.length]
end

### Report 12A
def primes(n)
	if n<2 then return end
	print 2
	3.step(n,2){|i|
		if i.prime? then print(" "+i.to_s) end
	}
	puts
end
