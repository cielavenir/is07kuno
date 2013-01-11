=begin
情報科学レポートおよび基礎化学・物理学実験解析
(C) t.yamada under 2-clause BSD License.

http://lecture.ecc.u-tokyo.ac.jp/~kuno/is07/

情報科学レポートについては、提出したものを少し手直ししてあります。
なお、このファイルを__requireし実行することが可能です。

実行環境はruby直ではなくirb(irb -r./main)をお勧めします。
boot.batがWinでもUnixでも実行できるはずです。
=end

require "rational" #^^

require "rbconfig"
def rubyversion
	Config::CONFIG['MAJOR'].to_i*1000000000+
	Config::CONFIG['MINOR'].to_i*1000000+
	Config::CONFIG['TEENY'].to_i*1000+
	RUBY_PATCHLEVEL
end

def __require(s)
	#if rubyversion>=1009000001 then require_relative(s); return end
	#require(Dir::pwd+"/"+s)
	#require(File::dirname(File::expand_path(__FILE__))+"/"+s)
	load(File::dirname(File::expand_path(__FILE__))+"/"+s)
end

def init
__require "core.rb"
__require "fib.rb"
__require "extra.rb"
__require "lightsout.rb"

#情報科学
__require "is06.rb"
#is07 -> 理論中心
__require "is08.rb"
#is09 -> 理論中心
__require "is10.rb"
__require "is11.rb"
__require "report1a1b2a2b3a3b4a5a5b6a6b7a.rb"
__require "report4b.rb"
__require "report7b.rb"
__require "report8a8b9a10a11a12a.rb"
__require "report9b.rb"
__require "report10b.rb"

#化学実験
__require "chem04.rb"
__require "chem05.rb"
__require "chem06.rb"

#物理実験
__require "phy02.rb"
__require "phy03.rb"
__require "phy05.rb"
__require "phy06.rb"
__require "phy08.rb"
__require "phy13.rb"

#生物実験
__require "bio17.rb"
return true
end

###main program start
init

__END__
