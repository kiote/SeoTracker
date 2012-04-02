require 'rubygems'
require 'mechanize'

class Seotracker
  USER_AGENT = 'Mac Safari'

  def initialize
    @agent = Mechanize.new
    @agent.user_agent_alias = Seotracker::USER_AGENT
  end

  def get_position(site, &block)
    links = yield
    pos, found = 0, false
    links.each do |l|
      pos += 1
      href = l.attribute('href').value.downcase
      unless href.rindex(site).nil?
        found = true
        break
      end
    end
    found ? pos : 0
  end
end

require 'seotracker/yandex'
require 'seotracker/google'
