# encoding: utf-8

class Seotracker::Yandex::Direct < Seotracker::Yandex
  def special(word)
    get_cookie
    url = SEARCH_URL + "text=#{word}&p=0"
    page = @agent.get(url, [], nil, {'cookie' => @cookie})
    begin
      texts = page.root.xpath('/html/body/div[3]/div/div/div/div/div[2]/div/h2/a')
      hrefs = page.root.xpath('/html/body/div[3]/div/div/div/div/div/div/div/div/span')

      # pre_result - массив вида ['text','text','text','url','url','url']
      pre_result = []
      texts.map { |t| pre_result << t.content.strip.squeeze("\n") }
      hrefs.map { |h| pre_result << h.content.scan(/\w+\.\w+/).first unless h.content.scan(/\w+\.\w+/)== [] }
      raise Seotracker::Yandex::Direct::Exception if pre_result.count != 6

      # приводим pre_result к виду [{ad: text, url: url}}]
      result = []
      (0...3).to_a.each { |i| result << { ad: pre_result[i], url: pre_result[i + 3] } }

      result
    rescue Exception => e
      debug "can't parse yandex direct:" + e.message
      'error'
    end
  end
end

class Seotracker::Yandex::Direct::Exception < Exception; end
