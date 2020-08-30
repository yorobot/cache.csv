###
#  to run use
#     ruby -I ./lib -I ./test test/test_base.rb

require 'helper'

class TestBase < MiniTest::Test

  def test_version
    puts Monoscript::VERSION
    puts Monoscript.banner
    puts Monoscript.root
  end

  def test_root
     puts Mono.root
  end

end # class TestBase

