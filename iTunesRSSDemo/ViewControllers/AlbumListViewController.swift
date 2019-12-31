//
//  AlbumListViewController.swift
//  iTunesRSSDemo
//
//  Created by Manikanta Nallabelly on 12/28/19.
//  Copyright © 2019 STANZA. All rights reserved.
//

import UIKit

class AlbumListViewController : UIViewController {
    
    static let headerTitle:String = "Top Movies"
    let albumTableCellIdentifier = "AlbumTableCell"
    
    let albumListViewModel:AlbumListViewModel = AlbumListViewModel()
    
    @UsesAutoLayout
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        
        self.view.showActivityIndicator()
        
        albumListViewModel.onErrorHandling = { [weak self] (error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showAlert(message: error.message())
            }
        }
        
        albumListViewModel.fetchAlbums { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view.hideActivityIndicator()
                self.tableView.reloadData()
            }
        }
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = AlbumListViewController.headerTitle
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
                
        //Setup constraints
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        
        //Register Cells
        tableView.register(AlbumTableCell.self, forCellReuseIdentifier: albumTableCellIdentifier)
    }
}

extension AlbumListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumListViewModel.entityCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: albumTableCellIdentifier, for: indexPath) as? AlbumTableCell
        let album = albumListViewModel.entityAtIndex(indexPath)
        cell?.album = album
        
        ImageDownloadManager.shared.downloadImage(album.artURL, indexPath: indexPath) { (image, url, indexPathNew, error) in
            DispatchQueue.main.async {
                if let indexPathNew = indexPathNew,
                    let cell = tableView.cellForRow(at: indexPathNew) as? AlbumTableCell {
                    cell.albumArtImageView.image = image
                }
            }
        }
        
        return cell ?? UITableViewCell()
    }
}


extension AlbumListViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = albumListViewModel.entityAtIndex(indexPath)
        
        let albumDetailVC = AlbumDetailViewController(album: album)
        self.navigationController?.pushViewController(albumDetailVC, animated: true)
    }
}
