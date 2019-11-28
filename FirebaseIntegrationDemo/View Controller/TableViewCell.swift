//
//  TableViewCell.swift
//  FirebaseIntegrationDemo
//
//  Created by Dheeraj Arora on 18/11/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblText: UILabel!
    
    var chatModel: ChatModel?{
        didSet{
            self.lblName.text = chatModel?.name
            self.lblText.text = chatModel?.text
            let url =  URL(string: (chatModel?.profileImage)!)
            if let url = url{
                KingfisherManager.shared.retrieveImage(with: url as Resource, options: nil, progressBlock: nil) { (image, errorr, cache, imageUrl) in
                    self.myImage.image = image
                    self.myImage.kf.indicatorType = .activity
                }
            }
            
        }
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
