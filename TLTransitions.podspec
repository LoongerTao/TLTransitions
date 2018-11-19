Pod::Spec.new do |s|
  s.name         = "TLTransitions"
  s.version      = "1.2.0"
  s.ios.deployment_target = '8.0'
  s.platform     = :ios, '8.0'
  s.summary      = "Fast implement transitions for view or viewController "
  s.homepage     = "https://github.com/LoongerTao/TLTransitions"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "LoongerTao" => "495285195@qq.com" }
  s.source       = { :git => "https://github.com/LoongerTao/TLTransitions.git", :tag => s.version }
  s.source_files  = "TLTransitions/**/*.{h,m}"
  s.public_header_files = 'TLTransitions/TLTransitionsHeader.h'
  # s.public_header_files = 'YYKit/**/*.{h}'
  s.requires_arc = true
end

s.subspec 'Transition View' do |ss|
    ss.source_files = 'TLTransitions/Transition View.{h,m}.{h,m}'
    ss.frameworks = 'Transition View'
end

s.subspec 'Transition View Controller' do |ss|
    ss.source_files = 'TLTransitions/Transition View Controller.{h,m}.{h,m}'
    ss.frameworks = 'Transition View Controller'
end

s.subspec 'Animator' do |ss|
    ss.source_files = 'TLTransitions/Transition View Controller/Animator.{h,m}.{h,m}'
    ss.frameworks = 'Animator'
end
