module Minecrafter
  class App < Sinatra::Base
    helpers do
      def server
        @server ||= Minecrafter::Server.new(ENV['AWS_INSTANCE'])
      end

      def authorized?
        params[:password] == ENV['MINECRAFTER_KEY']
      end
    end

    get '/' do
      erb :index
    end

    post '/server' do
      if authorized?
        case params[:action]
        when "Start"
          server.start!
          redirect to('/')
        when "Stop"
          server.stop!
          redirect to('/')
        when "Server address"
          erb "<h1><%= server.dns %></h1>"
        end
      else
        redirect to('/')
      end
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
