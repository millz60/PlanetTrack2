//
//  FactsTableViewCell.swift
//  PlanetTrack2
//
//  Created by Matt Milner on 8/25/16.
//  Copyright © 2016 Matt Milner. All rights reserved.
//

import UIKit

class FactsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
