//
//  HistoryTableViewCell.swift
//  Globex-FinalProject-AmarnathKathiresan
//
//  Created by Amarnath  Kathiresan on 2023-12-11.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var source: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var descriptionValue: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var cameFrom: UILabel!
    @IBOutlet weak var cityname: UILabel!
    @IBAction func typebutton(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
