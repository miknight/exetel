require 'test/unit'

require File.dirname(__FILE__) + '/../exetel'

class ExetelTest < Test::Unit::TestCase

  PEAK_USAGE = 31768.18
  OFFPEAK_USAGE = 23307.4
  PEAK_LIMIT = 36000

  def setup
    @exetel = Exetel.new(File.dirname(__FILE__) + '/exetel.xml')
  end

  def test_peak_usage
    assert_equal PEAK_USAGE, @exetel.peak_usage
  end

  def test_peak_percentage
    expected_percentage = PEAK_USAGE / PEAK_LIMIT * 100
    assert_equal expected_percentage, @exetel.peak_percentage
  end

  def test_offpeak_usage
    assert_equal OFFPEAK_USAGE, @exetel.offpeak_usage
  end

  def test_offpeak_percentage
    assert_equal 0, @exetel.offpeak_percentage
  end
  
  def test_month_percentage
    assert_equal ((27 - 1.0) / 31 * 100), @exetel.month_percentage
  end

end
