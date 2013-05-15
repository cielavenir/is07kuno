#Q1 (i) 5 (ii) 4 (iii) 0
def alignment_(x, y)
	#initialize
	a = Array.new(x.length+1){Array.new(y.length+1, 0)}
	back = Array.new(x.length+1){Array.new(y.length+1, 0)}
	tx = ""; ty = ""; t=""

	#DP
	1.step(a.length-1){|i| a[i][0] = a[i-1][0] - 2;back[i][0]=[i-1,0,  "a"]}
	1.step(a[0].length-1){|j| a[0][j] = a[0][j-1] - 2;back[0][j]=[0,  j-1,"b"]}
	1.step(a.length-1){|i|
		1.step(a[0].length-1){|j|
			z = maximum3([x[i-1] == y[j-1] ? a[i-1][j-1]+1 : a[i-1][j-1]-1, a[i-1][j]-2, a[i][j-1]-2]) #Q3: (c)
			a[i][j]=z[0];
			case z[1]
				when 0 then back[i][j]=[i-1,j-1,"c"]
				when 1 then back[i][j]=[i-1,j,  "a"]
				when 2 then back[i][j]=[i,  j-1,"b"]
			end
		}
	}
	a.each{|e|p e}
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
=begin
Q2
alignment_('ATGCGACTTG','TTGCGCTTGG')
seq1: ATGCG, seq2: TTGCG, score: 2
Q4
 3  1 -1 -3 -5 -7
 1  2  0 -2 -4 -6
-1  2  1 -1 -3 -5
-3  0  3  2  0 -2
-5 -2  1  4  2  0
-7 -4 -1  2  5  3
score: 3
Q5
ATGCGACTT-G
 |||| ||| |
TTGCG-CTTGG
Q6
スコアが負になった時点で計算を打ち止める
Q7
=end
def alignment_2(x, y)
	#initialize
	a = Array.new(x.length+1){Array.new(y.length+1, 0)}
	back = Array.new(x.length+1){Array.new(y.length+1, 0)}
	tx = ""; ty = ""; t=""

	#DP
	1.step(a.length-1){|i| a[i][0] = a[i-1][0] - 0;back[i][0]=[i-1,0,  "a"]}
	1.step(a[0].length-1){|j| a[0][j] = a[0][j-1] - 0;back[0][j]=[0,  j-1,"b"]}
	1.step(a.length-1){|i|
		1.step(a[0].length-1){|j|
			z = maximum3([x[i-1] == y[j-1] ? a[i-1][j-1]+1 : a[i-1][j-1]-1, a[i-1][j]-2, a[i][j-1]-2])
			a[i][j]=z[0];
			if a[i][j]>0
				case z[1]
					when 0 then back[i][j]=[i-1,j-1,"c"]
					when 1 then back[i][j]=[i-1,j,  "a"]
					when 2 then back[i][j]=[i,  j-1,"b"]
				end
			else
				a[i][j]=0
			end
		}
	}
	a.each{|e|p e}

	return a[x.length][y.length]
end
=begin
alignment_2('ATGCGACTTG','TTGCGCTTGG')
(1)
0 3 1 2 0 0 0 1
1 1 4 2 1 0 1 1
0 0 2 3 1 0 0 0
0 1 0 3 2 0 0 0
0 0 0 1 4 3 1 0
0 0 0 0 2 5 3 1
3 1 1 0 0 3 6 4
(2)
TTG
|||
TTG
TGCGACTTG
|||| ||||
TGCG-CTTG
=end