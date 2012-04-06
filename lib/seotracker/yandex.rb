class Seotracker::Yandex < Seotracker
  SEARCH_URL = 'http://yandex.ru/yandsearch?'
  WORDSTAT_URL = 'http://wordstat.yandex.ru/?cmd=words&page=1&&geo=&text_geo=&text='

  # получаем стастистику wordstat
  # word - слово, по которому получаем статистику
  def get_wordstat(word)
    url = WORDSTAT_URL + word
    get_cookie if @cookie.nil?
    page = @agent.get(url, [], nil, {'cookie' => @cookie})
    res = page.root.xpath('/html/body/form/table[2]/tbody/tr/td[4]/table/tbody/tr[3]/td/table/tbody/tr[2]/td[3]')
    begin
      res.first.content
    rescue Exception => e
      debug "can't get yandex wordstat:" + e.message
      0
    end
  end

  protected

  def parse(word, start = 0)
    start /= 10
    get_cookie if @cookie.nil?
    url = SEARCH_URL + "text=#{word}&p=#{start}"
    page = @agent.get(url, [], nil, {'cookie' => @cookie})

    begin
      page.root.xpath('/html/body/div[3]/div/div/div[2]/ol/li/div/h2/a')
    rescue Exception => e
      debug "can't parse yandex:" + e.message
      'error'
    end
  end

  def get_cookie
    # у яндекса хитрая проверка на роботов
    @agent.get('http://kiks.yandex.ru/su/')
    @cookie = @agent.cookies.first
  end
end
