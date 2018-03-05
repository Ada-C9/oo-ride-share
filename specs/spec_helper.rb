require 'simplecov'
SimpleCov.start

require 'time'
require 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/pride'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# Require_relative your lib files here!
require_relative '../lib/driver'
require_relative '../lib/passenger'
require_relative '../lib/trip'
require_relative '../lib/trip_dispatcher'
