//
//  APIManager.swift
//  IGMI Machine test
//
//  Created by Brijesh Ajudia on 02/09/22.
//

import Foundation
import Moya
import Alamofire


class AlamofireSession: Alamofire.Session {
    static let shared: AlamofireSession = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 60 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 60 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return AlamofireSession(configuration: configuration)
    }()
}


struct APIManager {
    static let authPlugin = AccessTokenPlugin { _ in ((UserDefaults.standard.object(forKey: "") as? String) ?? "") }
    static let sessionAuthPlugin = AccessTokenPlugin { _ in ((UserDefaults.standard.object(forKey: "") as? String) ?? "") }
    let provider = MoyaProvider<APIs>(session: AlamofireSession.shared, plugins: [authPlugin])
    let sessionProvider = MoyaProvider<APIs>(session: AlamofireSession.shared, plugins: [sessionAuthPlugin])
    
    fileprivate var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    static let sharedInstance : APIManager = {
        let instance = APIManager()
        return instance
    }()
    
    // MARK: - API Get Search table Data
    func api_GetSearchtTableData(_ callback: ((_ modalClass: SearchTableModalClass?, _ error: Error?)-> Void)?) {
        let param: Parameters = ["date": "2021-4-16",
                                 "time": "10:30",
                                 "person": "2",
                                 "latitude": "53.798407",
                                 "longitude": "-1.548248"]
        provider.request(.getSearchTable(param: param)) { result in
            switch result {
            case .success(let response):
                do {
                    switch response.statusCode {
                    case 200:
                        let dataFetch = try? self.decoder.decode(SearchTableModalClass.self, from: response.data)
                        callback?(dataFetch, nil)
                    default:
                        let errorFetch = try? self.decoder.decode(ErrorModalClass.self, from: response.data)
                        let error = NetworkError.couldNotParse(message: errorFetch?.message ?? "", code: errorFetch?.statusCode ?? 0)
                        callback?(nil, error)
                    }
                }
            case.failure(let error):
                callback?(nil, error)
            }
        }
    }
}
