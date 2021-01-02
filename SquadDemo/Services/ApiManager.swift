//
//  ApiManager.swift
//  SquadDemo
//
//  Created by Sandip  on 01/01/21.
//

import Foundation
import Combine


protocol ApimanagerProtocol {
    func getCricketData<T:Codable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(_ result: AnyPublisher<T,Error>)-> Void)
}

class Apimanager: ApimanagerProtocol {
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func getCricketData<T>(requestUrl: URL, resultType: T.Type, completionHandler: @escaping (AnyPublisher<T,Error>) -> Void) where T : Decodable, T : Encodable {
        
        let _ = completionHandler(URLSession.shared.dataTaskPublisher(for: requestUrl).map{$0.data}.decode(type: T.self, decoder: JSONDecoder()).receive(on: DispatchQueue.main).eraseToAnyPublisher())
        
    }
}

