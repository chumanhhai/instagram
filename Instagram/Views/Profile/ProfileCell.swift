//
//  ProfileCell.swift
//  Instagram
//
//  Created by Hải Chu on 15/07/2021.
//

import UIKit
import SDWebImage

class ProfileCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            configure()
        }
    }
    
    let image: UIImageView = {
        let image = UIImageView(image: UIImage(named: "venom"))
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGray
        
        // add image
        addSubview(image)
        image.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func configure() {
        guard let post = post else {return}
        image.sd_setImage(with: URL(string: post.imageUrl))
    }
}
