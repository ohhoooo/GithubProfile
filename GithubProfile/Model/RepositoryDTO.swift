//
//  Repository.swift
//  GithubProfile
//
//  Created by 김정호 on 4/12/24.
//

import Foundation

struct RepositoryDTO: Decodable {
    let name: String
    let language: String?
}
