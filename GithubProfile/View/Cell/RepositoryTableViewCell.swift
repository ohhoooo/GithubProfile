//
//  RepositoryTableViewCell.swift
//  GithubProfile
//
//  Created by 김정호 on 4/12/24.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    // MARK: - properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    
    // MARK: - methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
