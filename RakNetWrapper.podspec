Pod::Spec.new do |s|

  s.name                    = "RakNetWrapper"
  s.summary                 = "RakNetWrapper – Objective-C wrapper for RakNet library"
  s.homepage                = 'https://github.com/ss-abramchuk/raknet-wrapper'
  s.author                  = { "Sergey Abramchuk" => "ss.abramchuk@gmail.com" }
  s.version                 = "0.1.0"
  s.license                 = "BSD"

  s.ios.deployment_target   = "9.0"
  s.osx.deployment_target   = "10.11"

  s.source                  = { :git => "https://github.com/ss-abramchuk/raknet-wrapper.git", :branch => "master" }

  s.source_files            = "Sources/Vendors/RakNet/*.{h,cpp}", "Sources/Wrapper/*.{h,mm}"

  s.public_header_files     = "Sources/Wrapper/*.h"
  s.private_header_files    = "Sources/Wrapper/*\+Internal.h"

  s.requires_arc            = true
  s.compiler_flags          = '-std=gnu++98'

end
