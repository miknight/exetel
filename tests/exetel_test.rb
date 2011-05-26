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
    assert_equal  (26.0 / 31 * 100), @exetel.month_percentage()
    assert_equal  (1.0 / 30 * 100), @exetel.month_percentage('2011-04-29', '2011-04-28')
    assert_equal (29.0 / 30 * 100), @exetel.month_percentage('2011-05-26', '2011-04-28')
    assert_equal (3.0 / 31 * 100), @exetel.month_percentage('2011-05-31', '2011-05-28')
  end

end
