//
//  Profile.swift
//  GithubProfile
//
//  Created by 김정호 on 4/12/24.
//

import Foundation

struct ProfileDTO: Decodable {
    let nickname: String
    let avatarUrl: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case nickname = "login"
        case avatarUrl = "avatar_url"
        case name
    }
}
