require 'rexml/document'
require 'net/https'
require 'uri'

class Exetel

  DATA_URL = "https://www.exetel.com.au/members/usagemeter_xml.php?{USERNAME},{PASSWORD}"

  # Accept either a username and password or a file name.
  def initialize(user_or_file, password = nil)
    if password.nil?
      if !File.exists?(user_or_file)
        puts "File #{user_or_file} does not exist. Exiting..."
        exit 1
      end
      data = File.read(user_or_file)
    else
      url = DATA_URL.sub('{USERNAME}', user_or_file).sub('{PASSWORD}', password)
      data = fetch(url)
    end
    parse(data)
  end

  def peak_usage
    @doc.elements['CurrentMonthUsage'].elements['PeakDownload'].text.to_f
  end

  def offpeak_usage
    @doc.elements['CurrentMonthUsage'].elements['OffpeakDownload'].text.to_f
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
