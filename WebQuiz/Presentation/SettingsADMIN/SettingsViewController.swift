//
//  SettingsViewController.swift
//  WebQuiz
//
//  Created by Natanael Nogueira on 23/12/25.
//
import UIKit

class SettingsViewController: UIViewController {
    
    private let contentView = SettingsView()
    private let options = ["Editar Perguntas", "Ver Relatórios", "Gerenciar Alunos", "Limpar Cache"]
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Admin"
        
        // Precisamos assinar os protocolos para a tabela funcionar
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.textColor = .white // Texto branco para ler sobre a imagem
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selecionou: \(options[indexPath.row])")
    }
}
