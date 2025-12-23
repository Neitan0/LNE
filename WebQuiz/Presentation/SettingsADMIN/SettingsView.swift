//
//  SettingsView.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 23/12/25.
//
import UIKit
import SnapKit

class SettingsView: UIView {
    
    // 1. Background Image
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Gerenciar Quiz"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white // Branco para contrastar com o fundo
        label.backgroundColor = .clear // Garante fundo transparente
        return label
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear // Tabela transparente
        table.separatorColor = .white.withAlphaComponent(0.3) // Linhas sutis
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { nil }
    
    private func setupLayout() {
        // Ordem de inserção: fundo primeiro
        addSubview(backgroundImageView)
        addSubview(headerTitle)
        addSubview(tableView)
        
        // FOTO OCUPANDO TUDO (Ignora Safe Area)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerTitle.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerTitle.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
