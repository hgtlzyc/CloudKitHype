//
//  Hype.swift
//  CloudKitHype
//
//  Created by lijia xu on 8/9/21.
//

import UIKit
import CloudKit

struct HypeStrings {
    static let recordTypeKey = "Hype"
    fileprivate static let bodyKey = "body"
    fileprivate static let timestampKey = "timestamp"
    
}


class Hype {
    
    var body: String
    var timestamp: Date
    
    internal init(body: String, timeStamp: Date = Date()) {
        self.body = body
        self.timestamp = timeStamp
    }
    
}///End Of Hype

extension Hype {
    
    convenience init?(ckRecord: CKRecord) {
        guard let body = ckRecord[HypeStrings.bodyKey] as? String,
              let timestamp = ckRecord[HypeStrings.timestampKey] as? Date else { return nil }
        
        self.init(body: body, timeStamp: timestamp)
        
    }
    
}///End Of Hype Ext

// MARK: - Ext CKRecord
extension CKRecord {
    convenience init(hype: Hype) {
        self.init(recordType: "Hype")
        
        self.setValuesForKeys([
            HypeStrings.bodyKey : hype.body,
            HypeStrings.timestampKey : hype.timestamp
        
        ])
        
    }///End Of conv init

}///End Of CKRecord Extension


