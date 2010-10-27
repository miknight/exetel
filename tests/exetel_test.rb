require 'test/unit'

require File.dirname(__FILE__) + '/../exetel'

class ExetelTest < Test::Unit::TestCase

  def setup
    @exetel = Exetel.new(File.dirname(__FILE__) + '/exetel.xml')
  end

  def test_peak_usage
    assert_equal 31768.18, @exetel.peak_usage
  end

  def test_offpeak_usage
    assert_equal 23307.4, @exetel.offpeak_usage
  end

end
