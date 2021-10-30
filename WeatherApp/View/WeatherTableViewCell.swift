//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by 安子璠 on 10/29/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityTime: UILabel!
    @IBOutlet weak var cityWeather: UILabel!
    @IBOutlet weak var cityTemperature: UILabel!

    @IBOutlet weak var cellBackgorund: UIView!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.contentView.backgroundColor = UIColor.darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        
    
}
