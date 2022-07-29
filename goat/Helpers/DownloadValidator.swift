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
    
    var validDataDictionary: [String: Any]
    var validData: Data
    
    var validDataDictionaryArray: [[String: Any]]
    var validDataArray: [Data]
    
    init(snapshot: DocumentSnapshot?, snapshotDocuments: QuerySnapshot?, error: Error?) {
        self.snapshot = snapshot
        self.snapshotDocuments = snapshotDocuments
        self.error = error
    }
 
    mutating func validateDocument() throws {
        guard error == nil else {
            throw DownloadValidationError.apiError
        }
        
        guard let snapshot = snapshot else {
            throw DownloadValidationError.noData
        }
        
        guard let data = snapshot.data() else {
            throw DownloadValidationError.noDocument
        }
        
        self.validDataDictionary = data
    }
    
    mutating func serializeDocumentIntoData() throws {
        do {
            let serializedData = try JSONSerialization.data(withJSONObject: validDataDictionary, options: [])
            
            self.validData = serializedData
        } catch {
            throw ParsingError.serializationError
        }
    }
    
    mutating func validateCollection() throws {
        var validData: [[String: Any]] = [[:]]
        
        guard error == nil else {
            throw DownloadValidationError.apiError
        }
        
        guard let snapshotDocuments = snapshotDocuments else {
            return
        }
        
        let documents = snapshotDocuments.documents
        
        for document in documents {
            let data = document.data()
            validData.append(data)
        }
        
        self.validDataDictionaryArray = validData
    }
    
    mutating func serializeCollectionIntoDataArray() throws {
        for item in validDataDictionaryArray {
            do {
                let serializedData = try JSONSerialization.data(withJSONObject: item, options: [])
                
                self.validDataArray.append(serializedData)
            } catch {
                throw ParsingError.serializationError
            }
        }
    }
}
