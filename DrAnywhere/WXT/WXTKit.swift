//
//  WXTKit.swift
//
//  Created by Jonathan Field on 30/04/2018.
//  Copyright © 2018 JonathanField. All rights reserved.
//

import UIKit

class WXTKit: NSObject {
    
    var apiKey: String?
    var authType: WXTManager.AuthenticationStrategy
    
    public init(apiKey: String?, authType: WXTManager.AuthenticationStrategy) {
        self.apiKey = apiKey
        self.authType = authType
        super.init()
    }
    
    //Init
    func activate(authenticationStatus: @escaping (_ status: Bool ) -> Void) {
        WXTManager.shared.authenticateWithWXT(apiKey: self.apiKey!, authType: self.authType) { (authenticated) in
            if authenticated {
                WXTManager.shared.registerDeviceWithWXT(deviceRegistrationState: { (registered) in
                    if registered == true {
                        print("Device registered with WXT")
                        authenticationStatus(true)
                    }
                    else {
                        print("Registration with WXT Failed")
                    }
                })
            }
            else {
                authenticationStatus(false)
            }
        }
    }
    
    //Auth
    
    
    //Constructor With Audio
    
    //1-1 Audio Call
    public func audioCall(recipient: String) {
        
    }
    
    public func audioCall(recipients: [String]) {
        
    }
    
    //1-1 Video Call
    public func videoCall(navigationController: UINavigationController, recipient: String, delegate: WXTeamsCallingDelegate) {
        let singleParticipantVideoCallController = WXTeamsCallingViewController(authType: self.authType, apiKey: self.apiKey!, delegate: delegate)
        navigationController.present(singleParticipantVideoCallController, animated: true, completion: {
            singleParticipantVideoCallController.startWXTCall(recipients: [recipient], mediaAccessType: .audioVideo)
        })
    }
    
    public func videoCall(navigationController: UINavigationController, recipients: [String], delegate: WXTeamsCallingDelegate) {
        let multiPartyVideoCallController = WXTeamsCallingViewController(authType: self.authType, apiKey: self.apiKey!, delegate: delegate)
        navigationController.present(multiPartyVideoCallController, animated: true) {
            multiPartyVideoCallController.startWXTCall(recipients: recipients, mediaAccessType: .audioVideo)
        }
    }
    
    //1-1 Message
    public func directMessage(navigationController: UINavigationController, recipient: String) {
        let directMessageViewController = WXTeamsDirectMessageViewController(recipient: "jonfiel@cisco.com", incomingMessageBubbleColor: nil, outgoingMessageBubbleColor: nil, incomingMessageTextColor: nil, outgoingMessageTextColor: nil)
        navigationController.present(directMessageViewController, animated: true) {
            
        }
    }

}
