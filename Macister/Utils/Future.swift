//
//  Future.swift
//  Microfutures
//
//  Created by Fernando on 27/1/17.
//  Copyright © 2017 Fernando. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case failure(String)
}

public struct Future<T> {
    public typealias ResultType = Result<T>

    private let operation: (@escaping (ResultType) -> ()) -> ()

    public init(result: ResultType) {
        self.init(operation: { completion in
            completion(result)
        })
    }

    public init(value: T) {
        self.init(result: .success(value))
    }

    public init(error: String) {
        self.init(result: .failure(error))
    }

    public init(operation: @escaping (@escaping (ResultType) -> ()) -> ()) {
        self.operation = operation
    }

    fileprivate func then(_ completion: @escaping (ResultType) -> ()) {
        self.operation() { result in
            completion(result)
        }
    }

    public func subscribe(onNext: @escaping (T) -> Void = { _ in
    }, onError: @escaping (String) -> Void = { _ in
    }) {
        self.then { result in
            switch result {
            case .success(let value): onNext(value)
            case .failure(let error): onError(error)
            }
        }
    }
    
    public func execute() {
        self.subscribe()
    }
}

extension Future {
    public func map<U>(_ f: @escaping (T) throws -> U) -> Future<U> {
        return Future<U>(operation: { completion in
            self.then { result in
                switch result {
                case .success(let resultValue):
                    do {
                        let transformedValue = try f(resultValue)
                        completion(Result.success(transformedValue))
                    } catch let error {
                        completion(Result.failure(error.localizedDescription))
                    }

                case .failure(let errorBox):
                    completion(Result.failure(errorBox))
                }
            }
        })
    }
    
    public func check(_ f: @escaping (T) throws -> String?) -> Future<T> {
        return Future<T>(operation: { completion in
            self.then { result in
                switch result {
                case .success(let resultValue):
                    do {
                        let transformedValue = try f(resultValue)
                        if (transformedValue == nil || transformedValue!.isEmpty) {
                            completion(result)
                        } else {
                            completion(Result.failure(transformedValue!))
                        }
                    } catch let error {
                        completion(Result.failure(error.localizedDescription))
                    }
                    
                case .failure(let errorBox):
                    completion(Result.failure(errorBox))
                }
            }
        })
    }
    
    public func onFailure(_ f: @escaping (String) -> Void) -> Future<T> {
        return Future<T>(operation: { completion in
            self.then { result in
                switch result {
                case .success(let _):
                    completion(result)
                    
                case .failure(let errorBox):
                    f(errorBox)
                    completion(Result.failure(errorBox))
                }
            }
        })
    }

    public func peek(_ f: @escaping (T) throws -> Void) -> Future<T> {
        return self.map({ obj throws in
            try f(obj)
            return obj
        })
    }

    public func flatMap<U>(_ f: @escaping (T) -> Future<U>) -> Future<U> {
        return Future<U>(operation: { completion in
            self.then { firstFutureResult in
                switch firstFutureResult {
                case .success(let value): f(value).then(completion)
                case .failure(let error): completion(Result.failure(error))
                }
            }
        })
    }
    
    public func done() -> Future<NSNull> {
        return self.map({ _ in
            return NSNull()
        })
    }
}
