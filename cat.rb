# coding: utf-8

require 'date'

# instance_evalさせてみるクラス
class Cat
  def initialize(name)
    @name = name
  end

  private

  def hello
    'meow...'
  end
end

def nyan
  cat = Cat.new('Piko')
  puts cat.instance_eval { @name + ': ' + hello }
end

nyan

# カレンダーイベント
class CalEvent
  def initialize(title)
    @title = title
    @date = @start_time = @end_time = nil
  end

  # 表示用(DSLと関係なし)
  def show
    print "title:#{@title}, on #{@date},"
    print "starts #{@start_time}, ends #{@end_time}\n"
    unless @every.nil?
      print "every:#{@every.day}\n"
    end
  end

  private

  # 決行日(DSL中の関数をこのように実装する on XXX というように書ける)
  def on(date)
    @date = Date.parse(date)
  end

  # 開始日
  def starts(time)
    @start_time = time
  end

  # 終了日
  def ends(time)
    @end_time = time
  end

  # everyというさらに入れ子になったDSL用クラス
  class Every
    attr_reader :day
    def initialize(method)
      @method = method
      @wday = nil
    end

    # every do  xxx end 中に現れた wday XXX をこのようにかける
    def wday(day)
      @day = day
    end
  end

  # 毎〜 は every do xxx end と表し、そのブロックをEveryクラスにまかせる
  def every(method, &block)
    @every = Every.new(method)
    @every.instance_eval(&block)
  end
end

# 出だしのeventはここで開始
# (loadするファイルには event XXX do XXX end と書かれているので)
# まず event methodがブロック指定で呼び出される
def event(title, &block)
  cal = CalEvent.new(title)
  cal.instance_eval(&block)
  cal.show
end

# test fileを読み出す
load File.expand_path(ARGV[0])
