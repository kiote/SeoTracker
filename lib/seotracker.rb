require 'rubygems'
require 'mechanize'

class Seotracker
  USER_AGENT = 'Mac Safari'
  RESULTS = 10

  def initialize
    @agent = Mechanize.new
    @agent.user_agent_alias = Seotracker::USER_AGENT
    @agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @agent.agent.http.retry_change_requests = true

    @debug = false

    if @debug
      @log = Logger.new('log.txt')
      #@agent.log = @log если надо логировать mechnize
    end
  end

  # получаем позиции
  # получаем массив ссылок от парсера
  # увеличиваем счетчик позиций, пока не найдем нужную ссылку
  # 4 ссылки храним в массиве "последних", чтобы не считать случайно выдранные парсером повторения
  def get_position(site, word, region = nil, pages = 200)
    pos, found, start, hrefs = 0, false, 0, []
    while (start < pages) && !found
      links = parse(word, start, region)
      start += RESULTS

      break if links == 'error'
      links.each do |l|
        href = get_link(l)
        next if href == '' || hrefs.include?(href)

        # храним 4 последние полученные ссылки
        hrefs = hrefs.pop(3)
        hrefs << href
        pos += 1
        if href.rindex(site) && same_level(href, site)
          found = true
          break
        end
      end
    end
    found ? pos : 0
  end

  def debug(message)
    @log.debug(message) if @debug
  end

  protected

    # убеждаемся, что сайт, для которого определяем позицию (site)
    # и найденная ссылка (href) на одном и том же уровне
    # например, если искали позицию ya.ru
    # а сначала нашлась позиция maps.ya.ru то ее не считаем
    def same_level(href, site)
      return href.count('.') - 1 == site.count('.') if href.index('www')
      href.count('.') == site.count('.')
    end

    def get_link(link)
      href = link.attribute('href').value.downcase if link.attribute('href')
      href ||= link.value.downcase
      href.match(/[a-zA-Z0-9\-\.]+\.\w*/).to_s
    end
end

require 'seotracker/yandex'
require 'seotracker/yandex/direct'
require 'seotracker/google'
