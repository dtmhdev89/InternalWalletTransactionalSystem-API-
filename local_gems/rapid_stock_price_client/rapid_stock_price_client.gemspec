# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rapid_stock_price_client/version"

Gem::Specification.new do |spec|
  spec.name          = "rapid_stock_price_client"
  spec.version       = RapidStockPriceClient::VERSION
  spec.authors       = ["Hieu Dinh Tran Minh"]
  spec.email         = ["dtmhqng2906@gmail.com"]

  spec.summary       = %q{Pure ruby client for Rapid Stock Price Api}
  spec.description   = %q{Provide convenient ways to call api from Rapid Stock Price}
  spec.homepage      = ""
  spec.platform      = Gem::Platform::RUBY

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host' to push to a single host
  # or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'https://rubygems.org'"
  else
    raise "Please set correct metadata to push gem into a host"
  end

  spec.files         = Dir['{lib,spec,bin}/**/*', 'README*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 2.1"
  spec.add_dependency "oj"
  spec.add_dependency "hashie", '>= 2.0.5'
  spec.add_dependency "link_header"

  spec.add_development_dependency "bundler", "~> 2.4.6"
  spec.add_development_dependency "rake", "~> 13.1"
  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "vcr", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.1"
  spec.add_development_dependency "byebug"
end
