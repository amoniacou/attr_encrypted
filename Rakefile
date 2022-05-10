# frozen_string_literal: true
require "bundler/setup"
require 'rake/testtask'
require "bundler/gem_tasks"

desc 'Test the attr_encrypted gem.'
Rake::TestTask.new(:test) do |t|
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = false
  t.verbose = true
end

desc 'Default: run unit tests.'
task :default => :test
