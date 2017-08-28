# MVVM ReactiveSwift/ReactiveCocoa Swift Sample App

Given the lack of documentation about how to build a real app using ReactiveSwift/ReactiveCocoa, I decided to try them out by myself, putting different pieces together. I found some articles (see References) about very specific and isolated features of the libraries and how to use them to implement the [Model-View-ViewModel (MVVM) Pattern](https://en.wikipedia.org/wiki/Model–view–viewmodel). Nonetheless, I was not only interested in knowing how to use them to comunicate Views and ViewModels, but also how far I could get using reactive programming building an iOS app.

This is the result and I hope it is useful for someone else.

## Used libraries

* [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) 2.0 & [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) 6.0
* [ObjectMapper](https://github.com/Hearst-DD/ObjectMapper) 2.2
* [Moya](https://github.com/Moya/Moya/releases) 9.0
* [Moya-ObjectMapper](https://github.com/ivanbruel/Moya-ObjectMapper) 2.3
* [Changeset](https://github.com/osteslag/Changeset) 2.1

## Quick Start
Clone/Download the sample app, open `RCMVVMSample.xcworkspace` and run the RCMVVMSampleView schema. Dependencies are included for simplicity.
Check `RCMVVMSampleView` ViewControllers, and `RCMVVMSampleLib` ViewModels and BackendClient.

## App functionality

The app shows a UITabBarController with **two UITableViewControllers using two different approaches to refresh data**. One of them uses UITableView.reloadData() and the other uses batch updates (using [Changeset](https://github.com/osteslag/Changeset)), yet both use reactive extensions.

## Workspace and projects
There is a workspace with three projects: 

* `Pods`: Cocoapods project
* `RCMVVMSampleLib`: Model-ViewModels and BackendClient. This is where backend client, business and viewmodels logic goes. It can be shared and tested easier and quicker since it has no host application.
* `RCMVVMSampleView`: View. This is where only view-code goes.

## ReactiveSwift/ReactiveCocoa features used/shown

* Signal and SignalProducer creation, subscription (observation) and extension
* Map, filter, flatten, collect, retry, throttle
* MutableProperties
* Actions and CocoaActions
* Bindings of actions, properties and UI controls

## Testing

You can find some unit test in the `RCMVVMSampleLibTests` target that show how to test methods that use ReactiveSwift. It helped me a lot to understand Signals and SignalProducers. You should check them out even though you are not interested in unit testing.

## TODO

* Check retain cycles
* Some navigation


## References

* [ReactiveCocoa 3.0 - Signal producers and API clarity](http://blog.scottlogic.com/2015/04/28/reactive-cocoa-3-continued.html)
* [Exploring the Signal and SignalProducer objects in ReactiveSwift 1.1](https://gist.github.com/zxzxlch/9f9ff9e200f15d3f0aa7fee376d650b5)
* Reactive Swift Tutorial [Part 1](https://grillbiff.github.io/reactive_swift_part_1/), [Part 2](https://grillbiff.github.io/reactive_swift_part_2/)
* [Reactive Cocoa Actions](https://grillbiff.github.io/actions/)
* [MVVM + ReactiveCocoa 5](https://blog.joanzapata.com/mvvm-reactivecocoa-5/)
* [ReactiveCocoa 4 - Action](http://blog.brightinventions.pl/reactivecocoa-4-action/)
* [MVVM + Swift + ReactiveCocoa 5](https://medium.com/@hilmarbirgir/mvvm-swift-reactivecocoa-5-44274edaa56e)
* 