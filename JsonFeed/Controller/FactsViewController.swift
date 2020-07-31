//
//  FactsViewController.swift
//  JsonFeed
//
//  Created by Varsha Shankar on 31/07/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//

import UIKit

class FactsViewController: UIViewController {

    var tableView = UITableView()
    private var viewModel = FactsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
        self.navigationController?.navigationBar.topItem?.title = "About Canada"
        loadFacts()
        configureTableView()
    }

    private func loadFacts() {
        viewModel.fetchFactsRows { [weak self] in
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
        }
    }
    func configureTableView() {
           view.addSubview(tableView)
           setTableViewDelegates()
       // tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 300
           //Set Row Height
           tableView.register(FactsCell.self, forCellReuseIdentifier: "factsCell")
           tableView.pin(to: view)
           
       }

       func setTableViewDelegates() {
           tableView.delegate = self
           tableView.dataSource = self
       }
    
}

extension FactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "factsCell") as! FactsCell
        let row = viewModel.cellForRowAt(indexPath: indexPath)
       cell.set(fact: row)
       return cell
    }
    
    
}
