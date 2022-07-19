//
//  Observable+bind.swift
//  Carol
//
//  Created by Vi Nguyen on 20/07/2022.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}

public extension ObservableType {

    /**
     Invokes an action for each Next event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    // @warn_unused_result(message:"http://git.io/rxs.uo")
    func doOnNext(_ onNext: @escaping (Element) throws -> Void) -> Observable<Element> {
        return self.do(onNext: onNext)
    }

    /**
     Invokes an action for the Error event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    // @warn_unused_result(message:"http://git.io/rxs.uo")
    func doOnError(_ onError: @escaping (Swift.Error) throws -> Void) -> Observable<Element> {
        return self.do(onError: onError)
    }

    /**
     Invokes an action for the Completed event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    // @warn_unused_result(message:"http://git.io/rxs.uo")
    func doOnCompleted(_ onCompleted: @escaping () throws -> Void) -> Observable<Element> {
        return self.do(onCompleted: onCompleted)
    }

    /**
     Subscribes an element handler to an observable sequence.
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    // @warn_unused_result(message: "http://git.io/rxs.ud")
    func subscribeNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        return self.subscribe(onNext: onNext)
    }

    /**
     Subscribes an error handler to an observable sequence.
     
     - parameter onError: Action to invoke upon errored termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    // @warn_unused_result(message: "http://git.io/rxs.ud")
    func subscribeError(_ onError: @escaping (Swift.Error) -> Void) -> Disposable {
        return self.subscribe(onError: onError)
    }

    /**
     Subscribes a completion handler to an observable sequence.
     
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    // @warn_unused_result(message: "http://git.io/rxs.ud")
    func subscribeCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        return self.subscribe(onCompleted: onCompleted)
    }
}

// MARK: - RxCocoa

public extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {

    /**
     Invokes an action for each Next event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    // @warn_unused_result(message:"http://git.io/rxs.uo")
    func doOnNext(_ onNext: @escaping (Element) -> Void) -> Driver<Element> {
        return self.do(onNext: onNext)
    }

    /**
     Invokes an action for the Completed event in the observable sequence, and propagates all observer messages through the result sequence.
     
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: The source sequence with the side-effecting behavior applied.
     */
    // @warn_unused_result(message:"http://git.io/rxs.uo")
    func doOnCompleted(_ onCompleted: @escaping () -> Void) -> Driver<Element> {
        return self.do(onCompleted: onCompleted)
    }

    /**
     Subscribes an element handler to an observable sequence.
     
     - parameter onNext: Action to invoke for each element in the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    // @warn_unused_result(message: "http://git.io/rxs.ud")
    func driveNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        return self.drive(onNext: onNext)
    }

    /**
     Subscribes a completion handler to an observable sequence.
     
     - parameter onCompleted: Action to invoke upon graceful termination of the observable sequence.
     - returns: Subscription object used to unsubscribe from the observable sequence.
     */
    // @warn_unused_result(message: "http://git.io/rxs.ud")
    func driveCompleted(_ onCompleted: @escaping () -> Void) -> Disposable {
        return self.drive(onCompleted: onCompleted)
    }
}

extension ObservableType {
    public func unwrap<T>() -> Observable<T> where Element == T? {
        return self
            .filter { value in
                if case .some = value {
                    return true
                }
                return false
            }.map { $0! }
    }
}

extension SharedSequenceConvertibleType {
    
    public func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
    public func mapToOptional() -> SharedSequence<SharingStrategy, Element?> {
        return map { value -> Element? in value }
    }
    
    public func unwrap<T>() -> SharedSequence<SharingStrategy, T> where Element == T? {
        return self
            .filter { value in
                if case .some = value {
                    return true
                }
                return false
            }.map { $0! }
    }
}

extension ObservableType {
    
    public func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    public func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
    
    public func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    public func mapToOptional() -> Observable<Element?> {
        return map { value -> Element? in value }
    }
}

private func getThreadName() -> String {
    if Thread.current.isMainThread {
        return "Main Thread"
    } else if let name = Thread.current.name {
        if name == "" {
            return "Anonymous Thread"
        }
        return name
    } else {
        return "Unknown Thread"
    }
}

extension ObservableType {
    public func dump() -> Observable<Self.Element> {
        return self.do(onNext: { element in
            let threadName = getThreadName()
            print("[D] \(element) received on \(threadName)")
        })
    }
    
    public func dumpingSubscription() -> Disposable {
        return self.subscribe(onNext: { element in
            let threadName = getThreadName()
            print("[S] \(element) received on \(threadName)")
        })
    }
}
