//
//  HypeListViewController.swift
//  CloudKitHype
//
//  Created by lijia xu on 8/9/21.
//

import UIKit

class HypeListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let referasher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        loadData()
        
        referasher.attributedTitle = NSAttributedString(string: "Pull down to refreash")
        referasher.addTarget(self, action: #selector(refreashNow), for: .valueChanged)
        tableView.addSubview(referasher)
        
    }
    
    @IBAction func createNewTapped(_ sender: Any) {
        presentAddHypeController(for: nil)
        
    }///End Of Create new tapped
    
    func presentAddHypeController(for hype: Hype?) {
        let alertController = UIAlertController(title: "something hype", message: "what is hype today", preferredStyle: .alert)
        
        alertController.addTextField { txField in
            txField.placeholder = "enter here"
            txField.autocorrectionType = .yes
            txField.autocapitalizationType = .none
            if let hype = hype {
                txField.text = hype.body
            }
            
        }
        
        let addAction = UIAlertAction(title: "Send", style: .default) { _ in
            guard let body = alertController.textFields?.first?.text else { return }
            
                if let hype = hype {
                    HypeController.shared.update(hype) { result in
                        switch result {
                        case .success(_):
                            self.updateViews()
                        case .failure(let err):
                            print(err)
                        }
                        
                    }
                    
                } else {
                    HypeController.shared.saveHype(with: body) { result in
                        switch result {
                        case .success(let hype):
                            guard let hype = hype else { return }
                            HypeController.shared.hypes.insert(hype, at: 0)
                            self.updateViews()
                        case .failure(let err):
                            print(err)
                        }
                        
                    }
                }
            
        }///End Of add action
        
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    @objc func refreashNow() {
        print("on")
        referasher.endRefreshing()
    }
    
    func updateViews() {
        DispatchQueue.main.async {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
            
        }///End Of GCD
    }
    
    func loadData() {
        HypeController.shared.fetchAllHypes {[weak self] result in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let hypes):
                    HypeController.shared.hypes = hypes
                    self?.updateViews()
                    self?.tableView.reloadData()
                    
                case .failure(let err):
                    print(err)
                }
                
            }///End Of main.async
            
        }///End Of fetchAllHypes
    }///End Of laodData
    
    
    
    
}///End Of HypeListViewController

extension HypeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HypeController.shared.hypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)
        let hype = HypeController.shared.hypes[indexPath.row]
        
        cell.textLabel?.text = hype.body
        cell.detailTextLabel?.text = "\(hype.timestamp)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hype = HypeController.shared.hypes[indexPath.row]
        presentAddHypeController(for: hype)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if case .delete = editingStyle {
            let hypeToDelete = HypeController.shared.hypes[indexPath.row]
            print(hypeToDelete.body)
            print(HypeController.shared.hypes.first{ $0 === hypeToDelete }?.body)
        }
    }
    
}
