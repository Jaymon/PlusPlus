# http://guides.cocoapods.org/syntax/podspec.html
Pod::Spec.new do |s|
  s.name = 'PlusPlus'
  s.version = '0.1.0'
  s.homepage = 'https://github.com/Jaymon/PlusPlus'
  s.source = { :git => "https://github.com/Jaymon/PlusPlus.git", :tag => s.version.to_s }
  s.platform = :ios, '8.0'
  s.license = 'MIT'
  s.summary = 'Handy categories with lots of helpful methods'
  s.author = { 'Jay Marcyes' => 'jay@marcyes.com' }
  # TODO -- make this read in the readme file
  s.description = '...'
  s.source_files = 'PlusPlus/*.{h,m}'
  s.requires_arc = true
end
