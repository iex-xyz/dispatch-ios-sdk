//
//  MerchView.swift
//  Example
//
//  Created by Yesh Chandiramani (Dispatch) on 5/31/24.
//

import SwiftUI
import DispatchSDK

struct CheckoutItem {
    var id: String;
    var name: String;
    var price: String;
}

struct MerchView: View {
    @EnvironmentObject private var audioPlayer: AudioPlayer

    let items = [
        CheckoutItem(id: "6658978ca433607696246daa", name: "Tshirt", price: "$29.99"),
        CheckoutItem(id: "665a2a57a433607696247b74", name: "Crew Neck", price: "$49.99")
    ]
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                ForEach(items, id: \.id) { item in
                    checkout(for: item, in: proxy)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                Spacer()
            }
            .foregroundColor(.white)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    func checkout(for item: CheckoutItem, in geometry: GeometryProxy) -> some View {
        let width = geometry.size.width * 0.9
        let height = geometry.size.height * 0.38
        return VStack() {
            Image(item.name)
                .resizable()
                .cornerRadius(6)
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
            HStack {
                Text(item.name)
                Spacer()
                Text(item.price)
            }
            .font(.system(size: 24, weight: .bold))
        }
        .frame(width: width, height: height)
        .shadow(color: .black.opacity(0.1), radius: 6)
        .padding(.vertical)
        .onTapGesture {
            handleItemTap(checkoutId: item.id)
        }
    }
    
    func handleItemTap(checkoutId: String) {
        let config: DispatchConfig = DispatchConfig(
            applicationId: "64b86c02453510acde70250f",
            environment: .demo,
            merchantId: "merchant.co.dispatch.checkout",
            orderCompletionCTA: "Back To Music"
        )
        DispatchSDK.shared.setup(using: config)
        DispatchSDK.shared.present(with: .checkout(checkoutId))
    }
}

#Preview {
    MerchView()
        .environmentObject(AudioPlayer())
}
