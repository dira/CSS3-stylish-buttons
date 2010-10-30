module Rack
  class SiteGenerator
    require 'fileutils'

    GENERATORS = {
      :haml => ["haml", "haml  %s %s"],
      :erb  => ["erb" , "erb   %s > %s"],
      :less => ["less", "lessc %s %s"],
      :sass => ["sass", "sass  %s %s"]
    }

    def initialize(app, options = {})
      @app = app
      @generators    = options[:generators]    || { :html => :haml, :css  => :sass }
      @source_path = options[:source_path] || 'views'
    end

    def call(env)
      path = env["REQUEST_PATH"]
      extension = ::File.extname(path)[1..-1]
      generator = GENERATORS[@generators[extension.to_sym]] rescue nil
      if generator
        source = path.gsub(/^\//, "#{@source_path}/")
        source.gsub!(/\.#{extension}$/, ".#{generator[0]}")
        destination = "public#{path}"

        ::FileUtils.mkdir_p(::File.dirname(destination))
        `#{generator[1] % [source, destination]}` unless valid?(source, destination)
      end

      @app.call(env)
    end

    def valid?(source, generated)
      return false # problem with Sass files with mixins
      ::File.exist?(generated) && ::File.mtime(generated) > ::File.mtime(source)
    end
  end
end
