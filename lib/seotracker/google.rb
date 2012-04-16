class Seotracker::Google < Seotracker
  protected

  def self.search_url(region = nil)
    region = 'www.google.ru' if region.nil?
    "http://#{region}/search?ix=seb&sourceid=chrome&ie=UTF-8"
  end

  def parse(word, start = 0, region = nil)
    page = @agent.get(self.class.search_url(region), q: word, start: start)
    page.root.xpath('/html/body/div[5]/div/div/div[4]/div[2]/div[2]/div/div[2]/div/ol/li/div/h3/a')
  end
end