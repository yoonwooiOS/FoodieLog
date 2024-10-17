//
//  SettingView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/2/24.
//

import SwiftUI

struct SettingView: View {
    @State private var showingResetAlert: Bool = false
    let temp: [String] = []
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Text("설정")
                .font(.system(size: 30, weight: .bold))
                .bold()
                .padding(.leading, 20)
                .padding(.top, 16)
                .padding(.bottom, 16)
            
            HStack {
                Image(systemName: "info.circle")
                Text("버전 정보")
                Spacer()
                Text("1.0")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            
            // 개인정보 처리방침 섹션
            NavigationLink {
                PrivacyPolicyView()
            } label: {
                HStack {
                    Image(systemName: "doc.text")
                    Text("개인정보 처리방침")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal, 16)
            }
            .foregroundColor(.black)
            
            // 문의 섹션
            Button{
                sendEmail()
            } label: {
                HStack {
                    Image(systemName: "paperplane")
                    Text("문의")
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal, 16)
            }
            .foregroundColor(.black)
            Spacer()
        }
        .background(ColorSet.primary.color)
    }
    
    func sendEmail() {
        let email = "yoonwoo4429@naver.com"
        let subject = "[FoodieLog] 문의하기"
        let body = "사용하시다가 생긴 불편 사항이나 원하시는 기능\n 말씀해 주시면 개발자에서 큰 도움이 됩니다!"
        
        // URL로 인코딩된 문자열 생성
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // mailto URL 생성
        if let url = URL(string: "mailto:\(email)?subject=\(encodedSubject)&body=\(encodedBody)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Mail services are not available")
            }
        }
    }
}
