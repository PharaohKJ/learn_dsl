require 'date'

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

class CalEvent
  def initialize(title)
    @title = title
    @date = @start_time = @end_time = nil
  end
  def on(date)
    @date = Date.parse(date)
  end
  def starts(time)
    @start_time = time
  end
  def ends(time)
    @end_time = time
  end
  def show
    print "title:#{@title}, on #{@date}, starts #{@start_time}, ends #{@end_time}\n"
    unless @every.nil?
      print "every:#{@every.day}\n"
    end
  end
  class Every
    attr_reader :day
    def initialize(method)
      @method = method
      @wday = nil
    end
    def wday(day)
      p day
      @day = day
    end
  end
  def every(method, &block)
    @every = Every.new(method)
    @every.instance_eval(&block)
  end
end

def event(title, &block)
  cal = CalEvent.new(title)
  cal.instance_eval(&block)
  cal.show
end
load File.expand_path(ARGV[0])
