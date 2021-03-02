//
//  MemoryLeaksExampleTests.swift
//  MemoryLeaksExampleTests
//
//  Created by Fernando Cardenas on 02.03.21.
//

import XCTest
import MemoryLeaksExample

class MemoryLeaksExampleTests: XCTestCase {
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let client = ClientSpy()
        var sut: RemoteLoader? = RemoteLoader(client: client)

         var loadCalled = false
        sut?.load {
            loadCalled = true
        }

        sut = nil
        client.receivedCompletion?()

        XCTAssertFalse(loadCalled)
    }
    
    func test_load() {
        let sut = makeSUT()
        sut.load {}
    }
    
    func makeSUT(file: StaticString = #file, line: UInt = #line) -> RemoteLoader {
        let client = ClientSpy()
        let sut = RemoteLoader(client: client)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        
        return sut
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential Memory leak.", file: file, line: line)
        }
    }
}

class ClientSpy: HTTPClient {
    
    static let shared = ClientSpy()
    
    var receivedCompletion: (() -> Void)?
    func get(from url: URL, completion: @escaping () -> Void) {
        receivedCompletion = completion
    }
}
