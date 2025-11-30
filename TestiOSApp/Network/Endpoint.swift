//
//  Endpoint.swift
//  TestiOSApp
//
//  Created by Николай Жирнов on 30.11.2025.
//

import Foundation

enum Endpoint {
    static let baseURL = "https://jsonplaceholder.typicode.com"
    
    case items
    case avatar(id: Int)
    
    var url: URL {
        switch self {
        case .avatar(id: let id):
            return URL(string: "https://picsum.photos/seed/\(id)/200")!
        case .items:
            return URL(string: "\(Endpoint.baseURL)/posts")!
        }
    }
}
