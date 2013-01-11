=begin
t.yamada
History... 美術が苦手な私がどこまで迫れるか...
071031 0059 Stage0::Version0
ライブラリを作ってみる。
071031 2115 Stage1::Version1
亀みたくなった。でも足が塗れない。
071101 1829 Stage1::Version2
足をうまく塗ってみる。
071101 2031 Stage2::Version11a1
クオリティが低すぎる…改善策を思案中。
グラデーションを掛けられるようにした。画像を回転できるようにした(buggy)。過激に実行時間Up。
071106 1807 Stage1::Version11
先生に質問の後、提出決定…
071202 1652 Stage1::Version15
Bitmap出力対応。
071204 1329 Stage1::Version16
24bitBitmap出力対応。
080111 1713 Stage2::Version20 #ここから久野氏のサイトにはなし
物理実験6の課題のため、PPMImage.drawlissajousの位相角を変えられるようにした。
080113 1835 Stage2::Version21
左右反転、上下反転機能追加。initializeのバグを修正^^;
080327 2222 Stage2::Version22
モザイクを掛けられるようにした。ただし全体のみ。
080418 0225 Stage2::Version25
ファイル読み込み対応。PPMだけですが。BMPなんかヘッダの種類が多くてやってられねw
まあ、PPMからBMPへのコンバータがほしかった意味もありますが。
080818 1712 Stage2::Version26
絵の一部だけを出力できるようにした。
090625
P3とP6いずれでも出力できるようにした。
=end

#演習4,5
Pixel = Struct.new(:r, :g, :b) unless defined? Pixel

class PPMImage
	include Math

	def initialize(_x,_y=nil)
		if !_y then read(_x)
		elsif _x>0 && _y>0 then
			@x=_x;@y=_y

			#背景塗りはfillrect()をどうぞ。グラデーション掛けるときに回転できますしね。
=begin
			@img = Array.new(@y)
			@y.times{|j|
				@img[j] = Array.new(@x)
				@x.times{|i| @img[j][i] = Pixel.new(255,255,255)}
			}
=end
			@img = Array.new(@y){Array.new(@x){Pixel.new(255,255,255)}}
		end
	end

	###file reader
	def read_controller(s,i)
		case i
			when 0 then @type=s
			when 1 then @x=s.to_i
			when 2 then @y=s.to_i
			when 3
				@m=s.to_i
				#@imgx=Array.new(@x*@y*3)
				@imgx=Array.new
				@img = Array.new(@y)
				@y.times{|j| @img[j] = Array.new(@x)}
		end
	end

	def read(name)
		open(name,"rb"){|f|
			i=0
			f.each{|l|
				if i!=4
					a=l.chomp.split(/\s/)
					a.each{|s|
						if s[0..0]=='#' then break end
						read_controller(s,i)
						if i==0 && @type!="P3" && @type!="P6" then return end
						i+=1
						if i==4 then break end
					}
					next
				end

				if @type=="P3" then
					l.chomp.split(/\s/).each{|x| @imgx.push(x.to_i*255/@m)}
				elsif @type=="P6" then
					l.each_byte{|c| @imgx.push(c*255/@m)}
				end
			}
		}

		0.step(@imgx.length-3,3){|i|
			r=@imgx[i];g=@imgx[i+1];b=@imgx[i+2];j=i/3
			x=j%@x;y=j/@x;
			@img[y][x]=Pixel.new(r,g,b)
		}
		@imgx=nil
		return true
	end

	def write(name)
		writep6(name)
	end

	def writep6(name)
		write2p6(name, 0, 0, @x-1, @y-1)
	end

	def write2(name,x1,y1,x2,y2)
		write2p6(name,x1,y1,x2,y2)
	end

	def write2p6(name,x1,y1,x2,y2)
		if x1>x2 then x1,x2 = x2,x1 end
		if y1>y2 then y1,y2 = y2,y1 end
		open(name,"wb"){|f|
			f.print "P6 #{x2-x1+1} #{y2-y1+1} 255\n"
			y1.step(y2){|j|
				x1.step(x2){|i|
					p = @img[j][i]
					f.print p.r.chr+p.g.chr+p.b.chr
				}
			}
		}
	end

	def writep3(name)
		write2p3(name, 0, 0, @x-1, @y-1)
	end

	def write2p3(name,x1,y1,x2,y2)
		if x1>x2 then x1,x2 = x2,x1 end
		if y1>y2 then y1,y2 = y2,y1 end
		open(name,"wb"){|f|
			f.print "P3 #{@x} #{@y} 255\n"
			y1.step(y2){|j|
				x1.step(x2){|i|
					p = @img[j][i]
					f.print "#{p.r} #{p.g} #{p.b}\n"
				}
			}
		}
	end

	#演習5
	def isinrange(x, y)
		if 0<=x && x<@x && 0<=y && y<@y then return true end
		return false
	end

	#演習4.abc
	def setcolor(x, y, cx, cy, start, finish, d, alpha, rotate)
		theta=PI*rotate/180.0
		sintheta=sin(theta);costheta=cos(theta)
		_x=cx+(costheta*(x-cx)-sintheta*(y-cy))
		_y=cy+(sintheta*(x-cx)+costheta*(y-cy))
		
		if !isinrange(_x,_y) then return end #これをしないと範囲外だったときにnil:NilClassエラーが出ることになる
		if alpha<0.0 || alpha>1.0 then alpha=0.0 end

		r=start.r+(finish.r-start.r)*d
		g=start.g+(finish.g-start.g)*d
		b=start.b+(finish.b-start.b)*d

		@img[_y][_x].r = (alpha*@img[_y][_x].r+(1-alpha)*r.to_i).to_i
		@img[_y][_x].g = (alpha*@img[_y][_x].g+(1-alpha)*g.to_i).to_i
		@img[_y][_x].b = (alpha*@img[_y][_x].b+(1-alpha)*b.to_i).to_i
	end

	#演習4.bd,5
	def fillcircle(x, y, rad, start, finish, _step, alpha, rotate)
		(y-rad).step(y+rad,_step){|j|
			(x-rad).step(x+rad,_step){|i|
				if (i-x)**2 + (j-y)**2 < rad**2 then setcolor(i, j, x, y, start, finish, (i-x+rad)/(rad*2).to_f, alpha, rotate) end
			}
		}
	end

	#演習4.abd
	def filloval(x, y, rad, a, start, finish, _step, alpha, rotate)
		#(X-x)**2 + ((Y-y)/a)**2 == rad**2 and inside of it.
		(y-rad*a).step(y+rad*a,_step){|j|
			(x-rad).step(x+rad,_step){|i|
				if (i-x)**2 + ((j-y)/a.to_f)**2 < rad**2 then setcolor(i, j, x, y, start, finish, (i-x+rad)/(rad*2).to_f, alpha, rotate) end
			}
		}
	end

	#演習4.abd
	def fillrect(x0, y0, x1, y1, start, finish, _step, alpha, rotate)
		y0.step(y1,_step){|j|
			x0.step(x1,_step){|i|
				setcolor(i, j, (x0+x1)/2, (y0+y1)/2, start, finish, (i-x0)/(x1-x0).to_f, alpha, rotate)
			}
		}
	end

	#演習4.d
	def drawlissajous(x, y, size, _a, _b, start, finish, delta, alpha, rotate, theta=0)
		t=0.0
		_theta=theta.degtorad
		while t<PI*2
			i=(x+size*cos(_a*t)).to_i
			j=(y+size*sin(_b*t+_theta)).to_i
			setcolor(i, j, x, y, start, finish, t/(PI*2).to_f, alpha, rotate)
			t+=delta
		end
	end

	#cos版
	def drawlissajous2(x, y, size, _a, _b, start, finish, delta, alpha, rotate, theta=0)
		t=0.0
		_theta=theta.degtorad
		while t<PI*2
			i=(x+size*cos(_a*t)).to_i
			j=(y+size*cos(_b*t+_theta)).to_i
			setcolor(i, j, x, y, start, finish, t/(PI*2).to_f, alpha, rotate)
			t+=delta
		end
	end

	def revvertical
		@img.reverse!
	end

	def revhorizontal
		@img.each{|i| i.reverse!}
	end

	#何マスごとにモザイクするか？
	def mosaic(n)
		0.step(@y-1,n){|_j|
			0.step(@x-1,n){|_i|
				r=g=b=c=0

				_j.step(_j+n-1){|j|
					if j>=@y then break end
					_i.step(_i+n-1){|i|
						if i>=@x then break end
						r+=@img[j][i].r
						g+=@img[j][i].g
						b+=@img[j][i].b
						c+=1
					}
				}

				_j.step(_j+n-1){|j|
					if j>=@y then break end
					_i.step(_i+n-1){|i|
						if i>=@x then break end
						@img[j][i].r=r/c
						@img[j][i].g=g/c
						@img[j][i].b=b/c
					}
				}
			}
		}
	end

	#にき: モノクロ画像の、あかいサンプル表示を、消してみんとす--;
	def __fix
		0.step(@y-1){|j|
			0.step(@x-1){|i|
				p = @img[j][i]
				n = (p.g+p.b)/2;
				if p.r-n>10
					if p.r>240 then @img[j][i].b=@img[j][i].g=@img[j][i].r=255
					else
						x=(n*1.5).to_i
						if x>255 then x=255 end
						@img[j][i].b=@img[j][i].g=@img[j][i].r=x
					end
				end
			}
		}
	end
end

class BMPImage < PPMImage #Lite OS/2 Bitmap Writer
	def write2(name,x1,y1,x2,y2)
		open(name,"wb"){|f|
			padding = (x2-x1+1)*3%4
			if padding>0 then padding=4-padding end
			f.print "BM"+(26+(y2-y1+1)*((x2-x1+1)*3+padding)).to_binary_little(4)+0.to_binary_little(4)+26.to_binary_little(4)+
						  12.to_binary_little(4)+(x2-x1+1).to_binary_little(2)+(y2-y1+1).to_binary_little(2)+
						  1.to_binary_little(2)+24.to_binary_little(2)
			y2.step(y1,-1){|j|
				x1.step(x2){|i|
					p = @img[j][i]
					f.print p.b.chr+p.g.chr+p.r.chr
				}
				padding.times{|i|
					f.print 0.chr
				}
			}
		}
	end

	def write(name)
		write2(name, 0, 0, @x-1, @y-1)
	end
end

#演習6、としようと思います。
#以下足し算引き算を残してあるのは保守をしやすくするためです。
def turtle
	ppm = BMPImage.new(300,200)
	ppm.filloval(      150,     100,    130, 0.3, Pixel.new(70,  200, 30 ), Pixel.new(70,  200, 30 ), 1, 0, 0 ) #首としっぽ
	ppm.fillcircle(    150-63,  100-61, 18,       Pixel.new(200, 200, 0  ), Pixel.new(200, 200, 0  ), 1, 0, 0 ) #右前足
	ppm.fillcircle(    150-63,  100+61, 18,       Pixel.new(200, 200, 0  ), Pixel.new(200, 200, 0  ), 1, 0, 0 ) #左前足
	ppm.fillcircle(    150+63,  100-61, 18,       Pixel.new(200, 200, 0  ), Pixel.new(200, 200, 0  ), 1, 0, 0 ) #右後足
	ppm.fillcircle(    150+63,  100+61, 18,       Pixel.new(200, 200, 0  ), Pixel.new(200, 200, 0  ), 1, 0, 0 ) #左後足
	ppm.fillcircle(    150,     100,    90,       Pixel.new(30,  100, 30 ), Pixel.new(30,  100, 30 ), 1, 0, 0 ) #胴体
	ppm.drawlissajous( 150,     100,    80, 3, 4, Pixel.new(200, 200, 0  ), Pixel.new(200, 200, 0  ), 0.001, 0, 0 ) #甲羅の線(リサージュ)
	ppm.fillcircle(    150-100, 100-20, 10,       Pixel.new(255, 255, 0  ), Pixel.new(255, 255, 0  ), 1, 0, 0 ) #右目
	ppm.fillcircle(    150-100, 100+20, 10,       Pixel.new(255, 255, 0  ), Pixel.new(255, 255, 0  ), 1, 0, 0 ) #左目
	ppm.fillrect(      0, 0, 300, 200,  Pixel.new(200, 255, 255), Pixel.new(150, 255, 255), 1, 0.7, 0 ) #水中にいるイメージ…
	#ppm.mosaic(7)
	ppm.write("turtle.bmp")
end

#画像を作るにあたっては、最初は幾何学模様をイメージしていたのですが、リサージュ曲線を見ていると亀の甲羅の線に見えて来たので、亀で行くことにしました…
#足には爪も…あったりします。
#コンセプトとしては、数学曲線を動物の一部に使ってみました。

=begin
以下画像ライブラリについての考察です。
・fillcircleについて、円のX座標の範囲とY座標の範囲における各点(i,j)について
それが画像全体の範囲に収まるかの判定および (i-x)**2 + (j-y)**2 < rad**2 判定をするように変更すれば
多少高速化できる(演習5)。
・透明度と、何ピクセルおきに描画するかを指定できるようにした(演習4.bd)。
・数学曲線の代表例としてリサージュ曲線を書けるようにした(演習4.d)。
・画像の要素を回転できるようにした(演習4.a)。これには演習5の考えが不可欠である(と思われる)。
ただし、画像生成には非常に時間がかかるようになってしまった(一点描画するたびに三角関数を2回使う必要があるため)。
しかも回転後の画像は荒くなる…2倍のピクセル数で生成して最後に1/2にリサイズすればいいのでしょうが。
・グラデーションを掛けられるようにした(演習4.c)。一点描画するたびに進行率を計算するためさらに速度低下。
=end

=begin
[追記]
ビットマップでも保存できるようBMPImageを作成。
形式にのっとるため、Integerクラスにto_binary_little(とto_binary_big)を追加。
また、画像サイズを考えPPMImageを改良(バイナリ形式(P6)で保存できるように)。
PPMImage(改良前)663943bytes(改行コードがCRLF(Windows)だとさらにサイズが増える)
PPMImage(改良後)180015bytes
BMPImage(改良前)240026bytes(行の境界の処理が面倒だったので32bitにしたため)
BMPImage(改良後)180026bytes(24bitにした)
=end
