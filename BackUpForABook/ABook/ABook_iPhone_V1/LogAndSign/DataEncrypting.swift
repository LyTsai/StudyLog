//
//  DataEncrypting.swift
//  ABook_iPhone_V1
//
//  Created by dingf on 17/5/16.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import CryptoSwift

class DataEncrypting{
    class func encrypt(_ stringToEncrypt: String) -> String {
        let iv: Array<UInt8> = [208, 150, 137, 78, 196, 223, 183, 70, 173,144, 59, 16, 194, 171, 235, 104]
        let key: Array<UInt8> = [84, 105, 103, 101, 114, 39, 115, 95, 99, 97, 118, 101, 73, 110, 65, 83]
        
        let aes = try! AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7())
        do {
            let ciphertext = try aes.encrypt(Array(stringToEncrypt.utf8))
            return ciphertext.toBase64()!
        } catch {
            print(error)
            return ""
        }
    }
}

