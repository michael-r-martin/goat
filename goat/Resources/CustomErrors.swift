//
//  CustomErrors.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import Foundation

enum DownloadValidationError: LocalizedError {
    case invalidID
    case apiError
    case noData
    case noDocument
    
    var errorDescription: String? {
        switch self {
        case .invalidID:
            return "We took an L fetching the data 🤨"
        case .apiError:
            return "We took an L fetching the data 🤨"
        case .noData:
            return "We took an L fetching the data 🤨"
        case .noDocument:
            return "We took an L fetching the data 🤨"
        }
    }
}

enum ParsingError: LocalizedError {
    case serializationError
    case decodingError
    case mappingError
    
    var errorDescription: String? {
        switch self {
        case .serializationError:
            return "We took an L processing the data 😭"
        case .decodingError:
            return "We took an L processing the data 😭"
        case .mappingError:
            return "We took an L processing the data 😭"
        }
    }
}
