import Foundation
import ReactiveSwift
#if !COCOAPODS
import Moya
#endif

/// Extension for processing raw NSData generated by network access.
extension SignalProducerProtocol where Value == Response, Error == MoyaError {

    /// Filters out responses that don't fall within the given range, generating errors when others are encountered.
    public func filter(statusCodes: ClosedRange<Int>) -> SignalProducer<Value, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<Value, Error> in
            return unwrapThrowable { try response.filter(statusCodes: statusCodes) }
        }
    }

    public func filter(statusCode: Int) -> SignalProducer<Value, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<Value, MoyaError> in
            return unwrapThrowable { try response.filter(statusCode: statusCode) }
        }
    }

    public func filterSuccessfulStatusCodes() -> SignalProducer<Value, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<Value, MoyaError> in
            return unwrapThrowable { try response.filterSuccessfulStatusCodes() }
        }
    }

    public func filterSuccessfulStatusAndRedirectCodes() -> SignalProducer<Value, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<Value, MoyaError> in
            return unwrapThrowable { try response.filterSuccessfulStatusAndRedirectCodes() }
        }
    }

    /// Maps data received from the signal into an Image. If the conversion fails, the signal errors.
    public func mapImage() -> SignalProducer<Image, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<Image, MoyaError> in
            return unwrapThrowable { try response.mapImage() }
        }
    }

    /// Maps data received from the signal into a JSON object. If the conversion fails, the signal errors.
    public func mapJSON(failsOnEmptyData: Bool = true) -> SignalProducer<Any, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<Any, MoyaError> in
            return unwrapThrowable { try response.mapJSON(failsOnEmptyData: failsOnEmptyData) }
        }
    }

    /// Maps received data at key path into a String. If the conversion fails, the signal errors.
    public func mapString(atKeyPath keyPath: String? = nil) -> SignalProducer<String, MoyaError> {
        return producer.flatMap(.latest) { response -> SignalProducer<String, MoyaError> in
            return unwrapThrowable { try response.mapString(atKeyPath: keyPath) }
        }
    }
}

/// Maps throwable to SignalProducer.
private func unwrapThrowable<T>(throwable: () throws -> T) -> SignalProducer<T, MoyaError> {
    do {
        return SignalProducer(value: try throwable())
    } catch {
        if let error = error as? MoyaError {
            return SignalProducer(error: error)
        } else {
            // The cast above should never fail, but just in case.
            return SignalProducer(error: MoyaError.underlying(error as NSError, nil))
        }
    }
}