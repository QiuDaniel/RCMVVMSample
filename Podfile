source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

workspace ‘RCMVVMSample’

target 'RCMVVMSampleLib’ do
    project 'RCMVVMSampleLib/RCMVVMSampleLib’

    # Reactive framework
    pod 'ReactiveSwift', '~> 2.1.0-alpha.2'

    # Networking Library with ReactiveSwift extension
    pod 'Moya/ReactiveSwift', '~> 9.0.0'

    # Minimal edits required calculation utility to use with UITableVIew
    pod 'Changeset', '~> 2.1'

	target 'RCMVVMSampleLibTests’ do
	end
    
    target 'RCMVVMSampleView’ do
        project 'RCMVVMSampleView/RCMVVMSampleView'

        # Reactive extensions to Cocoa frameworks, built on top of ReactiveSwift
        pod 'ReactiveCocoa', '~> 6.1.0-alpha.2'

    end
    
end
