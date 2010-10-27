require 'rexml/document'

class Exetel

  DATA_URL = "https://www.exetel.com.au/members/usagemeter_xml.php?{USERNAME},{PASSWORD}"

  def initialize(username, password)
    @username = username
    @password = password
    # TODO: Just grab it now.
  end

  def initialize(file_name)
    if !File.exists?(file_name)
      puts "File #{file_name} does not exist. Exiting..."
      exit 1
    end
    data = File.read(file_name)
    parse(data)
  end

  def peak_usage
    @doc.elements['CurrentMonthUsage'].elements['PeakDownload'].text.to_f
  end

  def offpeak_usage
    @doc.elements['CurrentMonthUsage'].elements['OffpeakDownload'].text.to_f
  end

  private

  def parse(data)
    @doc = REXML::Document.new(data).elements['Response']
  end

end
