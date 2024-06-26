//
//  SwiftUIView.swift
//  
//
//  Created by Stephen Silber on 4/21/24.
//

import SwiftUI

@available(iOS 15.0, *)
struct CheckoutOverviewDetailRow<Content: View>: View {
    let title: String
    let content: () -> Content
    let showChevron: Bool
    
    let handler: () -> Void
    
    init(
        title: String,
        showChevron: Bool = true,
        @ViewBuilder content: @escaping () -> Content,
        handler: @escaping () -> Void
    ) {
        self.title = title
        self.content = content
        self.showChevron = showChevron
        self.handler = handler
    }
    
    var body: some View {
        Button(action: {
            handler()
        }) {
            HStack {
                Text(title)
                    .foregroundStyle(.primary)
                    .font(.footnote)
                    .frame(idealWidth: 80)
                Spacer(minLength: 24)
                HStack {
                    content()
                    if showChevron {
                        Image(systemName: "chevron.right")
                            .font(.footnote.bold())
                            .foregroundStyle(Color.dispatchBlue)
                    }
                }
                .font(.footnote)
            }
            .padding()
            .foregroundStyle(.primary)
        }
        .tint(.primary)
    }
}

@available(iOS 15.0, *)
#Preview {
    VStack {
        Divider()
        CheckoutOverviewDetailRow(title: "Variant") {
            Text("Variant detail will end up going here")
                .multilineTextAlignment(.trailing)
                .lineLimit(3)
                .foregroundStyle(.primary)
        } handler: { }
        Divider()
        CheckoutOverviewDetailRow(title: "Email") {
            Text("preview@preview.com")
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .foregroundStyle(.primary)
        } handler: { }
        Divider()

    }
}
