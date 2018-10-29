Pod::Spec.new do |s|
  s.name         = "TLTransitions"
  s.version      = "1.0.0"
  s.ios.deployment_target = '7.0'
  s.summary      = "Fast implement transitions for view or viewController "
  s.homepage     = "https://github.com/LoongerTao/TLTransitions"
  s.license      = "MIT"
  s.author             = { "Gxdy" => "495285195@qq.com" }
  s.source       = { :git => "https://github.com/LoongerTao/TLTransitions.git", :tag => s.version }
  s.source_files  = "TLTransitions/TLTransitions"
  s.requires_arc = true
end
