//
//  AddPostView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/20/24.
//

import SwiftUI

struct AddPostView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.ignoresSafeArea()
                VStack {
                    Text("맛집 등록")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                }
                .padding()
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: 32)
                        .path(in: CGRect(x: 0, y: 80,
                                         width: geometry.size.width,
                                         height: geometry.size.height))
                        .foregroundColor(.white)
                    
                }
            }
        }
    }
}

#Preview {
    AddPostView()
}
