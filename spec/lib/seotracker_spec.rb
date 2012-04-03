# encoding: utf-8
$LOAD_PATH << File.expand_path('../../', __FILE__)
require 'spec_helper'

describe Seotracker do
  # общие моки, тут от природной лени несколько объектов используют один мок
  # что может несколько напрягать в дальнейшем
  def common_mocker
    mock = MiniTest::Mock.new
    mock.expect(:root, mock)
    mock.expect(:attribute, mock, %w/href/)
    mock.expect(:value, "http://#{@site}")
  end

  before do
    @site = 'serialmaniak.ru'
    @word = 'маньяки'
  end

  describe 'yandex' do
    before do
      @object = Seotracker::Yandex.new

      # мокаем все неважное
      mock = common_mocker
      mock.expect(:get, mock, [Seotracker::Yandex::SEARCH_URL  + "text=#{@word}&p=0",  [], nil, {'cookie' => 'hi'}])
      mock.expect(:get, mock, ['http://kiks.yandex.ru/su/'])
      mock.expect(:cookies, ['hi'])
      mock.expect(:xpath, [mock], %w\/html/body/div[3]/div/div/div[2]/ol/li/div/h2/a\)

      @object.instance_variable_set(:@agent, mock)
    end

    it 'should return valid position' do
      @object.get_position(@site, @word).must_be :>, 0
    end
  end

  describe 'google' do
    before do
      @object = Seotracker::Google.new

      # мокаем все неважное
      mock = common_mocker
      mock.expect(:get, mock, [Seotracker::Google::SEARCH_URL, {q: @word, start: 0}])
      mock.expect(:xpath, [mock], %w\/html/body/div[5]/div/div/div[4]/div[2]/div[2]/div/div[2]/div/ol/li/div/h3/a\)

      @object.instance_variable_set(:@agent, mock)
    end

    it 'should return valid position' do
      @object.get_position(@site, @word).must_be :>, 0
    end
  end
end