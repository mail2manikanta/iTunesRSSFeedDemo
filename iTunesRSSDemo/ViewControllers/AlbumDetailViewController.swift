//
//  AlbumDetailViewController.swift
//  iTunesRSSDemo
//
//  Created by Manikanta Nallabelly on 12/28/19.
//  Copyright © 2019 STANZA. All rights reserved.
//

import UIKit
import SafariServices

class AlbumDetailViewController: UIViewController {

    let albumDetailViewModel:AlbumDetailViewModel
    
    @UsesAutoLayout
    var albumArtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(imageLiteralResourceName: Constants.albumArtIcon)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @UsesAutoLayout
    private var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    @UsesAutoLayout
    private var openiTunesLinkBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Learn More", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10.0
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(openiTunesPage(_:)), for: .touchUpInside)
        return button
    }()

    init(album:Album) {
        self.albumDetailViewModel = AlbumDetailViewModel(album: album)        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = albumDetailViewModel.albumName()
        view.backgroundColor = .white
        
        setupSubviews()
        configureData()
    }
    
    func configureData() {

        albumDetailViewModel.loadImage { [weak self] (image) in
            guard let self = self else { return }
            self.albumArtImageView.image = image
        }
        
        infoLabel.text = albumDetailViewModel.albumDisplayInfo()
    }
    
    func setupSubviews() {
        view.addSubview(albumArtImageView)
        view.addSubview(infoLabel)
        view.addSubview(openiTunesLinkBtn)

        albumArtImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 15, paddingRight: 15, width: view.bounds.width - 30, height: 0, enableInsets: false)
        infoLabel.anchor(top: albumArtImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 15, paddingRight: 10, width: 0, height: 0, enableInsets: false)
        
        openiTunesLinkBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 15, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 60, enableInsets: false)
    }
    
    @objc
    func openiTunesPage(_ sender:Any?) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let vc = SFSafariViewController(url: albumDetailViewModel.iTunesURL(), configuration: config)
        present(vc, animated: true)
    }
}
