=begin
t.yamada
Solved: 071130 2107
=end

#演習3
class Dog
	def initialize(name)
		@name = name
		@speed = 0.0
		@barkcount = 3
	end
	def talk
		puts "My name is #{@name}"
	end
	def addspeed(d)
		@speed = @speed + d
		puts "speed = #{@speed}"
	end
	def setcount(c)
		@barkcount = c
	end
	def bark
		@barkcount.times{
			print 'Bow'
		}
		puts
	end
end
#すみません、どうしようもないサンプルなのでコメントできないです…

#演習6(兼前回の演習5)
#------------------------# 改造丁半
class DiceRoller
	def roll(v, c)
		ret=0
		c.times{
			ret=1+rand(v)
		}
		return ret
	end

	def play(m)
		puts "DiceRoller r071129"
		while m>0 do
			puts "Now you have $#{m}. How much do you bet? (0 to exit)"
			b=gets.to_i
			if b==0 then break end
			while b>m do
				if b==0 then break end
				puts "You cannot bet so much."
				b=gets.to_i
			end
			m-=b
			puts "Plaese input the rate."
			r=gets.to_i
			while r<2 || 100<r do
				puts "Please input an integer between 2 and 100."
				r=gets.to_i
			end
			puts "What remainder do you bet for? (0-#{r-1})"
			f=gets.to_i
			while f>=r do
				puts "Please input an integer between 0 and #{r-1}."
				f=gets.to_i
			end

			v0=r+rand(1000)
			v=v0-v0%r #ダイスの目の数はrの倍数になるようにする
			c=1+rand(1000)
			print "Now, #{v}d#{c} is "
			result=roll(v,c)
			puts "#{result}. The remainder is #{result%r}."

			if result % r == f then
				puts "You win!"
				m+=b*r
			else
				puts "You lose..."
			end
		end
		return m
	end
end

#Register
class Games
	def diceroller(m)
		if m==0 then return "DiceRoller: advanced cho-han" end
		x=DiceRoller.new
		return x.play(m)
	end
end

#------------------------# 大小
#実装されている役:
#大小、偶奇、ぞろ目、2つの目(同じ/コンビネーション)、1つの目、合計数
class BigSmall
	def cl(dices,bet,num,num2) #Δm判定
		#まず、ぞろ目を判定する
		if dices[0]==dices[1] && dices[0]==dices[2] then
			if bet==0 || bet==1 || bet==4 then return 0 end
			if bet==5 then
				if num==0 then return 31 end
				return 181
			end
		end
		case bet
			when 0 then
				sum = dices[0]+dices[1]+dices[2]
				if (num==0&&sum<=10)||(num==1&&sum>=11) then return 2 end
				return 0
			when 1 then
				sum = dices[0]+dices[1]+dices[2]
				if (num==0&&sum%2==1)||(num==1&&sum%2==0) then return 2 end
				return 0
			when 2 then
				ary = Array.new(7,0)
				3.times{|i|
					ary[dices[i]]+=1
				}
				if ary[num]==0 then return 0 end
				return ary[num]+1
			when 3 then
				ary = Array.new(7,0)
				3.times{|i|
					ary[dices[i]]+=1
				}
				#修正
				if num==num2 && ary[num]>1 then return 11 end
				if num!=num2 && ary[num]!=0 && ary[num2]!=0 then return 7 end
				return 0
			when 4 then
				sum = dices[0]+dices[1]+dices[2]
				if num!=sum then return 0 end
				case num
					when 4, 17 then return 61
					when 5, 16 then return 31
					when 6, 15 then return 19
					when 7, 14 then return 13
					when 8, 13 then return 9
					when 9, 12 then return 8
					when 10, 11 then return 7
				end
			else return 0 #bet==5 and no zoro-me -> die!
		end
	end

	def play(m)
		puts "BigSmall r071130"
		while m>0 do
			puts "Now you have $#{m}. How much do you bet? (0 to exit)"
			b=gets.to_i
			if b==0 then break end
			while b>m do
				if b==0 then break end
				puts "You cannot bet so much."
				b=gets.to_i
			end
			m-=b

			#roll
			dices = []
			3.times{|i|
				rand(20).times{rand()}
				dices.push(1+rand(6))
			}
			dices.sort!

			print <<EOM
Now, what do you bet for?
0: big or small
1: odd or even
2: single number
3: double number
4: total
5: triple
EOM
			r=gets.to_i
			while r<0 || 5<r do
				puts "Please input an integer between 0 and 5."
				r=gets.to_i
			end

			case r
				when 0 then
					puts "Which do you bet? 0:small 1:big"
					num=gets.to_i
					while num<0 || 1<num do
						puts "Please input 0 or 1."
						num=gets.to_i
					end
				when 1 then
					puts "Which do you bet? 0:odd 1:even"
					num=gets.to_i
					while num<0 || 1<num do
						puts "Please input 0 or 1."
						num=gets.to_i
					end
				when 2 then
					puts "What number do you bet?"
					num=gets.to_i
					while num<1 || 6<num do
						puts "Please input between 1 and 6."
						num=gets.to_i
					end
				when 3 then
					puts "What numbers do you bet? Input like 11."
					num=gets.to_i
					num2=num%10
					num/=10
					while num<1 || 6<num || num2<1 || 6<num do
						puts "Please input two correct numbers."
						num=gets.to_i
						num2=num%10
						num/=10
					end
				when 4 then
					puts "What number do you bet?"
					num=gets.to_i
					while num<4 || 17<num do
						puts "Please input between 4 and 17."
						num=gets.to_i
					end
				when 5 then
					puts "What number do you bet? (0:any)"
					num=gets.to_i
					while num<0 || 6<num do
						puts "Please input between 0 and 6."
						num=gets.to_i
					end
			end

			puts "The dices were rolled: #{dices[0]} #{dices[1]} #{dices[2]}"
			dm = cl(dices,r,num,num2)
			if dm==0 then
				puts "You lose..."
				next
			end
			puts "You win! (rate: #{dm})"
			m+=b*dm
		end
		return m
	end
end

#Register
class Games
	def bigsmall(m)
		if m==0 then return "Big and Small: what they call dai-sho" end
		x=BigSmall.new
		return x.play(m)
	end
end

#------------------------# Help
class Games
	def help(m)
		if m==0 then return "Show detailed help" end
		print <<EOM
Play games to earn as much as money you can!

Games can be added by adding functions in Games class.
In the function, an integer m is passed. 
If m>0, it means the amount of money. So return new amount.
If m==0, return a short description.

You can use this code in any purposes and condition.
About plugins, please ask the authors :)
EOM
	return m
	end
end

#------------------------# 本体
def game#(m=1000) #if you don't set m, 1000 will be used #やっぱり開始時に自由に設定できてしまうのは問題かなぁ。
	m=1000
	a=Games.instance_methods(false).sort
	x=Games.new
	puts "Game Libraries r071130"
	while true do
		print <<EOM
----------
Now you have $#{m}. What game do you want to play? We have:
EOM
		a.each{|s|
			puts "#{s}\n --- "+eval("x.#{s}(0)")
		}
		puts 'To quit, input "exit".'
		g=gets.chomp #getsはLFを含む。
		while ! a.include?(g) do
			if g=="exit" then #rubyにはgotoがないのでここに終了処理^^; 読みにくさ120%
				print <<EOM
----------
You got #{m} dollors!
EOM
				return
			end
			puts "We don't have such a game. Plaese re-input."
			g=gets.chomp
		end
		system "clear"
		m = eval "x.#{g}(m)"
		if m<=0 then
			print <<EOM
----------
No more money to play games! Good luck in next time!
EOM
			return
		end
	end
end

=begin
前回ゲーム出さなかったので今回^^;
複数のゲーム間でお金を共有できます。
さらになんと、Gamesクラスに関数を加えることで自分のゲームを追加できます(現在遊べるゲームはGamesクラスの中を検索して表示します)。
#もちろん他のゲームである程度稼がないと遊べないようにするのも可能です…
#Rubyでは別のところに定義を書き加えることができるためこういうことができます^^;

#本当はファイルを検索する処理(Dir/FileTest)も必要ですが、提出がファイルではなくテキスト埋め込みであることですし、まあ…

とりあえず、
改造丁半(偶奇に賭けるのでは面白くないので任意の数で割った余りに賭けられるように/ダイス式を毎回変える)
大小
をご用意いたしました。

#誤って比較に=を用いてしまったり…経験あってもやっちゃうんですよね。これって。
=end

#お金を貯めると特典…をつけようかとも思いましたが、
#Rubyはスクリプト言語であることと、レポートの長さがあるので…
#やるなら
class Games
	def prize_turtle(m)
		if m==0 then return "Get a lissajous turtle picture for $2000!" end
		if m<2000 then
			puts "Please pay $2000!"
			return m
		end
		puts "Writing turtle.bmp..."
		turtle #Report 4b
		return m-2000
	end
end
#とかでしょうが…
#一般にゲームのソースが非公開なのは隠し要素があるからなんですよね^^;

#※大小のダブル判定にバグがあったので修正しました。
