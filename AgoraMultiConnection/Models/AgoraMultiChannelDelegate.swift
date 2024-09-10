//
//  AgoraMultiChannelDelegate.swift
//  AgoraMultiConnection
//
//  Created by BBC on 2024/9/5.
//

import Foundation
import AgoraRtcKit

// Multi Channel Delegate Protocol
protocol AgoraMultiChannelDelegate : NSObject {
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionId: AgoraRtcConnection, didOccurWarning warningCode: AgoraWarningCode)
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionId: AgoraRtcConnection, didOccurError errorCode: AgoraErrorCode)
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionId: AgoraRtcConnection, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int)
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionId: AgoraRtcConnection, didJoinedOfUid uid: UInt, elapsed: Int)
    func rtcEngine(_ engine: AgoraRtcEngineKit, connectionId: AgoraRtcConnection, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason)
}


// Multi Channel Delegator
class AgoraMultiDelegator: NSObject, AgoraRtcEngineDelegate {
    weak var connectionDelegate: AgoraMultiChannelDelegate?
    var connectionId: AgoraRtcConnection?
//    var agoraConenction: /*AgoraRtcConnection?*/

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurWarning warningCode: AgoraWarningCode) {
        if let connId = self.connectionId {
            self.connectionDelegate?.rtcEngine(engine, connectionId: connId, didOccurWarning: warningCode)
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOccurError errorCode: AgoraErrorCode) {
        if let connId = self.connectionId {
            self.connectionDelegate?.rtcEngine(engine, connectionId: connId, didOccurError: errorCode)
        }
    }


    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinChannel channel: String, withUid uid: UInt, elapsed: Int) {
        if let connId = self.connectionId {
            self.connectionDelegate?.rtcEngine(engine, connectionId: connId, didJoinChannel: channel, withUid: uid, elapsed: elapsed)
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        if let connId = self.connectionId {
            self.connectionDelegate?.rtcEngine(engine, connectionId: connId, didJoinedOfUid: uid, elapsed: elapsed)
        }
    }

    func rtcEngine(_ engine: AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraUserOfflineReason) {
        if let connId = self.connectionId {
            self.connectionDelegate?.rtcEngine(engine, connectionId: connId, didOfflineOfUid: uid, reason: reason)
        }
    }
}
