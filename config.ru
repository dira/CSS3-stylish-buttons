require 'rubygems'
require 'rack'
require 'rack_haml_sass_generator'
require 'sass/plugin/rack'

use Rack::SiteGenerator #haml
use Sass::Plugin::Rack
use Rack::Static, :urls => ["/"], :root => "public"
run lambda { |env| []}
