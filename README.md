# Framework-based MVVM ReactiveSwift/ReactiveCocoa iOS Sample App

![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg) ![iOS 10.3.x](https://img.shields.io/badge/iOS-10.3.x-orange.svg) [![Build Status](https://travis-ci.org/albsala/RCMVVMSample.svg?branch=master)](https://travis-ci.org/albsala/RCMVVMSample)

Given the lack of documentation about how to build a real app using ReactiveSwift/ReactiveCocoa, I decided to try them out by myself, putting different pieces together. I found some articles (see [References](#references)) about very specific and isolated features of the libraries and how to use them to implement the [Model-View-ViewModel (MVVM) Pattern](https://en.wikipedia.org/wiki/Model–view–viewmodel). Nonetheless, I was not only interested in knowing how to use them to comunicate Views and ViewModels, but also how far I could get using reactive programming to build an iOS app. I hope it is useful for somebody else.

## Used libraries

* [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) 2.1.0-alpha.2 
* [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) 6.1.0-alpha.2 ([Pull request](https://github.com/ReactiveCocoa/ReactiveCocoa/pull/3504)) Set manually to Swift 3.2
* [Moya](https://github.com/Moya/Moya/releases) 9.0
* [Changeset](https://github.com/osteslag/Changeset) 2.1
* <s>ObjectMapper, Moya-ObjectMapper</s> [Swift Encoding and Decoding](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)

## Quick Start
Just clone/download the sample app, open `RCMVVMSample.xcworkspace` with Xcode and run the RCMVVMSampleView schema. Dependencies are included for simplicity.

Check `RCMVVMSampleView` ViewControllers, `RCMVVMSampleLib` ViewModels and BackendClient, and `RCMVVMSampleLibTests`.

## App functionality

The app shows a UITabBarController with **two UITableViewControllers using two different approaches to refresh data**. One of them uses UITableView.reloadData() and the other uses batch updates (using [Changeset](https://github.com/osteslag/Changeset)), yet both use reactive extensions.

## Workspace and projects
There is a workspace with three projects: 

* `Pods`: Cocoapods project
* `RCMVVMSampleLib`: MVVM's ViewModels and BackendClient. *Since the main purpose of the project is showing how ReactiveSwift/ReactiveCocoa can be used to build a "real" app, there is only one framework for everything but the iOS View layer. Check [Framework Oriented Programming](http://frameworkoriented.io) if you need further information.*
* `RCMVVMSampleView`: MVVM's iOS View.

## ReactiveSwift/ReactiveCocoa features used/shown

* Signal and SignalProducer creation, subscription (observation) and extension
* Map, attemptMap, mapError, filter, flatten, collect, retry, throttle
* MutableProperties
* Actions and CocoaActions
* Bindings of actions, properties and UI controls
* Error Handling

## Back-end

The app uses [Moya](https://github.com/Moya/Moya/releases) and stubs responses (`itemsResponse.json`) so you do not have to worry about the Back-end.

## Testing

You can find some unit test in the `RCMVVMSampleLibTests` target that show how to test methods that use ReactiveSwift. It helped me a lot to understand Signals and SignalProducers. You should check them out even though you are not interested in unit testing.

## TODO

* Check retain cycles
* Some navigation
* RCMVVMSampleView testing


## References

* [ReactiveCocoa 3.0 - Signal producers and API clarity](http://blog.scottlogic.com/2015/04/28/reactive-cocoa-3-continued.html)
* [Exploring the Signal and SignalProducer objects in ReactiveSwift 1.1](https://gist.github.com/zxzxlch/9f9ff9e200f15d3f0aa7fee376d650b5)
* Reactive Swift Tutorial [Part 1](https://grillbiff.github.io/reactive_swift_part_1/), [Part 2](https://grillbiff.github.io/reactive_swift_part_2/)
* [Reactive Cocoa Actions](https://grillbiff.github.io/actions/)
* [MVVM + ReactiveCocoa 5](https://blog.joanzapata.com/mvvm-reactivecocoa-5/)
* [ReactiveCocoa 4 - Action](http://blog.brightinventions.pl/reactivecocoa-4-action/)
* [MVVM + Swift + ReactiveCocoa 5](https://medium.com/@hilmarbirgir/mvvm-swift-reactivecocoa-5-44274edaa56e)