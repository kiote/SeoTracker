require 'rubygems'
require 'mechanize'
require 'logger'

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

  def get_position(site, word)
    pos, found, start = 0, false, 0
    while (start < 200) && !found
      links = parse(word, start)
      start += RESULTS

      break if links == 'error'

      links.each do |l|
        pos += 1
        href = l.attribute('href').value.downcase
        unless href.rindex(site).nil?
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
end

require 'seotracker/yandex'
require 'seotracker/yandex/direct'
require 'seotracker/google'
