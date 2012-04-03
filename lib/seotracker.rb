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
  end

  def get_position(site, word)
    pos, found, start = 0, false, 0
    while (start < 200) && !found
      links = parse(word, start)
      start += RESULTS
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
end

require 'seotracker/yandex'
require 'seotracker/google'
