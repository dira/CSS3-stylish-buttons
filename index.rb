require 'sinatra/base'
require 'sass'

class CSSButtons < Sinatra::Base
  set :public, "public"
  Rack::Mime::MIME_TYPES.merge!({'.sass' => "text/css"})

  get '/' do
    @title = "Sass super-mixins for stylish buttons"
    @navigation = ['home']
    haml :index
  end

  get '/generator' do
    @title = "Generate CSS for stylish buttons"
    @navigation = [['home', '/'], ['CSS generator']]
    @color = h(params["color"] || "C33")
    haml :generator
  end

  post %r{/generate(.part)?} do
    @color = h("#" + params[:color])
    @title = "Stylish buttons for #{@color}"
    @navigation = [['home', '/'], ['CSS generated']]
    @css = css
    haml :generate, :layout => !params["captures"]
  end

  get "/stylesheets/:name.css" do
    headers['Content-Type'] = 'text/css'
    sass :"../public/stylesheets/sass/#{params["name"]}"
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
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
