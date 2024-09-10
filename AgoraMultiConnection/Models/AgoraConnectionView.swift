//
//  AgoraConnectionView.swift
//  AgoraMultiConnection
//
//  Created by BBC on 2024/9/6.
//

import Foundation
import AgoraRtcKit
import UIKit

struct AgoraConnectionView : Identifiable {
    let id = UUID()
    var agoraConnection : AgoraRtcConnection
    var remoteUIViewRepresent : UIViewRepresent
    var remoteID : UInt?
}
