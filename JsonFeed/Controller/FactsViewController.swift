//
//  ViewController.swift
//  JsonFeed
//
//  Created by Varsha Shankar on 31/07/20.
//  Copyright © 2020 Varsha Shankar. All rights reserved.
//

import UIKit

class FactsViewController: UIViewController {
    
    var tableView = UITableView()
    private var viewModel = FactsViewModel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFacts()
        configureTableView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.tableView.layoutIfNeeded()
    }

    // MARK: - Set Navigation Bar Title
    private func setNavigationBarTitle() {
        self.navigationController?.navigationBar.topItem?.title = viewModel.getTitle()
    }

    // MARK: - Load Data into Tableviw
    private func loadFacts() {
        self.showActivityIndicator()
        viewModel.fetchFactsRows { [weak self] in
            self?.setNavigationBarTitle()
            self?.stopActivityIndicator()
            self?.refreshControl.endRefreshing()
            self?.tableView.dataSource = self
            self?.tableView.reloadData()
        }
    }

    // MARK: - Configure Table view
    private func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(FactsCell.self, forCellReuseIdentifier: "factsCell")
        tableView.pin(to: view)
        tableView.backgroundColor = UIColor.gray
    }

    // MARK: - Set Tableview Delegate
    private func setTableViewDelegates() {
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

extension FactsViewController {

    // MARK: - Method to show activity indicator
    private func showActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = false
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }

    // MARK: - Method to stop activity indicator
    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }

    // MARK: - Configure refresh control
    private func configurePullToRefresh() {
        refreshControl.addTarget(self, action: #selector(FactsViewController.pullToRefresh), for: .valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
        self.tableView.alwaysBounceVertical = true
    }
    
    @objc func pullToRefresh() {
        loadFacts()
    }
}
