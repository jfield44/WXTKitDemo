//
//  SparkContext.swift
//  SparkSDKWrapper1_2
//
//  Created by Jonathan Field on 26/07/2017.
//  Copyright © 2017 Cisco. All rights reserved.
//

import Foundation
import SparkSDK

///*Spark* object is the entry point to use this Cisco Spark iOS SDK
///This app simplely use one Spark instance to demo all the SDK function.
public class WXTManager: NSObject {
    
    //Enums
    public enum AuthenticationStrategy {
        case sparkId, oAuth, guestId
    }
    
    static let shared: WXTManager = WXTManager()
    var spark: Spark?
    ///Authorized user
    var selfInfo :Person?
    ///The recent active call
    var call: Call?
    
    ///Make sure hangup the last call before your create a new one.
    func deinitCall() {
        guard call != nil else {
            return
        }
        // NOTE: Disconnects this call,Otherwise error will occur and completionHandler will be dispatched.
        call?.hangup() { error in
            
        }
        self.call = nil
    }
    
    /// - note: When the user log out,you must delloc the spark to release the memory.
    func deinitSpark() {
        guard spark != nil else {
            return
        }
        
        if call != nil {
            deinitCall()
        }
        
        // Removes this *phone* from Cisco Spark cloud on behalf of the authenticated user.
        // It also disconnects the websocket from Cisco Spark cloud.
        // Subsequent invocations of this method behave as a no-op.
        spark!.phone.deregister() { ret in
            // Deauthorizes the current user and clears any persistent state with regards to the current user.
            // If the *phone* is registered, it should be deregistered before calling this method.
            self.spark?.authenticator.deauthorize()
            self.selfInfo = nil
            self.spark = nil
        }
        
    }
    
    /// Create OAuth Authenticator helper function
    /// An [OAuth](https://oauth.net/2/) based authentication strategy
    /// is to be used to authenticate a user on Cisco Spark.
//    static func getOAuthStrategy() -> OAuthAuthenticator {
//        return OAuthAuthenticator(clientId: SparkEnvirmonment.ClientId, clientSecret: SparkEnvirmonment.ClientSecret, scope: SparkEnvirmonment.Scope, redirectUri: SparkEnvirmonment.RedirectUri)
//    }
    
    /// Log in with Spark ID helper function
    static func initSparkForSparkIdLogin(apiKey: String) {
        let authenticator = WXSimpleTokenAuthenticator(accessToken: apiKey)
        WXTManager.shared.spark = Spark(authenticator: authenticator)
//        SparkContext.sharedInstance.spark = Spark(authenticator: SparkContext.getOAuthStrategy())
//        Register a console logger into SDK
//        SparkContext.sharedInstance.spark?.logger = KSLogger()
    }
    
//    / Log in with App ID helper function
//    / A [JSON Web Token](https://jwt.io/introduction) (JWT) based authentication strategy
//    / is to be used to authenticate a guest user on Cisco Spark.
    static func initSparkForJWTLogin(apiKey: String) {
        
        let jwtAuthStrategy = JWTAuthenticator()
        jwtAuthStrategy.authorizedWith(jwt: apiKey)
        if jwtAuthStrategy.authorized == true {
            print("JWT Authorised")
            /* JWT Login success process codes here....*/
            WXTManager.shared.spark = Spark(authenticator: jwtAuthStrategy)
        } else {
            /* JWT Login failure process codes here....*/
            print("JWT Login Error")
        }
    }
    
    static func activeUser(completion: @escaping (_ person: Person) -> Void) {
        WXTManager.shared.spark?.people.getMe(completionHandler: { (person) in
            print("In the loop")
            print("ME \(person.result)")
           completion(person.result.data!)
        })
    }
    
    /**
     Initial Authentication to Spark
     - parameter apiKey: Spark Access Token from www.developer.ciscospark.com
     */
    func authenticateWithWXT(apiKey: String, authType: AuthenticationStrategy, authenticationState: @escaping (_ status: Bool ) -> Void){
        if authType == .sparkId {
            WXTManager.initSparkForSparkIdLogin(apiKey: apiKey)
            authenticationState(true)
        }
        else if authType == .guestId {
            WXTManager.initSparkForJWTLogin(apiKey: apiKey)
            authenticationState(true)
        }
        WXTManager.shared.spark?.phone.disableVideoCodecActivation()
    }
    
    /**
     Register this instance of the Media SDK with the Spark Cloud for Outgoing Calls
     - parameter successfulRegistration: Triggered if the instance of the Media SDK was registered with the Spark Cloud successfully
     - parameter unSuccessfulRegistration: Triggered if the instance of the Media SDK was unable to register with the Spark Cloud
     */
    func registerDeviceWithWXT(deviceRegistrationState: @escaping (_ registered: Bool ) -> Void){
                self.spark?.phone.register() { error in
                    if (error == nil) {
                        print("Device Registered")
                        deviceRegistrationState(true)
                    } else {
                        print("Device Not Regsitered")
                        deviceRegistrationState(false)
                    }
                }
    }
    
    /// The caller Email address
    /// - note: Call memberships include yourself,so if you calling someone,callerEmail is your email address.
//    static var callerEmail: String {
//        get {
//            if let call = SparkContext.sharedInstance.call {
//                for member in call.memberships {
//                    if member.isInitiator == true {
//                        return member.email ?? "Unknow"
//                    }
//                }
//            }
//            return "Unknow"
//        }
//    }
    
}
