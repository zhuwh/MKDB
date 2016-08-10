#
#  Be sure to run `pod spec lint MKDB.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MKDB"
  s.version      = "1.0.2"
  s.summary      = "基于FMDB 的持久层操作库"
  s.homepage     = "https://github.com/zhuwh/MKDB"
  s.license      = "MIT"
  s.author             = { "mark" => "zhuwenhui5566@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/zhuwh/MKDB.git", :tag => s.version.to_s }
  s.source_files  = "**/DevFramework/Database/*.{h,m}"
  s.requires_arc = true
  s.dependency "FMDB"

end
