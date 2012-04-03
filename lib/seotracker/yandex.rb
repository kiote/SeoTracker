class Seotracker::Yandex < Seotracker
  SEARCH_URL = "http://yandex.ru/yandsearch?"

  protected

  def parse(word, start = 0)
    start /= 10

    # у яндекса хитрая проверка на роботов
    if start == 0
      @agent.get('http://kiks.yandex.ru/su/')
      @cookie = @agent.cookies.first
    end

    #agent = Mechanize.new
    #agent.user_agent_alias = Seotracker::USER_AGENT
    ##agent.log = Logger.new('log.txt')

    url = SEARCH_URL + "text=#{word}&p=#{start}"

    page = @agent.get(url, [], nil, {'cookie' => @cookie})
    page.root.xpath('/html/body/div[3]/div/div/div[2]/ol/li/div/h2/a')
  end
end