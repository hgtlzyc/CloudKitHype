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
        let alertController = UIAlertController(title: "something hype", message: "what is hype today", preferredStyle: .alert)
        
        alertController.addTextField { txField in
            txField.placeholder = "enter here"
            txField.autocorrectionType = .yes
            txField.autocapitalizationType = .none
        }
        
        let addAction = UIAlertAction(title: "Send", style: .default) { _ in
            guard let body = alertController.textFields?.first?.text else { return }
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
    
        }///End Of add action
        
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
        
    }///End Of Create new tapped
    
    @objc func refreashNow() {
        print("on")
        referasher.endRefreshing()
    }
    
    func updateViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
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
    
}
