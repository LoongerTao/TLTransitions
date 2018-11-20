Pod::Spec.new do |s|
  s.name         = 'TLTransitions'
  s.version      = '1.2.1'
  s.license  = 'MIT'
  s.ios.deployment_target = '8.0'
  s.platform     = :ios, '8.0'
  s.summary      = 'Fast implement transitions for view or viewController'
  s.homepage     = 'https://github.com/LoongerTao/TLTransitions'
  s.author       = { 'LoongerTao' => '495285195@qq.com' }
  s.requires_arc = true
  s.source       = { :git => 'https://github.com/LoongerTao/TLTransitions.git', :tag => s.version }
  # s.public_header_files = 'TLTransitions/TLTransitionHeader.h'
  s.source_files  = 'TLTransitions/TLGlobalConfig.{h,m}', 'TLTransitions/TLTransitionHeader.h'
 


  # s.subspec 'TransitionView' do |ss|
  #     ss.source_files = 'TLTransitions/TransitionView/*.{h,m}'
  # end

  # s.subspec 'TransitionViewController' do |ss|
  #     ss.source_files = 'TLTransitions/TransitionViewController/*.{h,m}'
  # end

  # s.subspec 'Animator' do |ss|
  #     ss.source_files = 'TLTransitions/TLTransitions/*Animator.{h,m}', 'TLTransitions/TLTransitions/TLAnimatorProtocol.h'
  # end
end