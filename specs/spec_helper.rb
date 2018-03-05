require 'time'
require 'simplecov'
SimpleCov.start
require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'


Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Require_relative your lib files here!
require_relative '../lib/driver'
require_relative '../lib/passenger'
require_relative '../lib/trip'
require_relative '../lib/trip_dispatcher'
require_relative '../lib/rideshare_module_methods'
