//
//  SearchCell.swift
//  Instagram
//
//  Created by Hải Chu on 17/07/2021.
//

import UIKit

class SearchCell: UITableViewCell {
    
    let profileImage: UIImageView = {
        let size: CGFloat = 50
        let image = UIImageView()
        image.image = UIImage(named: "venom")
        image.backgroundColor =  .systemGray
        image.setDimensions(height: size, width: size)
        image.layer.cornerRadius = size/2
        image.clipsToBounds = true
        return image
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Cena"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ".beast"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.systemGray
        label.numberOfLines = 0
        return label
    }()
    
    lazy var labelContainer: UIStackView = {
        let container = UIStackView(arrangedSubviews: [nicknameLabel, nameLabel])
        container.axis = .vertical
        container.spacing = 4
        return container
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // add profile image
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 14)
        profileImage.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12).isActive  = true
        
        // add name label
        addSubview(labelContainer)
        labelContainer.anchor(top: profileImage.topAnchor, left: profileImage.rightAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 14, paddingRight: 14)
        labelContainer.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12).isActive  = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
