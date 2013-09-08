module Minecrafter
  class App < Sinatra::Base
    helpers do
      def server
        @server ||= Minecrafter::Server.new(ENV['AWS_INSTANCE'])
      end
    end

    get '/' do
      erb :index
    end

    post '/server' do
      if params[:password] == ENV['MINECRAFTER_KEY']
        case params[:action]
        when "Start"
          server.start!
        when "Stop"
          server.stop!
        end
      end

      redirect to('/')
    end

    post '/start' do
      server.start!

      redirect to('/')
    end

    get '/status' do
      server.status
    end
  end
end
