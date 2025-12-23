//
//  SettingsBridge.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 23/12/25.
//


import SwiftUI

struct SettingsViewContainer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> SettingsViewController {
        // Aqui o SwiftUI instancia sua tela em UIKit
        return SettingsViewController()
    }
    
    func updateUIViewController(_ uiViewController: SettingsViewController, context: Context) {
        // Usado para atualizar a controller se o estado do SwiftUI mudar
    }
}
