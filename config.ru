require 'rubygems'
require 'rack'
require 'rack_haml_sass_generator'

use Rack::SiteGenerator
use Rack::Static, :urls => ["/"], :root => "public"
run lambda { |env| []}
