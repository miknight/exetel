require 'rexml/document'
require 'net/https'
require 'uri'
require 'date'

class Exetel

  DATA_URL = "https://www.exetel.com.au/members/usagemeter_xml.php?{USERNAME},{PASSWORD}"

  # Accept either a username and password or a file name.
  # If neither are passed, data needs to be sent in via data=().
  def initialize(user_or_file = nil, password = nil)
    return if user_or_file.nil?
    if password.nil?
      if !File.exists?(user_or_file)
        puts "File #{user_or_file} does not exist. Exiting..."
        exit 1
      end
      @data = File.read(user_or_file)
    else
      url = DATA_URL.sub('{USERNAME}', user_or_file).sub('{PASSWORD}', password)
      @data = fetch(url)
    end
    parse(@data)
  end

  def data
    @data
  end

  def data=(data)
    @data = data
    parse(data)
  end

  def peak_usage
    @doc.elements['CurrentMonthUsage'].elements['PeakDownload'].text.to_f
  end

  def offpeak_usage
    @doc.elements['CurrentMonthUsage'].elements['OffpeakDownload'].text.to_f
  end

  def peak_limit
    @doc.elements['PlanDetails'].elements['PeakTimeDownloadInMB'].text.to_f
  end

  def offpeak_limit
    @doc.elements['PlanDetails'].elements['OffpeakTimeDownloadInMB'].text.to_f
  end

  def peak_percentage
    peak_usage / peak_limit * 100
  end

  def offpeak_percentage
    return 0 if offpeak_limit == 0
    offpeak_usage / offpeak_limit * 100
  end

  def reported_date
    @doc.elements['CurrentMonthUsage'].elements['UpdateDatetime'].text
  end

  def month_percentage
    d = Date.parse(reported_date)
    days_in_month = Date.new(d.year, d.month, -1).day
    (d.day - 1.0) / days_in_month * 100
  end

  private

  def fetch(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    return response.body
  end

  def parse(data)
    @doc = REXML::Document.new(data).elements['Response']
  end

end
