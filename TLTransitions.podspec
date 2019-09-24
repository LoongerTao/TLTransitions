
Pod::Spec.new do |s|
  s.name         = 'TLTransitions'
  s.version      = '1.4.9'
  s.license      = 'MIT'
  s.ios.deployment_target = '8.0'
  s.platform     = :ios, '8.0'
  s.summary      = 'Fast implement transitions for view or viewController'
  s.homepage     = 'https://github.com/LoongerTao/TLTransitions'
  s.author       = { 'LoongerTao' => '495285195@qq.com' }
  s.requires_arc = true
  s.source       = { :git => 'https://github.com/LoongerTao/TLTransitions.git', :tag => s.version }
  s.public_header_files = 'TLTransitions/TLTransitions.h'
  s.source_files = 'TLTransitions/TLTransitions.h'
  
  

  s.subspec 'Config' do |cfg|
      cfg.source_files = 'TLTransitions/Config/*.{h,m}'
      cfg.ios.frameworks = 'UIKit'
  end

  s.subspec 'TransitionView' do |tv|
      tv.source_files = 'TLTransitions/TransitionView/*.{h,m}'
      tv.dependency 'TLTransitions/Config'
  end

  

  s.subspec 'TransitionController' do |tc|
      tc.source_files = 'TLTransitions/TransitionController/*.{h,m}'
      tc.dependency 'TLTransitions/Config' 

      tc.subspec 'Animator' do |anm|
          anm.source_files = 'TLTransitions/TransitionController/Animator/*.{h,m}'
          anm.dependency 'TLTransitions/Config'
      end
  end
end


# 错误：xcodebuild: Returned an unsuccessful exit code. 
# 一般是有头文件相互依赖，pod检测通不过
#

# [!] There was an error pushing a new version to trunk: execution expired
# 网络问题，更换网络

