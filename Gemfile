# frozen_string_literal: true

source 'https://rubygems.org'

gem 'cocoapods', '~> 1.11'
gem 'commonmarker'
gem 'dotenv'
#gem 'fastlane', '~> 2.174'
gem "fastlane", :git => "https://github.com/fastlane/fastlane.git", :branch => "crazymanish-xcodebuild-destination-param-fix"
gem 'octokit', '~> 4.0'
gem 'rake'
gem 'rubocop', '~> 1.30'
gem 'rubocop-rake', '~> 0.6'
gem 'xcpretty-travis-formatter'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
