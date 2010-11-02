require 'rubygems'
require 'sinatra'
require 'index.rb'

# logging
require 'fileutils'
set :raise_errors, true
log_file = "log/sinatra.log"
log = File.new(log_file, "a+")
STDOUT.reopen(log)
STDERR.reopen(log)

run CSSButtons
