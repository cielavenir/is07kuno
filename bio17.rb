#Analysis
#Preparation for bio17.R
#You are forbidden from using this DATA as your experiment's (though program is free).

#実行方法
#1.irbでload "main.rb"した後にbio17a
#2.r bio17.R

def bio17a
	#data: deg, P, P/P0, 1/sin * P/P0, 1-cos/2
	data1=[[90,353.348],[110,349.793],[130,346.237],[150,266.828],[70,270.976],[50,128.158],[90,323.718]]
	data2=[[90,282.236],[110,277.495],[130,268.606],[150,236.012],[70,252.013],[50,199.863],[90,278.680]]
	data=[[50],[70],[90],[110],[130],[150]]
	m1=0; m2=0; m3=0
	data1.sort! {|a,b| x=a[0]<=>b[0]; if x!=0 then x else a[1]<=>b[1] end}
	data2.sort! {|a,b| x=a[0]<=>b[0]; if x!=0 then x else a[1]<=>b[1] end}
	data1.each{|x| if m1<x[1] then m1=x[1] end
		case x[0]
			when 50 then data[0].push(x[1])
			when 70 then data[1].push(x[1])
			when 90 then data[2].push(x[1])
			when 110 then data[3].push(x[1])
			when 130 then data[4].push(x[1])
			when 150 then data[5].push(x[1])
		end
	}
	data2.each{|x| if m2<x[1] then m2=x[1] end
		case x[0]
			when 50 then data[0].push(x[1])
			when 70 then data[1].push(x[1])
			when 90 then data[2].push(x[1])
			when 110 then data[3].push(x[1])
			when 130 then data[4].push(x[1])
			when 150 then data[5].push(x[1])
		end
	}
	data.length.times{|i| data[i][1]=data[i][1..4].average;p data[i]}
	data.each{|x| if m3<x[1] then m3=x[1] end}

	data1.each{|x| x[2]=x[1]/m1; x[3]=x[2]/Math.sin(degtorad(x[0])); x[4]=1-Math.cos(degtorad(x[0]))}
	data2.each{|x| x[2]=x[1]/m2; x[3]=x[2]/Math.sin(degtorad(x[0])); x[4]=1-Math.cos(degtorad(x[0]))}
	data.each{|x| x[2]=x[1]/m3; x[3]=x[2]/Math.sin(degtorad(x[0])); x[4]=1-Math.cos(degtorad(x[0]))}
	File.open("bio17a.csv","w"){|f|
		f.print "Deg,f,F,L\n"
		data1.each{|x| f.print x[0].to_s+","+x[2].to_s+","+x[3].to_s+","+x[4].to_s+"\n"}
		data2.each{|x| f.print x[0].to_s+","+x[2].to_s+","+x[3].to_s+","+x[4].to_s+"\n"}
		data.each{|x| f.print x[0].to_s+","+x[2].to_s+","+x[3].to_s+","+x[4].to_s+"\n"}
	}
end

def bio17b
	#data: P/P0, V
	data1=[[0.281,461.402],[0.410,636.645],[0.391,248.447],[0.466,279.504],[0.691,130.694],[0.906,62.112],[0.995,20.704],[0.258,745.340],[0.438,590.061]]
	data2=[[0.347,402.783],[0.439,361.116],[0.576,208.333],[0.552,319.444],[0.632,111.111],[0.795,41.667],[0.963,0.591],[0.342,569.443]]
	data1.each{|x| x[2]=x[0]*x[1]}
	data2.each{|x| x[2]=x[0]*x[1]}
	File.open("bio17b.csv","w"){|f|
		f.print "P,V,W\n"
		data1.each{|x| f.print x[0].to_s+","+x[1].to_s+","+x[2].to_s+"\n"}
		data2.each{|x| f.print x[0].to_s+","+x[1].to_s+","+x[2].to_s+"\n"}
	}
end
