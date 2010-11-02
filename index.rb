require 'sinatra/base'
require 'sass'

class CSSButtons < Sinatra::Base
  get '/' do
    @title = "Sass super-mixins for stylish buttons"
    haml :index
  end

  get '/generator' do
    @title = "Generate CSS for stylish buttons"
    @color = params["color"] || "C33"
    haml :generator
  end

  post '/generate' do
    @color = "#" + params[:color]
    @title = "Stylish buttons for #{@color}"
    @css = css
    haml :generate
  end

  get "/stylesheets/:name.css" do
    headers['Content-Type'] = 'text/css'
    sass :"../public/stylesheets/sass/#{params["name"]}"
  end

  get "/tmp" do
    sass :"../public/stylesheets/sass/buttons"
  end

  protected
  def css
    sass = "$color = #{@color}\n" + File.read('views/buttons.sass')
    options = {
      :load_paths => [File.expand_path('../public/stylesheets/sass/', __FILE__)],
      :cache => false,
    }
    engine = Sass::Engine.new(sass, options)
    engine.render
  end
end
