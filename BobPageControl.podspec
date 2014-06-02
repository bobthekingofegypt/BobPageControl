Pod::Spec.new do |s|
  s.name             = "BobPageControl"
  s.version          = "0.1.1"
  s.summary          = "A UIPageControl alternative that supports animating page removal"
  s.description      = <<-DESC
                        Basic implementation of a UIPageControl alternative.  Allows you to remove pages with a simple animation effect.
                       DESC
  s.license          = 'MIT'
  s.author           = { "bob" => "bobthekingofegypt@googlemail.com" }
  s.source           = { :git => "https://github.com/bobthekingofegypt/BobPageControl.git", :tag => s.version.to_s }
  s.homepage         = "http://bobstuff.org/"

  s.platform = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'Classes'
end
