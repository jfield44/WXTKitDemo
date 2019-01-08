//
//  SparkMediaView.swift
//  SparkMediaView
//
//  The MIT License (MIT)
//
//  Created by Jonathan Field on 09/10/2016.
//  Copyright © 2016 Cisco. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import WebexSDK
import AVFoundation

/**
 Provides notifications when significant events take place during a video call
 - function callDidComplete: Triggered when the call ends regardless of the reason for call ending.
 - function callFailedWithError: Triggered when there was an error in setting up the call or there was an error with authentication
 */
public protocol WXTeamsCallingDelegate: class {
    func callDidComplete()
    func callFailed(withError: String)
}

 class WXTeamsCallingViewController: UIViewController {
    
    //Video Components
    @IBOutlet weak var remoteMediaView: MediaRenderView!
    @IBOutlet weak var localMediaView: MediaRenderView!
    
    //User Interface
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var hangupButton: UIButton!
    @IBOutlet weak var rotateCameraButton: UIButton!
    @IBOutlet weak var callTimerLabel: UILabel!
    
    public enum MediaAccessType {
        case audio, audioVideo
    }
    
    
    //Call Variables
    var authenticationType: WXTManager.AuthenticationStrategy
    var apiKey: String!
    var callTimer: Timer!
    var currentCallDuration: Int = 0
    
    //Delegate
    weak var delegate: WXTeamsCallingDelegate?
    
    //Initalizers
    public init(authType: WXTManager.AuthenticationStrategy, apiKey: String, delegate: WXTeamsCallingDelegate?) {
        self.authenticationType = authType
        self.apiKey = apiKey
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.apiKey = String()
        self.authenticationType = .guestId
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        print(localMediaView.frame.size.height)
        print(remoteMediaView.frame.size.width)
        print(localMediaView.frame.size.height)
        print(remoteMediaView.frame.size.width)
        let tapGestureRecogniser = UITapGestureRecognizer.init(target: self, action: #selector(tap))
        self.remoteMediaView.addGestureRecognizer(tapGestureRecogniser)
        
        let panGestureRecogniser = UIPanGestureRecognizer.init(target: self, action: #selector(repositionSelfView))
        self.localMediaView.addGestureRecognizer(panGestureRecogniser)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initiateCall(recipients: [String]) {
        
        // Makes a call to an intended recipient on behalf of the authenticated user.
        var recipientAddressOrRoomId: String?
        if recipients.count == 1 {
            // Its a 1-1 Call
            print("1-1 Call")
            recipientAddressOrRoomId = recipients[0]
            self.dial(address: recipientAddressOrRoomId!)
        }
        else {
            // Its a Group Call
            print("Group Call")
            WXTManager.shared.webex?.spaces.create(title: "SDK Call", completionHandler: { (response: ServiceResponse) in
                print("In the Loop")
                recipientAddressOrRoomId = response.result.data?.id!
                print("RoomID: \(recipientAddressOrRoomId!)")
                for recipientAddress in recipients {
                    WXTManager.shared.webex?.memberships.create(spaceId: (response.result.data?.id)!, personEmail: EmailAddress.fromString(recipientAddress)!, completionHandler: { (membershipResponse) in
                        print(membershipResponse.result.data!)
                    })
                }
                self.dial(address: recipientAddressOrRoomId!)
            })
        }
    }
    
    func dial(address: String) {
        WXTManager.shared.webex?.phone.dial(address, option: .audioVideo(local: self.localMediaView, remote: self.remoteMediaView)) { [weak self] result in
            if let strongSelf = self {
                switch result {
                case .success(let call):
                    WXTManager.shared.call = call
                    // Callback when remote participant(s) is ringing.
                    call.onRinging = { [weak self] in
                        if let strongSelf = self {
                            print("Ringing")
                            //...
                        }
                    }
                    // Callback when remote participant(s) answered and this *call* is connected.
                    call.onConnected = { [weak self] in
                        if let strongSelf = self {
                            print("Connected")
                            self?.hideLoadingScreen()
                        }
                    }
                    //Callback when this *call* is disconnected (hangup, cancelled, get declined or other self device pickup the call).
                    call.onDisconnected = {[weak self] disconnectionType in
                        if let strongSelf = self {
                            self?.hideLoadingScreen()
                            WXTManager.shared.deinitSpark()
                            self?.delegate?.callDidComplete()
                            self?.dismiss(animated: true, completion: nil)
                        }
                    }
                    // Callback when the media types of this *call* have changed.
                    call.onMediaChanged = {[weak self] mediaChangeType in
                        if let strongSelf = self {
                            switch mediaChangeType {
                            //Local/Remote video rendering view size has changed
                            case .localVideoViewSize,.remoteVideoViewSize:
                                break
                            // This might be triggered when the remote party muted or unmuted the audio.
                            case .remoteSendingAudio(let isSending):
                                break
                            // This might be triggered when the remote party muted or unmuted the video.
                            case .remoteSendingVideo(let isSending):
                                break
                            // This might be triggered when the local party muted or unmuted the video.
                            case .sendingAudio(let isSending):
                                break
                            // This might be triggered when the local party muted or unmuted the aideo.
                            case .sendingVideo(let isSending):
                                break
                            // Camera FacingMode on local device has switched.
                            case .cameraSwitched:
                                break
                            // Whether loud speaker on local device is on or not has switched.
                            case .spearkerSwitched:
                                break
                            case .receivingScreenShare(let isRecieving):
                                
                                break
                            default:
                                break
                            }
                        }
                    }
                case .failure(let error):
                    _ = strongSelf.navigationController?.popViewController(animated: true)
                    print("Dial call error: \(error)")
                }
            }
        }
    }

    
    /**
     Trigger the WXT call to start
     - parameter recipient: The Spark URI or SIP URI of the remote particpiant to be dialled
     - parameter mediaAccessType: The type of Media that will be sent to the remote party (Audio or Audio Video)
     */
    func startWXTCall(recipients: [String], mediaAccessType: MediaAccessType){
        self.startCallTimer()
        WXTManager.shared.webex?.phone.defaultFacingMode = .user
        self.showLoadingScreen(recipient: "Calling")
        self.initiateCall(recipients: recipients)
    }

    
    // Button Actions
    @IBAction func rotateCameraPressed(_ sender: UIButton) {
        if WXTManager.shared.call?.facingMode == .user {
            WXTManager.shared.call?.facingMode = .environment
            self.rotateCameraButton.setImage(UIImage(named: "rotate"), for: UIControlState())
        }
        else if WXTManager.shared.call?.facingMode == .environment {
            WXTManager.shared.call?.facingMode = .user
            self.rotateCameraButton.setImage(UIImage(named: "rotateActive"), for: UIControlState())
        }
    }
    
    @IBAction func hangupPressed(_ sender: UIButton) {
        self.view.backgroundColor = UIColor.black
        self.callTimerLabel.isHidden = true
        
        WXTManager.shared.call?.hangup(completionHandler: { (error) in
            if error == nil {
                WXTManager.shared.call?.hangup(completionHandler: { (error) in
                    WXTManager.shared.call = nil
                })
            }
            else {
                print("Unable to hangup call")
            }
        })
    }
    
    @IBAction func mutePressed(_ sender: UIButton) {
        var muteState: Bool
        if WXTManager.shared.call?.sendingAudio == true {
            muteState = false
        }
        else {
            muteState = true
        }
        
        WXTManager.shared.call?.sendingAudio = muteState
        if (WXTManager.shared.call?.sendingAudio == true) {
            self.muteButton.setImage(UIImage(named: "mute"), for: UIControlState())
        }
        else{
            self.muteButton.setImage(UIImage(named: "muteActive"), for: UIControlState())
        }
    }
    
    // Gesture Recognisers
    @objc func tap(_ gestureRecognizer: UITapGestureRecognizer) {
        self.toggleButtonVisibilityState()
    }
    
    @objc func repositionSelfView(_ gestureRecognizer: UIPanGestureRecognizer){
        self.updateLocalMediaView(sender: gestureRecognizer)
    }
    
    // UI Helpers
    func toggleButtonVisibilityState() {
        if self.muteButton.isHidden || self.hangupButton.isHidden || self.rotateCameraButton.isHidden {
            self.muteButton.isHidden = false
            self.hangupButton.isHidden = false
            self.rotateCameraButton.isHidden = false
            self.callTimerLabel.isHidden = false
        }
        else {
            self.muteButton.isHidden = true
            self.hangupButton.isHidden = true
            self.rotateCameraButton.isHidden = true
            self.callTimerLabel.isHidden = true
        }
    }
    
    func showLoadingScreen(recipient: String) {
        ALLoadingView.manager.blurredBackground = true
        ALLoadingView.manager.showLoadingView(ofType: .messageWithIndicatorAndCancelButton, windowMode: .fullscreen)
        ALLoadingView.manager.cancelCallback = {
            WXTManager.shared.call?.hangup(completionHandler: { (error) in
                print("Hangup Failed")
                self.dismiss(animated: true, completion: nil)
            })
        ALLoadingView.manager.hideLoadingView()
        }
    }
    
    func hideLoadingScreen() {
        ALLoadingView.manager.hideLoadingView()
    }
    
    func updateLocalMediaView(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.init(x: 0, y: 0), in: self.view)
        
    }
    
    func startCallTimer() {
        self.callTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.currentCallDuration += 1
            self.callTimerLabel.text = self.timeStringFromSeconds(currrentCallDuration: self.currentCallDuration)
        })
    }
    
    fileprivate func showPhoneRegisterFailAlert() {
        let alert = UIAlertController(title: "Alert", message: "Phone register fail", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func timeStringFromSeconds(currrentCallDuration: Int) -> String {
        let minutes:Int = (currrentCallDuration / 60) % 60
        let seconds:Int = currrentCallDuration % 60
        let formattedTimeString = String(format: "%02u:%02u", minutes, seconds)
        return formattedTimeString
    }
    
}
