//
//  APIConfiguration.swift
//  Users
//
//  Created by Adam on 30/06/2018.
//  Copyright © 2018 Adam Różański. All rights reserved.
//

import Foundation

protocol APIConfigurable {
    
    var baseUrl: String { get }
    var apiVersion: String { get }
}
