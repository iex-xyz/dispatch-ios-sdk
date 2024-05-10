//
//  SwiftUIView.swift
//  
//
//  Created by Stephen Silber on 4/18/24.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        HStack(spacing: 48) {
            Icons.poweredByDispatch
        }
        .padding(.horizontal)
    }
}

#Preview {
    FooterView()
}
