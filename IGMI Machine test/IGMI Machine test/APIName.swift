//
//  APIName.swift
//  IGMI Machine test
//
//  Created by Brijesh Ajudia on 02/09/22.
//

import Foundation
import Moya
import Alamofire


struct APIName {
    static let API_Base_URL = "https://igmiweb.com/gladdenhub/Api/"
    
    static let API_SearchTable = "search_table"
}

enum APIs {
    case getSearchTable(param: Parameters)
}

extension APIs: Moya.TargetType {
    var baseURL: URL {
        switch self {
        case .getSearchTable:
            return URL(string: APIName.API_Base_URL)!
        }
    }
    
    var path: String {
        switch self {
        case .getSearchTable(_):
            return APIName.API_SearchTable
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSearchTable:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getSearchTable(let paramater):
            return .requestParameters(parameters: paramater, encoding: URLEncoding.default)//JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getSearchTable:
            let headersParam: [String: String] = ["x-api-key": "NB10SKS20AS30"]
            return headersParam
        }
    }
}
