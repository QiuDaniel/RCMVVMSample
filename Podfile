source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

workspace ‘RCMVVMSample’

target 'RCMVVMSampleLib’ do
    project 'RCMVVMSampleLib/RCMVVMSampleLib’

    # Logging
    pod 'CocoaLumberjack/Swift', '~> 3.2'

    # Reactive framework
    pod 'ReactiveSwift', '~> 2.0'

    # Networking Library with ReactiveSwift extension
    pod 'Moya/ReactiveSwift', '~> 9.0.0-alpha.1'

    # JSON Object mapper
    pod 'ObjectMapper', '~> 2.2'

    # Moya+ObjectMapper+ReactiveSwift Library
    pod 'Moya-ObjectMapper/ReactiveSwift', :git => 'https://github.com/albsala/Moya-ObjectMapper.git', :branch => 'reactiveswift'

    # Minimal edits required calculation utility to use with UITableVIew
    pod 'Changeset', '~> 2.1'

	target 'RCMVVMSampleLibTests’ do
	end
    
    target 'RCMVVMSampleView’ do
        project 'RCMVVMSampleView/RCMVVMSampleView'

        # Reactive extensions to Cocoa frameworks, built on top of ReactiveSwift
pod 'ReactiveCocoa', :path => '~/Documents/iPhone/ReactiveCocoa' #'~> 6.0'
        
    end
    
end
