//
//  Repository.swift
//  IMDb Movies
//
//  Created by Maksim Savvin on 31.05.2022.
//

import Foundation
import Moya

struct FilmsRepository {
    
    func fetchTitle(movieId: String, complitionHandler: @escaping (Moya.Response?, Error?) -> Void) {
        let provider = MoyaProvider<IMDbService>()
        provider.request(.title(id: movieId)) { result in
            switch result {
            case .success(let response):
                complitionHandler(response, nil)
            case .failure(let error):
                complitionHandler(nil, error)
            }
        }
    }
    
    func fetchList(option: FilmsInteractor.ListOption, complitionHandler: @escaping (Moya.Response?, Error?) -> Void) {
        let provider = MoyaProvider<IMDbService>()
        let moyaOption: IMDbService
        switch option {
        case .inTheaters:
            moyaOption = .inTheaters
        case .comingSoon:
            moyaOption = .comingSoon
        case .mostPopular:
            moyaOption = .mostPopular
        }
        provider.request(moyaOption) { result in
            switch result {
            case .success(let response):
                complitionHandler(response, nil)
            case .failure(let error):
                complitionHandler(nil, error)
            }
        }
    }
}
