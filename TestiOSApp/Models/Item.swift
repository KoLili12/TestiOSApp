//
//  User.swift
//  TestiOSApp
//
//  Created by Николай Жирнов on 28.11.2025.
//

import Foundation

struct Item: Codable, Sendable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
