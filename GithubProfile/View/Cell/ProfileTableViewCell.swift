//
//  ProfileTableViewCell.swift
//  GithubProfile
//
//  Created by 김정호 on 4/12/24.
//

import UIKit
import Kingfisher

final class ProfileTableViewCell: UITableViewCell {
    
    // MARK: - properties
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    let nickname: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [name, nickname])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()
    
    // MARK: - methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(nameStackView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
        
            nameStackView.centerYAnchor.constraint(equalTo: self.profileImageView.centerYAnchor),
            nameStackView.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 20)
        ])
    }
    
    func bind(profile: ProfileDTO?) {
        if let profile {
            if let imageUrl = URL(string: profile.avatarUrl) {
                self.profileImageView.kf.setImage(with: imageUrl)
                self.profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
                self.profileImageView.clipsToBounds = true
            }
            
            self.name.text = profile.name
            self.nickname.text = profile.nickname
        }
    }
}
