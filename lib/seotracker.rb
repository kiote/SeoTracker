require 'rubygems'
require 'mechanize'
require 'logger'
#require 'pry'

class Seotracker
  USER_AGENT = 'Mac Safari'
  RESULTS = 10

  def initialize
    @agent = Mechanize.new
    @agent.user_agent_alias = Seotracker::USER_AGENT
    @agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    @agent.agent.http.retry_change_requests = true

    @debug = true

    if @debug
      @log = Logger.new('log.txt')
      #@agent.log = @log если надо логировать mechnize
    end
  end

  def get_position(site, word, region = Seotracker::Yandex::MOSCOW, pages = 200)
    pos, found, start = 0, false, 0
    while (start < pages) && !found
      links = parse(word, start, region)
      start += RESULTS

      break if links == 'error'
      links.each do |l|
        href = l.attribute('href').value.downcase
        # убеждаемся, что это точно ссылка. а то бывает еще адрес
        pos += 1 if l.content.match(/.+\..+/)
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
end

require 'seotracker/yandex'
require 'seotracker/yandex/direct'
require 'seotracker/google'
