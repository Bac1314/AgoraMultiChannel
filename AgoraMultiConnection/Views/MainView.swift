//
//  ContentView.swift
//  AgoraMultiConnection
//
//  Created by BBC on 2024/9/5.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var agoraVM : AgoraViewModel
    @State var selectedID : UUID?
    @State var refreshID: UUID = UUID()
    @Namespace var animationNamespace
    
    @State var fullscreenView : UIViewRepresent = UIViewRepresent()
    
    var body: some View {
        ZStack {
           // MARK: List Of Users
            ScrollView {
                Button {
                    agoraVM.agoraSetupRtcConnection(channelName: "channel_bac")
                    agoraVM.agoraSetupRtcConnection(channelName: "channel_bac2")
                    agoraVM.agoraSetupRtcConnection(channelName: "channel_bac3")
                    agoraVM.agoraSetupRtcConnection(channelName: "channel_bac4")
                    
                } label: {
                    Text("Sub Channels")
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 24) {
                    ForEach(agoraVM.rtcConnections) { connectionView in
                        connectionView.remoteUIViewRepresent
                            .matchedGeometryEffect(id: connectionView.id, in: animationNamespace)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(3/4, contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .onTapGesture {
                                withAnimation(.bouncy) {
                                    selectedID = selectedID == nil ? connectionView.id : nil
                                }
                            }
                    }
          
                }
                .padding()
            }
            .padding(.top)
            
            
            // MARK: Full Screen
            if let selected = selectedID, let index = agoraVM.rtcConnections.firstIndex(where: {$0.id == selected}), let remoteID = agoraVM.rtcConnections[index].remoteID {
                fullscreenView
                    .matchedGeometryEffect(id: selected, in: animationNamespace)
                    .ignoresSafeArea()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            selectedID = nil
                            
                            // Set it back to the small view nd subscribe low stream
                            agoraVM.agoraSetupRemoteVideo(connection: agoraVM.rtcConnections[index].agoraConnection, remoteID: remoteID, remoteView: agoraVM.rtcConnections[index].remoteUIViewRepresent.containerUIView, streamType: .low)
                        }
                    }
                    .onAppear {
                        
                        // Set it to large view and subscribe high stream
                        agoraVM.agoraSetupRemoteVideo(connection: agoraVM.rtcConnections[index].agoraConnection, remoteID: remoteID, remoteView: fullscreenView.containerUIView, streamType: .high)
                    }

            }
        }
        .background(Color.black)

    }

}

#Preview {
    MainView()
        .environmentObject(AgoraViewModel())
}
