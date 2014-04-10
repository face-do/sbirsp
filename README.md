# Sbirsp

SBI証券のサイトから、ほぼリアルタイムで株価を取得するライブラリです。
※SBI証券のアカウント必須

株価の変更を自動的に取得するので、システムトレードなどを行うときに使うことができます。

## Installation

Add this line to your application's Gemfile:

    gem 'sbirsp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sbirsp

## Usage

    gem install sbirsp
    Sbirsp.configure do |config|
      config.username = "user_id"
      config.password = "password"
    end
    
    @client = Sbirsp::Client.new
    @client.code = 1321
    @client.show_stock_price
    
    @old_price = nil
    
    loop do
      if old_price != @client.price
        puts @client.price
        @old_price = @client.price
      end
    end

## Sample


  

## Contributing

1. Fork it ( https://github.com/face-do/sbirsp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
