//
//  SearchTableModalClass.swift
//  IGMI Machine test
//
//  Created by Brijesh Ajudia on 02/09/22.
//

import Foundation

struct SearchTableModalClass: Decodable {
    let statusCode: Int?
    let message: String?
    let listed: [ListedBodyModalClass]?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case message = "message"
        case listed = "listed"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        listed = try values.decodeIfPresent([ListedBodyModalClass].self, forKey: .listed)
    }
}

struct ListedBodyModalClass: Decodable {
    let business_name: String?
    let image: String?
    let rating: String?
    let bID: String?
    let address: String?
    let description: String?
    let restaurant_type: [Restaurant_Type]?
    let time_available: [TimeAvailability]?
    let seat_available: String?
    let get_time: String?
    let service_provider: String?
    let price: Int?
    
    enum CodingKeys: String, CodingKey {
        case business_name = "business_name"
        case image = "image"
        case rating = "rating"
        case bID = "id"
        case address = "address"
        case description = "description"
        case restaurant_type = "restaurant_type"
        case time_available = "time_available"
        case seat_available = "seat_available"
        case get_time = "get_time"
        case service_provider = "service_provider"
        case price = "price"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        business_name = try values.decodeIfPresent(String.self, forKey: .business_name)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        rating = try values.decodeIfPresent(String.self, forKey: .rating)
        bID = try values.decodeIfPresent(String.self, forKey: .bID)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        restaurant_type = try values.decodeIfPresent([Restaurant_Type].self, forKey: .restaurant_type)
        time_available = try values.decodeIfPresent([TimeAvailability].self, forKey: .time_available)
        seat_available = try values.decodeIfPresent(String.self, forKey: .seat_available)
        get_time = try values.decodeIfPresent(String.self, forKey: .get_time)
        service_provider = try values.decodeIfPresent(String.self, forKey: .service_provider)
        
        do {
            price = try values.decodeIfPresent(Int.self, forKey: .price)
        } catch DecodingError.typeMismatch {
            price = try Int(values.decode(String.self, forKey: .price))
        }
        
    }
}

struct Restaurant_Type: Decodable {
    let name: String?
    let id: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case id = "id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        id = try values.decodeIfPresent(String.self, forKey: .id)
    }
}

struct TimeAvailability: Decodable {
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case time = "time"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        time = try values.decodeIfPresent(String.self, forKey: .time)
    }
}



// MARK: - Erroe Modal Class
enum NetworkError: LocalizedError {
    case couldNotConvertIntoDictionary(inside: String)
    case couldNotParse(message: String, code: Int)
    case badResponceStatusCode(_ code: Int)
    
    var errorDescription: String? {
        switch self {
        case .couldNotConvertIntoDictionary:
            return ""
        case .couldNotParse(let message, let code):
            return "\(message) with \(code)"
        case .badResponceStatusCode(let code):
            return "Bad response status code: \(code)"
        }
    }
}

struct GeneralError: LocalizedError {
    let message: String
    var errorDescription: String? { return message }
}

struct ErrorModalClass: Decodable {
    let statusCode: Int?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = try values.decodeIfPresent(Int.self, forKey: .statusCode)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }
    
}
