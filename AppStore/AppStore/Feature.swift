//
//  Feature.swift
//  AppStore
//
//  Created by Junsu Jang on 2022/05/16.
//

import Foundation

struct Feature: Decodable {
    let type: String
    let appName: String
    let description: String
    let imageURL: String
}
