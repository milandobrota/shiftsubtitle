require 'rake'

Gem::Specification.new do |s| 
  s.name = "shiftsubtitle"
  s.version = "0.0.6"
  s.description = "This gem allows you to shift .SRT subtitles for a given number of seconds and milliseconds."
  s.author = "Milan Dobrota"
  s.email = "milan@milandobrota.com"
  s.homepage = "http://www.milandobrota.com"
  s.platform = Gem::Platform::RUBY
  s.summary = "This gem allows you to shift .SRT subtitles for a given number of seconds and milliseconds"
  s.files = FileList["{lib}/**/*"].to_a
  s.require_path = "lib"
  s.test_files = FileList["{spec}/**/*"].to_a
  s.has_rdoc = false
  s.extra_rdoc_files = ["README"]
end
