//
//  SearchTableViewCell.swift
//  WeatherApp
//
//  Created by 安子璠 on 10/29/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLocalizedName: UILabel!
    @IBOutlet weak var lblAreaCountry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
