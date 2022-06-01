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
    case top250
}

extension IMDbService: TargetType {
    public var baseURL: URL {
        return URL(string: "https://imdb-api.com/en/API")!
    }
    
    public var path: String {
        switch self {
        case .inTheaters: return "/inTheaters/\(IMDbService.key)"
        case .comingSoon: return "/ComingSoon/\(IMDbService.key)"
        case .top250: return "/Top250Movies/\(IMDbService.key)"
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
