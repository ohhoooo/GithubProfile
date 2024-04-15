//
//  NetworkManager.swift
//  GithubProfile
//
//  Created by 김정호 on 4/12/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    let url = "https://api.github.com/users/"
    
    // (1) URLSession
    func fetchUserProfile(userName: String, completion: @escaping ((Result<ProfileDTO, Error>) -> Void)) {
        guard let url = URL(string: "\(self.url)\(userName)") else {
            completion(.failure(NSError(domain: "URL 변환에 실패했어요.", code: 401)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(NSError(domain: "Data가 없어요.", code: 402)))
                return
            }
            
            do {
                let profile = try JSONDecoder().decode(ProfileDTO.self, from: data)
                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // (2) Alamofire
    func fetchUserRepository(userName: String, page: Int, completion: @escaping ((Result<[RepositoryDTO], Error>) -> Void)) {
        guard let url = URL(string: "\(self.url)\(userName)/repos?page=\(page)") else {
            completion(.failure(NSError(domain: "URL 변환에 실패했어요.", code: 401)))
            return
        }
        
        AF.request(url, method: .get).responseDecodable(of: [RepositoryDTO].self) { response in
            switch response.result {
            case .success(let repositories):
                completion(.success(repositories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
