//
//  MailView.swift
//  FoodieLog
//
//  Created by 김윤우 on 10/3/24.
//

import SwiftUI

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var isShowing: Bool
    
    var recipients: [String]
    var subject: String
    var body: String
    var ccRecipients: [String]? = nil
    var bccRecipients: [String]? = nil
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.isShowing = false
            parent.presentation.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(recipients)
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: false)
        
        // CC 및 BCC 수신자 설정
        if let ccRecipients = ccRecipients {
            vc.setCcRecipients(ccRecipients)
        }
        if let bccRecipients = bccRecipients {
            vc.setBccRecipients(bccRecipients)
        }
        
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
