# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'mushin'
  s.version     = '0.0.0.pre71'
  s.summary     = "a ruby experiment"
  s.description = "In the beginner’s mind there are many possibilities, in the expert’s mind there are few!"
  s.authors     = ["theotherstupidguy"]
  s.email       = 'theotherstupidguy@gmail.com'
  s.executables = ["mushin"]
  s.files       =  Dir.glob("{lib,bin}/**/*") 
  #s.files       = ["lib/mushin.rb", "bin/mushin"]
  s.homepage    = 'http://mushin-rb.github.io/'
  s.license     = 'MIT'
  s.post_install_message = <<-MESSAGE


  "Mushin is kinda Awesome, please ENJOY!" 
  		     ~ theotherstupidguy :)

  MESSAGE
end
