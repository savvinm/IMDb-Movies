//
//  IMDbService.swift
//  IMDbService Movies
//
//  Created by Maksim Savvin on 30.05.2022.
//

import Foundation
import Moya

public enum IMDbService {
    static private let key = "k_nrvtd8at"
    
    case inTheaters
    case comingSoon
    case mostPopular
    case title(id: String)
    case search(searchQuery: String)
}

extension IMDbService: TargetType {
    public var baseURL: URL {
        return URL(string: "https://imdb-api.com/en/API")!
    }
    
    public var path: String {
        switch self {
        case .inTheaters: return "/inTheaters/\(IMDbService.key)"
        case .comingSoon: return "/ComingSoon/\(IMDbService.key)"
        case .mostPopular: return "/MostPopularMovies/\(IMDbService.key)"
        case .title(let id): return "/Title/\(IMDbService.key)/\(id)"
        case .search(let searchQuery): return "/SearchMovie/\(IMDbService.key)/\(searchQuery)"
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
