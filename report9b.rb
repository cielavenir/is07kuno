=begin
t.yamada
071211 2131 Phase1
演習2と演習3abcdeを解答
071231 1201 Phase2
演習4と7を解答、演習3のバグを修正
080101 2352 Phase2a
3項以上をとる演算子/制御構文をほかにも書けるようにIfを拡張
080102 0056 Phase2b
ノード追加
080102 0331 Phase3
Lispに似た不思議な言語が出来上がったので演習9とする。
080102 0414 Phase3a
icpc2007 DomesticAを解かせ、レポート完成とする。
=end

#演習2、ですが、to_sをLisp記法で出力するよう変えてあります。
$vars = {} #演習3以降共通

class Ex92 #後ろと定数名が衝突しないようにする措置

class N
 def initialize(l=nil,r=nil) @left=l; @right=r end
end

class Add < N
	def exec() return @left.exec+@right.exec end
	def to_s() return "(+ #{@left} #{@right})" end
end
class Sub < N
	def exec() return @left.exec-@right.exec end
	def to_s() return "(- #{@left} #{@right})" end
end
class Mul < N
	def exec() return @left.exec*@right.exec end
	def to_s() return "(* #{@left} #{@right})" end
end
class Div < N
	def exec() return @left.exec/@right.exec end
	def to_s() return "(/ #{@left} #{@right})" end
end
class Lit < N
	def exec() return @left end
	def to_s() return @left.to_s end
end
class Var < N
	def exec() return $vars[@left] end
	def to_s() return @left.to_s end
end

#演習2
class Display < N
	def exec i=@left.to_s; puts i; return i end
	def to_s() return "(display #{@left})" end
end
class Input < N
	def exec() return gets.chomp.to_i end
	def to_s() return "(input)" end
end
class Exec < N
	def exec() @left.exec; return @right.exec end
	def to_s() return "(exec #{@left} #{@right})" end
end
class Loop < N
	def exec v=0; @left.exec.times{|i| v=@right.exec}; return v end
	def to_s() return "(loop #{@left} #{@right})" end
end

def test
	$vars["x"]=5
	a=[
		Display.new(Add.new(Var.new("x"),Lit.new(1))),
		Loop.new(Var.new("x"), Display.new(Lit.new(0))),
		Exec.new(Display.new(Lit.new(0)), Input.new)
	]
	a.each{|i| puts(i);puts(i.exec)}
end

end #措置終わり

def test9_2 x=Ex92.new; x.test end

#演習3
class Node
	def initialize(l=nil, r=nil) @left = l; @right = r; @op = "_" end
	def to_s() return "(#{@left}#{@op}#{@right})" end
	def getleft() return @left end
	def getright() return @right end
	def getop() return @op end
end

class Add < Node
	def initialize(l, r) super; @op="+" end
	def exec() return @left.exec+@right.exec end
end
class Sub < Node
	def initialize(l, r) super; @op="-" end
	def exec() return @left.exec-@right.exec end
end
class Mul < Node
	def initialize(l, r) super; @op="*" end
	def exec() return @left.exec*@right.exec end
end
class Div < Node
	def initialize(l, r) super; @op="/" end
	def exec() return @left.exec/@right.exec end
end
class Lit < Node
	def initialize(v) super; @op="#" end
	def exec() return @left end
end
class Var < Node
	def initialize(v) super; @op="$"end
	def exec() return $vars[@left] end
end
class Assign < Node
	def initialize(l, r) super; @op="=" end
	def exec v = @right.exec; $vars[@left.getleft] = v; return v end
end
class Seq < Node
	def initialize(l, r) super; @op=";" end
	def exec() @left.exec; return @right.exec end
end
class Loop < Node
	def initialize(l, r) super; @op="L" end
	def exec v=0; @left.exec.times{v=@right.exec}; return v end
end
class Noop < Node
	def initialize() end
	def exec() return 0 end
	def to_s() return "_" end
end

#大小比較
class Gt < Node
	def initialize(l, r) super; @op=">" end
	def exec() return @left.exec>@right.exec ? 1 : 0 end
end
class Lt < Node
	def initialize(l, r) super; @op="<" end
	def exec() return @left.exec<@right.exec ? 1 : 0 end
end
class Ge < Node
	def initialize(l, r) super; @op=">=" end
	def exec() return @left.exec>=@right.exec ? 1 : 0 end
end
class Le < Node
	def initialize(l, r) super; @op="<=" end
	def exec() return @left.exec<=@right.exec ? 1 : 0 end
end
class Eq < Node
	def initialize(l, r) super; @op="==" end
	def exec() return @left.exec==@right.exec ? 1 : 0 end
end
class Ne < Node
	def initialize(l, r) super; @op="!=" end
	def exec() return @left.exec!=@right.exec ? 1 : 0 end
end

#条件分岐、繰り返し
class While < Node
	def initialize(l, r) super; @op="W" end
	def exec v=0; while @left.exec!=0 do v=@right.exec end; return v end
end
class If < Node
	def initialize(l, r) super; @op="?" end
	def exec() if @left.exec!=0 then return @right.getleft.exec else @right.getright.exec end end
end

#絶対値など
class Abs < Node
	def initialize(v) super; @op="|"end
	def exec() return @left.exec.abs end
end
class Max < Node
	def initialize(l, r) super; @op="M" end
	def exec _l=@left.exec; _r=@right.exec; if _l<_r then _l=_r end; return _l end #asm風味
end
class Min < Node
	def initialize(l, r) super; @op="m" end
	def exec _l=@left.exec; _r=@right.exec; if _l>_r then _l=_r end; return _l end #asm風味
end

#必要なもの
class Modulo < Node
	def initialize(l, r) super; @op="%" end
	def exec() return @left.exec%@right.exec end
end
class Power < Node
	def initialize(l, r) super; @op="**" end
	def exec() return @left.exec**@right.exec end
end
class ExNode < Node #3項以上必要な演算子の区切りとして使用
	def initialize(l, r) super; @op=":" end
end
class And < Node
	def initialize(l, r) super; @op="&&" end
	def exec() return (l=@left.exec)!=0 ? @right.exec : l end #&&演算子がうまく動かないので自前で短絡を実装
end
class Or < Node
	def initialize(l, r) super; @op="||" end
	def exec() return @left.exec==0 ? 0 : @right.exec end #||演算子(以下略)
end
class Gcd < Node
	def initialize(l, r) super; @op="g" end
	def exec() return gcd(@left.exec, @right.exec) end
end
class Print < Node
	def initialize(v) super; @op="\\"end
	def exec() v=@left.exec; puts v; return v end
end
class Exec < Node
	def initialize(l, r) super; @op="," end
	def exec() @left.exec; return @right.exec end
end
class LSh < Node
	def initialize(l, r) super; @op="<<" end
	def exec() return (@left.exec)<<(@right.exec) end
end
class RSh < Node
	def initialize(l, r) super; @op=">>" end
	def exec() return (@left.exec)>>(@right.exec) end
end
class Input < Node
	def initialize() @op="I" end
	def exec() return gets.chomp.to_i end
end

#演習4
#制限つき。変数名は英小文字(+数字)、英小文字+数字/英大文字/記号でしか区切れません。
#mやgといった演算子を使うには直前のfactorが英小文字以外で終わるかスペースを空ける必要があります。
class Scanner #String or IO.read("path")
	def initialize(s) @str = "$"+s+"$"; @pos1=@pos2=0; self.next; end
	def peek() return @str[@pos1..@pos2] end
	def to_s
		s=""
		if @pos2 < @str.length then s=@str[@pos2+1..-1] end
		@str[@pos2+1..-1]
		return @str[0..@pos1-1] + "{" + peek + "}" + s
	end
	def next()
		if @pos2 >= @str.length then return end #EOS
		@pos2+=1
		while @pos2 < @str.length && @str[@pos2..@pos2] =~ /[\s]/  do @pos2+=1 end
		@pos1=@pos2
		if @pos2 >= @str.length then return end #EOS
		if @str[@pos1..@pos1] =~ /[0-9a-z]/ then
			while @str[@pos2..@pos2] =~ /[0-9a-z]/ && @str[@pos2..@pos2] =~ /[^\s]/ && @pos2 < @str.length do @pos2+=1 end
			@pos2-=1
		elsif @str[@pos1..@pos1] =~ /[A-Z]/ then
			while @str[@pos2..@pos2] =~ /[A-Z]/ && @str[@pos2..@pos2] =~ /[^\s]/ && @pos2 < @str.length do @pos2+=1 end
			@pos2-=1
		else
			#付け焼刃。(){};のあとに何か付け足して新たな構文を作る必要はないですよね^^;あと単項演算子の\と|。
			if @str[@pos2..@pos2] =~ /[\(\)\{\}\\|\\;]/ then return end
			while @str[@pos2..@pos2] =~ /[^0-9a-zA-Z\s\(\)\{\}\\|\\;]/ && @pos2 < @str.length do @pos2+=1 end
			@pos2-=1
		end
	end
end

#演習7、としようと思いましたが言語仕様が原形をとどめていないため演習9といたします。
def prog(sc) return expr(sc) end

def factor(sc)
	c = sc.peek; sc.next
	if c[0..0] >= "a" && c[0..0] <= "z" then return Var.new(c)
	elsif c[0..0] >= "0" && c[0..0] <= "9" then return Lit.new(c.to_i)
	end

	case c
		when "("
			e = expr(sc)
			if sc.peek != ")" then puts "NO_): #{sc}"; return Noop.new end
			sc.next; return e
		when "_" then return Noop.new
		when "I" then return Input.new
		else puts "FACTOR: #{sc}"; return Noop.new
	end
end

#-----#
def expr(sc)
	#右側(閉じ括弧or;)にある全てのrightの結果が得られるまでノードは値を返さないので、左から処理するには括弧を多用するしかありません。
	e = factor(sc)
	case sc.peek
		#以下演算子を追加
		when "+" then  sc.next; return Add.new(e, expr(sc))
		when "-" then  sc.next; return Sub.new(e, expr(sc))
		when "*" then  sc.next; return Mul.new(e, expr(sc))
		when "/" then  sc.next; return Div.new(e, expr(sc))
		when "=" then  sc.next; return Assign.new(e, expr(sc))
		when "%" then  sc.next; return Modulo.new(e, expr(sc))
		when "**" then sc.next; return Power.new(e, expr(sc))
		when "M" then  sc.next; return Max.new(e, expr(sc))
		when "m" then  sc.next; return Min.new(e, expr(sc))
		when "g" then  sc.next; return Gcd.new(e, expr(sc))
		when "," then  sc.next; return Exec.new(e, expr(sc))
		when "<<" then sc.next; return LSh.new(e, expr(sc))
		when ">>" then sc.next; return RSh.new(e, expr(sc))

		when "==" then sc.next; return Eq.new(e, expr(sc))
		when "!=" then sc.next; return Ne.new(e, expr(sc))
		when ">" then  sc.next; return Gt.new(e, expr(sc))
		when "<" then  sc.next; return Lt.new(e, expr(sc))
		when ">=" then sc.next; return Ge.new(e, expr(sc))
		when "<=" then sc.next; return Le.new(e, expr(sc))

		when "&&" then sc.next; return And.new(e, expr(sc))
		when "||" then sc.next; return Or.new(e, expr(sc))

		when "|" then  sc.next; return Abs.new(e)
		when "\\" then sc.next; return Print.new(e)

		when "L" then  sc.next; return Loop.new(e, expr(sc))
		when "W" then  sc.next; return While.new(e, expr(sc))
		when "?" then  sc.next; return If.new(e, ExNode.new(expr(sc), Noop.new))
		when "??" then sc.next; return If.new(e, ExNode.new(expr(sc), expr(sc)))
		else return e
	end
end

#-----#
def test9_7
	e = prog(Scanner.new(IO.read("report9b.in")))
	puts(e)
	puts(e.exec)
end

=begin
・BNFは以下のようにしました。
(prog ::= expr)
expr ::= factor |
				 factor "," expr | #連続。この言語仕様には欠かせない代物。
				 factor "+" expr | factor "-" expr | factor "*" expr | factor "/" expr | #加減乗除
				 factor "=" expr | #代入
				 factor "%" expr | factor "**" expr | #剰余、累乗
				 factor "M" expr | factor "m" expr | #最大、最小
				 factor "g" expr | #Gcd
				 factor "<<" expr | factor ">>" expr | #左シフト、右シフト
				 factor "==" expr | factor "!=" expr | factor ">" expr | factor "<" expr | factor ">=" expr | factor "<=" expr | #比較
				 factor "&&" expr | factor "||" expr | #and/or
				 factor "|" | factor "\" expr | #絶対値/puts
				 factor "L" expr | factor "W" expr | factor "?" expr | factor "??" expr expr | #ループ/while/if/if...else
factor ::= identfier | number | "(" expr ")" | "_" | "I" #Noop/input

・{}は不要になったので、peekの場所を示すようにしました。

・report9b.inを以下のようにしてテストしました。
[Case1]
((n=5),(x=1),
 5L((x=x*n),(n=n-1)),
 x)

(((n$)=(5#));(((x$)=(1#));(((5#)L(((x$)=((x$)*(n$)));((n$)=((n$)-(1#)))));(x$))))
120

[Case2]
((x0=5),(p=0),(p=p-8),(x0**p|))

(((x0$)=(5#));(((p$)=(0#));(((p$)=((p$)-(8#)));((x0$)**((p$)|)))))
390625

[Case3]※条件式は特に意味はなくデバッグ用です。
((n=5),(x=1),
 ((x!=25)&&(x!=0))W((x\),(x=x*n)),
 x)

(((n$)=(5#));(((x$)=(1#));(((((x$)!=(25#))&&((x$)!=(0#)))W(((x$)\);((x$)=((x$)*(n$)))));(x$))))
1
5
25

[Case4]
((n=5),(x=1),
 (x!=25)?((x\),(x=x*n)),
 x)

(((n$)=(5#));(((x$)=(1#));((((x$)!=(25#))?((((x$)\),((x$)=((x$)*(n$)))):_));(x$))))
1
5

[Case5]
((n=3),(x=6),
 (n+1) g x)

(((n$)=(3#)),(((x$)=(6#)),(((n$)+(1#))g(x$))))
4

・問題点:Gt.newの第二引数をfactorにしてしまうと、5>3+1といった式を評価できない。逆にexprにしてしまうと5>3+1<6といった式も評価してしまう。
現状exprにして、意味解析は自前でやるしかないでしょうか。。。
・LCM(x,y)==((x*y)/(x g y))

・いろいろ試行錯誤し、&&や||をexprにしてみようなどとしていくうちに、WやLまで真ん中に来てしまいこういう言語が出来上がりました。
動詞を真ん中に置いたLispみたいなもんでしょうか。
WhileやIfが真ん中にある言語はかなり珍しい部類に入ると思います^^;
#こういう構造にしたのでWhileやIfも演算子として書けてしまうのであります。

…。これだけでは面白くないので、http://acm.pku.edu.cn/JudgeOnline/problem?id=3325(ICPC2007国内予選A)でも解かせて見ましょう。
[Case6]
((n=I),
 (n!=0)W(
	(ma=0),(mi=1000),(sum=0),
	(nL((x=I),(ma=maMx),(mi=mi m x),(sum=sum+x))),
	((((sum-ma)-mi)/(n-2))\),
	(n=I)))

(((n$)=(I)),(((n$)!=(0#))W(((ma$)=(0#)),(((mi$)=(1000#)),(((sum$)=(0#)),(((n$)L(((x$)=(I)),(((ma$)=((ma$)M(x$))),(((mi$)=((mi$)m(x$))),((sum$)=((sum$)+(x$))))))),((((((sum$)-(ma$))-(mi$))/((n$)-(2#)))\),((n$)=(I)))))))))
となり、入出力も一致しており確かに解けている。
#sum-ma-miさえ括弧を入れる必要があるのは残念ですが^^;

[Case7] #一応elseの確認
((n=3),
 (n==1)??(0)((n==2)??(0)(n)))

(((n$)=(3#)),(((n$)==(1#))?((0#):(((n$)==(2#))?((0#):(n$))))))
3
=end

=begin
アンケート回答
Q1. わかりました。
Q2. 今回の演習9みたいな不思議な言語なら。
Q3. 面白かったです。時間があればさらに拡張してみたいです。
=end
