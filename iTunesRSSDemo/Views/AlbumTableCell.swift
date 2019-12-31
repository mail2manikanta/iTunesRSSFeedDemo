//
//  AlbumTableCell.swift
//  iTunesRSSDemo
//
//  Created by Manikanta Nallabelly on 12/28/19.
//  Copyright © 2019 STANZA. All rights reserved.
//

import UIKit

class AlbumTableCell: UITableViewCell {
    
    @UsesAutoLayout
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()

    @UsesAutoLayout
    private var artistLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    @UsesAutoLayout
    var albumArtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var album : Album? {
        didSet {
            albumArtImageView.image = UIImage.init(imageLiteralResourceName: Constants.albumArtIcon)
            nameLabel.text = album?.name
            artistLabel.text = album?.artistName
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(albumArtImageView)
        addSubview(nameLabel)
        addSubview(artistLabel)

        albumArtImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        nameLabel.anchor(top: topAnchor, left: albumArtImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        artistLabel.anchor(top: nameLabel.bottomAnchor, left: albumArtImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
