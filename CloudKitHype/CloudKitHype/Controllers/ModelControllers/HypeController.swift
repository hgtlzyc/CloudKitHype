//
//  HypeController.swift
//  CloudKitHype
//
//  Created by lijia xu on 8/9/21.
//

import UIKit
import CloudKit

enum HypeError: LocalizedError {
    case ckError(Error)
    case couldNotUnwrap
    
    var errorDescription: String? {
        return ""
    }
}

class HypeController {
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    static let shared = HypeController()
    
    var hypes: [Hype] = []
    
    
    func saveHype(with body: String, completion: @escaping (Result<Hype?, HypeError>) -> Void) {
        
        let newHype = Hype(body: body)
        
        let hypeRecord = CKRecord(hype: newHype)
        
        publicDB.save(hypeRecord) { record, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let record = record,
                  let savedHype = Hype(ckRecord: record) else {
                return completion(.failure(.couldNotUnwrap))
            }
            
            completion(.success(savedHype))
            
        }///End Of publicDB save
        
    }///End Of saveHype
    
    func fetchAllHypes(completion: @escaping (Result<[Hype], HypeError>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: HypeStrings.recordTypeKey, predicate: predicate)
    
        publicDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
            
            let fetchedHypes = records.compactMap{ Hype(ckRecord: $0) }
            
            self.hypes = fetchedHypes
            
            completion(.success(fetchedHypes))
            
        }///End Of publicDB.perform
    
    }///End Of fetchAllHypes
    
    
    // MARK: - Private Init
    private init() {}
    
}
