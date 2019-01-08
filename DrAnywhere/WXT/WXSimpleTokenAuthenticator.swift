//
//  SimpleTokenAuthenticator.swift
//  SparkSDKWrapper1_2
//
//  Created by Jonathan Field on 27/07/2017.
//  Copyright © 2017 Cisco. All rights reserved.
//

import Foundation
import WebexSDK

class WXSimpleTokenAuthenticator: Authenticator {
    
    private var accessToken: String?
    
    var authorized: Bool {
        return accessToken != nil
    }
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func deauthorize() {
        accessToken = nil
    }
    
    func accessToken(completionHandler: @escaping (String?) -> Void) {
        completionHandler(accessToken)
    }
    
    func refreshToken(completionHandler: @escaping (String?) -> Void) {
        
    }
}
