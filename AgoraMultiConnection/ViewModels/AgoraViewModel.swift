//
//  AgoraViewModel.swift
//  AgoraMultiConnection
//
//  Created by BBC on 2024/9/5.
//

import Foundation
import AgoraRtcKit
import AVKit
import AVFoundation

class AgoraViewModel: NSObject, ObservableObject {
    
    
    // MARK: AGORA PROPERTIES
    var agoraKit: AgoraRtcEngineKit = AgoraRtcEngineKit()
    var agoraAppID = ""
    
    @Published var rtcConnections : [AgoraConnectionView] = []
    @Published var agoraMultiDelegators : [AgoraMultiDelegator] = []

    override init(){
        super.init()
        
        // MARK: Agora Initialization
        let config = AgoraRtcEngineConfig()
        config.appId = agoraAppID
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)
        agoraKit.setChannelProfile(.liveBroadcasting)
        agoraKit.setClientRole(.audience, options: AgoraClientRoleOptions()) // Join as audience
    }
    

    func agoraRemoveRtcConnection(connection: AgoraRtcConnection) {
        rtcConnections.removeAll(where: {$0.agoraConnection.channelId == connection.channelId})
    }
    
    func agoraSetupRtcConnection(channelName: String) {
        // Agora Connections
        let connection = AgoraRtcConnection()
        connection.channelId = channelName
        connection.localUid = 123
        
        // Connection Delegate
        let agoraMultiDelegator : AgoraMultiDelegator = AgoraMultiDelegator()
        agoraMultiDelegator.connectionDelegate = self
        agoraMultiDelegator.connectionId = connection
        
        agoraMultiDelegators.append(agoraMultiDelegator)
        
        // Media Options
        let mediaOptions = AgoraRtcChannelMediaOptions()
        mediaOptions.publishMicrophoneTrack = false
        mediaOptions.publishCameraTrack = false
        mediaOptions.autoSubscribeVideo = true
        mediaOptions.autoSubscribeAudio = true
        mediaOptions.clientRoleType = .audience
        
        let result = self.agoraKit.joinChannelEx(byToken: nil, connection: connection, delegate: agoraMultiDelegator, mediaOptions: mediaOptions)
        
        if result == 0 {
            rtcConnections.append(AgoraConnectionView(agoraConnection: connection, remoteUIViewRepresent: UIViewRepresent()))
            print("join success")
        }else {
            print("join fail error \(result)")
        }
    }
    
    func agoraSetupRemoteVideo(connection: AgoraRtcConnection, remoteID: UInt, remoteView: UIView, streamType: AgoraVideoStreamType) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = remoteID
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraKit.setupRemoteVideoEx(videoCanvas, connection: connection)
        agoraKit.setRemoteVideoStreamEx(remoteID, type: streamType, connection: connection)
    }
    
}


extension AgoraViewModel: AgoraMultiChannelDelegate {
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionId: AgoraRtcConnection, didOccurWarning warningCode: AgoraWarningCode) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionId: AgoraRtcConnection, didOccurError errorCode: AgoraErrorCode) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionId: AgoraRtcConnection, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionId: AgoraRtcConnection, didJoinedOfUid uid: UInt, elapsed: Int) {
        print("Bac's didJoinedOfUid ")
        if let remoteIndex = rtcConnections.firstIndex(where: {$0.agoraConnection.channelId == connectionId.channelId}) {
            rtcConnections[remoteIndex].remoteID = uid
            agoraSetupRemoteVideo(connection: connectionId, remoteID: uid, remoteView: rtcConnections[remoteIndex].remoteUIViewRepresent.containerUIView, streamType: .low)
        }
    }
    
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionId: AgoraRtcConnection, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        if let remoteIndex = rtcConnections.firstIndex(where: {$0.agoraConnection.channelId == connectionId.channelId}) {
            rtcConnections[remoteIndex].remoteID = nil
        }
    }
    
    
}

//// MARK: Main Agora callbacks
extension AgoraViewModel: AgoraRtcEngineDelegate {
    // When local user joined
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
    }
    
    // Local user leaves
    func rtcEngine(_ engine: AgoraRtcEngineKit, didLeaveChannelWith stats: AgoraChannelStats) {
    }
    
}
