#平均、実験標準偏差、相対不確かさ

def p06kadai
	#class BmpImageについては久野レポート4B参照
	bmp=BMPImage.new(200,200)
	bmp.drawlissajous2(100, 100, 80, 1, 1, Pixel.new(0, 0, 0), Pixel.new(0, 0, 0), 0.001, 0, 0, 135)
	bmp.drawlissajous2(100, 100, 80, 1, 1, Pixel.new(255, 0, 0), Pixel.new(255, 0, 0), 0.001, 0, 0, 180)
	bmp.drawlissajous2(100, 100, 80, 1, 2, Pixel.new(0, 255, 0), Pixel.new(0, 255, 0), 0.001, 0, 0, 135)
	bmp.drawlissajous2(100, 100, 80, 1, 2, Pixel.new(0, 0, 255), Pixel.new(0, 0, 255), 0.001, 0, 0, 180)
	bmp.revvertical
	bmp.write("p06kadai.bmp")
end
