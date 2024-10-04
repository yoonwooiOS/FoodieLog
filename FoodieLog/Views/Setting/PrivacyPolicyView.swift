//
//  PrivacyPolicyView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/3/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        setupNavigationBarAppearance()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("""
                     「FoodieLog는 개인정보 보호법」 제30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.
                     
                     제1조(개인정보의 처리목적)
                     FoodieLog는 개인정보 보호법 제32조에 따라 등록․공개하는 개인정보파일의 처리목적은 다음과 같습니다.
                     
                     제2조(처리하는 개인정보의 항목)
                     ① FoodieLog는 개인정보 항목을 처리하고 있지 않습니다.
                     
                     제3조(개인정보 파일의 현황)
                     ① FoodieLog는 개인정보 파일, 쿠키 등을 사용하지 않고, 저장하지 않습니다.
                     
                     제4조(개인정보의 처리 및 보유 기간)
                     ① FoodieLog는 개인정보 파일, 쿠키 등을 사용하지 않고, 저장하지 않습니다. 따라서 이용자의 개인정보를 처리할 내용과 보유 기간이 존재하지 않습니다.
                     
                     제5조(개인정보의 제3자 제공에 관한 사항)
                     ① FoodieLog는 개인정보를 제3자에게 제공하지 않습니다.
                     
                     제6조(개인정보처리 위탁)
                     ① FoodieLog는 개인정보의 위탁을 하고 있지 않습니다.
                     
                     제7조(정보주체와 법정대리인의 권리·의무 및 그 행사방법에 관한 사항)
                     ① FoodieLog는 개인정보 파일, 쿠키 등을 사용하지 않고, 저장하지 않습니다.
                     
                     제8조(개인정보의 파기)
                     ① FoodieLog는 독립 실행 방식의 어플리케이션으로 별도의 서버에서 개인정보를 저장하고 있지 않습니다. 따라서 정보주체가 원할 시 어플리케이션을 삭제함으로써 모든 데이터를 파기 가능합니다.
                     """)
                    .font(.body)
                    .foregroundColor(.primary)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .navigationTitle("개인정보 처리방침")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding(8)
                }
            }
        }
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white // 배경 색상을 흰색으로 설정
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black] // 타이틀 색상 검정으로 설정

        // NavigationBar에 appearance 적용
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}
