//
//  HistoryViewController.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar on 2021/09/17.
//

import UIKit


class HistoryViewController: UITableViewController {
    
    private weak var delegate: SearchViewModelDelegate?
    private lazy var viewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
    
    func setData(delegate: SearchViewModelDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.historyData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.historyReuseIdentifier, for: indexPath) as! HistoryCell
        cell.initialiseDelegate(with: self,
                                tag: indexPath.row,
                                title: viewModel.historyData[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.reloadWithHistoryTag(self.viewModel.historyData[indexPath.row])
        }
    }
}

extension HistoryViewController: HistoryCellDelegate {
    
    func removeItemAtIndex(index: Int) {
        viewModel.removeHistoryAtIndex(index: index)
    }
    
    func updateTable() {
        guard viewModel.historyData.count == 0 else { return tableView.reloadData() }
        self.dismiss(animated: true, completion: nil)
    }
}

