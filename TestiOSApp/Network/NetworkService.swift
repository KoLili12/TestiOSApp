//
//  NetworkService.swift
//  TestiOSApp
//
//  Created by Николай Жирнов on 28.11.2025.
//

import Foundation


enum NetworkServiceError: Error {
    case invalidURL
    case serializationError(Error)
    case badDataError
    case badServerResponse
}

struct NetworkService {
    func loadData<DecodeType: Decodable>(url: URL, type: DecodeType.Type, completion: @escaping (Result<DecodeType, NetworkServiceError>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            if error != nil {
                completion(.failure(.invalidURL))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidURL))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.badServerResponse))
                return
            }
            
            do {
                guard let data else {
                    throw URLError(.badServerResponse)
                }
                let decode = try JSONDecoder().decode(type, from: data)
                completion(.success(decode))
            } catch let error {
                completion(.failure(.serializationError(error)))
            }
        }
        task.resume()
    }
}
