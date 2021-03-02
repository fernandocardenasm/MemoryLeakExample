//
//  RemoteLoader.swift
//  MemoryLeaksExample
//
//  Created by Fernando Cardenas on 02.03.21.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping () -> Void)
}

final public class RemoteLoader {
    
    let url = URL(string: "https://some-url.com")!
    let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func load(completion: @escaping () -> Void) {
        client.get(from: url) { [weak self] in
            guard let self = self else { return }
            self.map()
            
            completion()
        }
    }
    
    private func map() {}
}

public class Client: HTTPClient {
 
    static let shared = Client()
    
    public func get(from url: URL, completion: @escaping () -> Void) {
        completion()
    }
}

public class TrackingService {
    static func trackEvent() {}
}
