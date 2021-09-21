//
//  HistoryCell.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar on 2021/09/17.
//

import UIKit

protocol HistoryCellDelegate: NSObject {
    func updateTable()
    func removeItemAtIndex(index: Int)
}

class HistoryCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    private weak var delegate: HistoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initialiseDelegate(with delegate: HistoryCellDelegate, tag: Int, title: String) {
        self.delegate = delegate
        self.tag = tag
        self.title.text = title
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        delegate?.removeItemAtIndex(index: self.tag)
        delegate?.updateTable()
    }
}
