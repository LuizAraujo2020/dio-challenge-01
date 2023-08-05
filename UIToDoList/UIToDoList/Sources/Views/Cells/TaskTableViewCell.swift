//
//  TaskTableViewCell.swift
//  UIToDoList
//
//  Created by Luiz Araujo on 31/07/23.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var labelDate : UILabel!
    @IBOutlet weak var labelHour : UILabel!
    @IBOutlet weak var labelTitle : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func set(labelDate: String) {
        self.labelDate.text = labelDate
    }

    func set(labelHour: String) {
        self.labelHour.text = labelHour
    }

    func set(labelTitle: String) {
        self.labelTitle.text = labelTitle
    }
}
