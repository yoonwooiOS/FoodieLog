//
//  DetailView.swift
//  FoodieLog
//
//  Created by 김윤우 on 9/26/24.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var reviewText: String = """
    ✅지리산 흑돼지 소금구이 맛집✨
    너무 가고 싶었던 산청숯불가는 마곡! 저녁과 주말에는 웨이팅이 심하다고 해서 평일 점심에 방문했는데요 웬걸… 평일 점심에도 사람이 많았어요 😳 조금만 늦었으면 웨이팅 있었을수도!
    캐치테이블로 예약하고 방문하시길 추천👍
    
    📍맛
    
    소금구이 시키면 지리산 흑돼지의 다양한 부위를 먹어볼수 있어요~ 직접 구워주셔서 더 편하지만 구워주는 분의 스킬에 따라 맛도 천차만별일거 같네요 고추장 구이 기대했는데 제입맛에는 소금구이가 더 맛났어요~
    
    tip. 추가 주문 시 소금구이는 반접시 주문가능
    냉면은 오이가 잔뜩들어가서 입가심으로 먹기 좋았구 볶음밥을 먹고 싶었지만😭 배불러서 못먹은게 아쉽네요 다음에 한번 더 먹으러 가지 않을까 싶네요 😊💙
    """
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                HorizontalScrollViews()
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("산청가든")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("4.5")
                            .font(.subheadline)
                        Text("2024.09.17")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.gray)
                        .frame(width: 360, height: 200)
                    Text("후기")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(reviewText)
                        .font(.body)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
            }
        }
    }
}
#Preview {
    NavigationView {
        DetailView()
    }
}

struct HorizontalScrollViews: View {
    let items = Array(0..<3)
    
    @State private var currentIndex: Int = 0
    @State private var offset: CGFloat = 0
    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    Image("Sancheong")
                        .resizable()
                    //                        .frame(height: 300)
                        .clipped()
                        .edgesIgnoringSafeArea(.top)
                        .frame(width: geometry.size.width, height:  geometry.size.height * 1.2)
                }
            }
            .offset(x: -CGFloat(currentIndex) * geometry.size.width + offset + translation)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: offset)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: translation)
            .gesture(
                DragGesture()
                    .updating($translation) { value, state, _ in
                        state = value.translation.width
                    }
                    .onEnded { value in
                        let predictedEndOffset = value.predictedEndTranslation.width
                        let predictedIndex = Int(round(
                            Double(currentIndex) - Double(predictedEndOffset) / Double(geometry.size.width)
                        ))
                        
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            currentIndex = max(0, min(predictedIndex, items.count - 1))
                            offset = 0
                        }
                    }
            )
        }
        .frame(height: 300)
        .clipped()
    }
}
