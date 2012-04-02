class Seotracker::Yandex < Seotracker
  SEARCH_URL = 'http://yandex.ru/yandsearch'

  # получаем позицию сайта для слова
  def get_position(site, word)
    super(site) do
      page = @agent.get(SEARCH_URL, text: word)
      page.root.xpath('/html/body/div[3]/div/div/div[2]/ol/li/div/h2/a')
    end
  end
end