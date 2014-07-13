require 'rake/testtask'
require 'rdoc/task'

desc "Run all tests"
Rake::TestTask.new :default do |t|
  t.libs = ["lib"]
  t.pattern = "spec/*_spec.rb"
end

RDoc::Task.new do |rd|
  rd.title    = "Mushin Documentation"
  rd.rdoc_dir = 'doc'

  rd.main = "/lib/**/*.rb"
  rd.options << '--inline-source'
  rd.options << '--line-numbers'
  rd.options << '--all'
  rd.options << '--fileboxes'
  rd.options << '--diagram'
end
