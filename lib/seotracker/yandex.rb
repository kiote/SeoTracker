class Seotracker::Yandex < Seotracker
  SEARCH_URL = 'http://yandex.ru/yandsearch?'
  WORDSTAT_URL = 'http://wordstat.yandex.ru/?cmd=words&page=1&&geo=&text_geo=&text='

  MOSCOW = 213

  # получаем стастистику wordstat
  # word - слово, по которому получаем статистику
  def get_wordstat(word)
    url = WORDSTAT_URL + word
    @cookie || get_cookie
    page = @agent.get(url, [], nil, { 'cookie' => @cookie })
    res = page.root.xpath('/html/body/form/table[2]/tbody/tr/td[4]/table/tbody/tr[3]/td/table/tbody/tr[2]/td[3]')
    begin
      res.first.content
    rescue Exception => e
      debug "can't get yandex wordstat: #{e.message}"
      0
    end
  end

  protected

  # начинаем парсить с первой страницы, регион по умолчанию - Москва
  def parse(word, start = 0, region = nil)
    region = MOSCOW if region.nil?

    start /= 10
    @cookie || get_cookie
    url = SEARCH_URL + "text=#{word}&p=#{start}&lr=#{region}"
    page = @agent.get(url, [], nil, { 'cookie' => @cookie })
    begin
      elements = page.root.xpath('/html/body/div[2]/div/div/div/ol/li/div/div')
      elements.map { |e| e.children.map { |c1|  c1.children.map { |c2| c2.children } } }.flatten.compact.map { |e1| e1.attribute('href') }.flatten.compact
    rescue Exception => e
      p e.message
      debug "can't parse yandex: #{e.message}"
      'error'
    end
  end

  def get_cookie
    # у яндекса хитрая проверка на роботов
    @agent.get('http://kiks.yandex.ru/su/')
    @cookie = @agent.cookies.first
  end
end
