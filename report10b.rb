###Report 10B

=begin
t.yamada
071218 1949 Phase1
演習2,5abc,6abcを解答
071218 2013 Phase1a
演習6の図を示した(beta)
071224 1359 Phase1b
accept()でeach_byteを使うようにした
071231 0949 Phase2
演習5,6において、受け入れる文字列を正規表現で記述した
080115 2351 Phase2a
演習6aのバグおよび6a、6cの正規表現を修正

###To execute *.mtn, obtain AutoSim.jar from semester1/Information/lecture/automaton00-12.zip
=end

#演習2
class Queue1
	def initialize(n=100)
		@arr = Array.new(n); @count = 0; @iptr = -1; @optr = 0
	end
	def isempty() return @count <= 0 end
	def enq(x)
		if @count + 1 >= @arr.length then return end
		@iptr = (@iptr+1)%@arr.length; @arr[@iptr] = x;
		@count += 1
	end
	def deq
		if @count <= 0 then return end
		x = @arr[@optr]; @count -= 1
		@optr = (@optr+1)%@arr.length; return x
	end
end

class Queue2
	Cell = Struct.new(:data, :next) unless defined? Cell
	def initialize
		@head = Cell.new('', nil)
		@tail = Cell.new('', nil)
		@head.next = @tail
		end
	def isempty() return @head.next==@tail end
	def enq(x)
		@tail.data = x; @tail.next = Cell.new('', nil); @tail = @tail.next end
	def deq
		if isempty then return nil end
		x = @head.next.data; @head.next = @head.next.next; return x
	end
end
	
def test2(que)
	while true do
		printf('> ')
		s = gets.chomp
		if s == 'q' then return
		elsif s == '' then puts(que.deq)
		else que.enq(s)
		end
	end
end

#キューについては動的データ構造を用いた方が非常にきれいに書けることが分かる。

#演習5,6
#6の図については、情報の授業で扱った
#http://lecture.ecc.u-tokyo.ac.jp/johzu/joho/automaton/
#により示します(/home04/g750407/usr/is07kuno/report10b_6[abc].mtn)。
#(同フォルダにあるAutoSim.jarは7za a -tzip -mx=9でサイズを減らした版です)
#
#と思いましたが、AAで…ですか。まあ演習2と5があるのでご勘弁ください(ぇ
def accept(s,atm)
	cur = 0
	s.each_byte{|c|
		cur = atm[cur][c.chr];
		if cur == nil then return false end
	}
	return atm[cur][:final] == true
end

#例題
$atmex = [
	{"a" => 1},
	{"b" => 0, :final => true}
]

=begin
/(ab)*a/
accept("aba",$atmex) => true
accept("ababa",$atmex) => true
accept("ab",$atmex) => false
accept("abba",$atmex) => false
=end

#5a
$atm5a = [
	{"a" => 0, "b" => 1},
	{"a" => 1, :final => true}
]

=begin
/a*ba*/
accept("b",$atm5a) => true
accept("aaaab",$atm5a) => true
accept("aaaaa",$atm5a) => false
accept("aaaabb",$atm5a) => false
accept("aabaa",$atm5a) => true
accept("aabbaa",$atm5a) => false
=end

#5b
$atm5b = [
	{"a" => 1},
	{"b" => 0, "a" => 2, :final => true},
	{"a" => 1}
]

=begin
/a(aa|ba)*/
accept("a",$atm5b) => true
accept("b",$atm5b) => false
accept("aa",$atm5b) => false
accept("aab",$atm5b) => false
accept("aaa",$atm5b) => true
accept("aba",$atm5b) => true
=end

#5c
$atm5c = [
	{"a" => 1},
	{"b" => 2, :final => true},
	{"b" => 3},
	{"a" => 0, :final => true}
]

=begin
/a(bbaa)*(bb)?/
accept("a",$atm5c) => true
accept("abb",$atm5c) => true
accept("abbaa",$atm5c) => true
accept("abab",$atm5c) => false
=end

#6a
$atm6a = [
	{"a" => 1},
	{"a" => 1, "b" => 2},
	{:final => true}
]

=begin
/a+b/
accept("aaaab",$atm6a) => true
accept("aaaaa",$atm6a) => false
accept("aaaba",$atm6a) => false
=end

#6b
$atm6b = [
	{"a" => 1, "b" => 0, :final => true},
	{"a" => 2, "b" => 0, :final => true},
	{"b" => 0, :final => true}
]

=begin
/b*(a{0,2}b)*a{0,2}b?/
accept("bbba",$atm6b) => true
accept("aabaabaa",$atm6b) => true
accept("aabaabaaa",$atm6b) => false
=end

#6c
$atm6c = [
	{"a" => 1, "b" => 0, :final => true},
	{"a" => 0, "b" => 1}
]

=begin
/b*(ab*ab*)*/
accept("aaabbbbabbab",$atm6c) => false
accept("aaabbbbabbaab",$atm6c) => true
=end

#演習9: できませんでしたm(_ _)m
