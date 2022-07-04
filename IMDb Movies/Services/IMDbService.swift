//
//  IMDbService.swift
//  IMDbService Movies
//
//  Created by Maksim Savvin on 30.05.2022.
//

import Foundation
import Moya

enum IMDbService {
    static private let key = "k_nrvtd8at"
    
    case inTheaters
    case comingSoon
    case mostPopular
    case title(id: String)
    case search(searchQuery: String)
    case image(url: String)
}

extension IMDbService: TargetType {
    public var baseURL: URL {
        switch self {
        case .inTheaters, .mostPopular, .comingSoon, .search, .title:
            return URL(string: "https://imdb-api.com")!
        case .image(let url):
            return URL(string: url)!
        }
    }
    
    public var path: String {
        switch self {
        case .inTheaters: return "/en/API/inTheaters/\(IMDbService.key)"
        case .comingSoon: return "/en/API/ComingSoon/\(IMDbService.key)"
        case .mostPopular: return "/en/API/MostPopularMovies/\(IMDbService.key)"
        case .title(let id): return "/en/API/Title/\(IMDbService.key)/\(id)"
        case .search(let searchQuery): return "/en/API/SearchMovie/\(IMDbService.key)/\(searchQuery)"
        case .image: return ""
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application.json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
