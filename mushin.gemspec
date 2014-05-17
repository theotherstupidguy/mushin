# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'mushin'
  s.version     = '0.0.0.pre18'
  s.summary     = "a ruby experiment"
  s.description = "In the beginner’s mind there are many possibilities, in the expert’s mind there are few!"
  s.authors     = ["theotherstupidguy"]
  s.email       = 'theotherstupidguy@gmail.com'
  #s.files       = ["lib/mushin.rb"]
  s.files       =  Dir.glob("{lib}/**/*") 
  s.homepage    = 'https://github.com/mushin-rb/mushin'
  s.license     = 'MIT'
end
