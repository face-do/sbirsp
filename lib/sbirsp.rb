require "sbirsp/version"
require "masque"

module Sbirsp
  class Configuration
    attr_accessor :username, :password, :default_host

    def initialize
      self.username = nil
      self.password = nil
      self.default_host = "https://www.sbisec.co.jp/ETGate"
    end
  end

  class << self
    def configure
      yield self
    end
   end

  class Client
    attr_accessor :login_status, :loop_status, :client, :now_price, :now_code

    def initialize
    @client = Masque.new(:display => 99, :driver => :poltergeist)
    @now_price = 0 
      login
    end

    def login
      @client.run do
        visit Sbirsp.configuration.default_host
        fill_in("user_id", :with => Sbirsp.configuration.username)
        fill_in("user_password", :with => Sbirsp.configuration.password)
        find('*[name="ACT_login"]').click
      end
        sleep 5
        puts "logined"
        @login_status = true
        @current_host ||= "#{@client.agent.page.current_host}"
    end
    
    def code=(stock_code)
      @now_code = stock_code
    end
    
    def visit_stock_page
      check_login
      check_stock_code
        url = "#{@current_host}/ETGate/?_ControlID=WPLETsiR001Control&_DataStoreID=DSWPLETsiR001Control&_PageID=WPLETsiR001Idtl10&_ActionID=getInfoOfCurrentMarket&s_rkbn=&i_dom_flg=1&stock_sec_code_mul=#{@now_code}&exchange_code=&ref_from=1&ref_to=20"
      @client.run do
        visit(url)
        sleep 5
      end
    end
    
    def realtime_on
      check_login
      check_stock_code
      @client.run do
        puts "visited: #{@now_code}"
        find("#imgRefArea_MTB0_on").click
      end
    end

    def show_stock_price
	  check_login
      @loop_status = false
      visit_stock_page
      realtime_on
      get_stock_price unless @loop_status
    end
    
    def get_stock_price
       Thread.fork(@now_code) do |stock_code|
	   @loop_status = true
	      while @loop_status do
	        now_price = @now_price
	        @client.run do
              now_price = find("#flash").text.delete(",").to_i
            end
            @now_price = now_price
             if stock_code != @now_code
              @loop_status = false
              Thread.stop
            end
          end
	    end
    end
    
    def stop_get_stock_price
      @loop_status = false
    end

    def price
      @now_price
    end
    
    private
    def check_login
      unless @login_status
        puts "not logined" 
        return false
      end
    end
    
    def check_stock_code
      unless @now_code
        puts "please set stock_code" 
        return false
      end
    end
  end

  def self.configuration
    @configuration ||=  Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end
end


Sbirsp.configure do |config|
  config.default_host = "https://www.sbisec.co.jp/ETGate"
end
