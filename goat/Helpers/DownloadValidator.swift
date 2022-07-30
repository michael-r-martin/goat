//
//  DownloadValidator.swift
//  goat
//
//  Created by Michael Martin on 29/07/2022.
//

import Foundation
import FirebaseFirestore

struct DownloadValidator {
    var snapshot: DocumentSnapshot?
    var snapshotDocuments: QuerySnapshot?
    var error: Error?
    
    init(snapshot: DocumentSnapshot?, snapshotDocuments: QuerySnapshot?, error: Error?) {
        self.snapshot = snapshot
        self.snapshotDocuments = snapshotDocuments
        self.error = error
    }
 
    mutating func validateDocument() throws -> [String: Any] {
        guard error == nil else {
            throw DownloadValidationError.apiError
        }
        
        guard let snapshot = snapshot else {
            throw DownloadValidationError.noData
        }
        
        guard let data = snapshot.data() else {
            throw DownloadValidationError.noDocument
        }
        
        return data
    }
    
    mutating func serializeDocumentIntoData(validDataDictionary: [String: Any]) throws -> Data {
        do {
            let serializedData = try JSONSerialization.data(withJSONObject: validDataDictionary, options: [])
            
            return serializedData
        } catch {
            throw ParsingError.serializationError
        }
    }
    
    mutating func validateCollection() throws -> [[String: Any]] {
        var validData: [[String: Any]] = [[:]]
        
        guard error == nil else {
            throw DownloadValidationError.apiError
        }
        
        guard let snapshotDocuments = snapshotDocuments else {
            throw DownloadValidationError.noData
        }
        
        let documents = snapshotDocuments.documents
        
        for document in documents {
            let data = document.data()
            validData.append(data)
        }
        
        return validData
    }
    
    mutating func serializeCollectionIntoDataArray(validDataDictionaryArray: [[String: Any]]) throws -> [Data] {
        var validDataArray: [Data] = []
        
        for item in validDataDictionaryArray {
            do {
                let serializedData = try JSONSerialization.data(withJSONObject: item, options: [])
                
                validDataArray.append(serializedData)
            } catch {
                throw ParsingError.serializationError
            }
        }
        
        return validDataArray
    }
}
