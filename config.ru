require 'rubygems'
require 'rack'
require 'rack_haml_sass_generator'
require 'sass/plugin/rack'

module Rack
  class CSSGenerator
    def call(env)
      req = Request.new(env)
      response = Rack::Response.new
      response.header['Content-Type'] = 'text/html'
      response.write(html(req.params["color"]))
      response.finish
    end

    def sass_options
      path = ::File.expand_path('../public/stylesheets/sass/', __FILE__)
      options = {
        :style => :nested,
        :load_paths => [path],
        :cache => false,
        :syntax => :sass,
      }
    end

    def css(color)
      template = <<-eocss
@import '_buttons'

.button
  @include button
  @include color(#{color})
      eocss
      sass_engine = Sass::Engine.new(template, sass_options)
      sass_engine.render
    end

    def html(color)
      css = css(color)
      buttons = <<-eob
<div>
  <a class="button">Click</a>
  <input class="button" type="submit" value="Submit"/>
</div>
      eob

      default_sass = ::File.read(::File.expand_path('../public/stylesheets/sass/default.sass', __FILE__ ))
      default_css = Sass::Engine.new(default_sass, sass_options).render

      <<-eoc
<html>
  <head>
    <title>Generated button</title>
    <style type="text/css">
        #{default_css}
        textarea {
          width: 100%;
          padding: 10px;
        }
        #{css}
    </style>
  </head>
  <body>
    <h1>Here is the CSS for the color #{color}</h1>
    <h2>The buttons will look like this:</h2>
    #{buttons}
    <h2>Put this in your CSS:</h2>
    <textarea rows="45">#{css}</textarea>
    <h2>And this in your HTML:</h2>
    <textarea rows="4">#{buttons}</textarea>
    <footer>
      <p> code by <a href="http://dira.ro">dira.ro</a> </p>
      <p> Inspired by the <a href="http://www.webdesignerwall.com/tutorials/css3-gradient-buttons/">CSS3 Gradient buttons tutorial</a> </p>
    </footer>
  </body>
</html>
eoc
    end
  end
end

use Rack::SiteGenerator #haml
use Sass::Plugin::Rack
use Rack::Static, :urls => ["/index.html", "/generator.html", "/stylesheets/default.css"], :root => "public"
map "/generate" do
  run Rack::CSSGenerator.new
end
