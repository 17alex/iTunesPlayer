//
//  SearchTableViewCell.swift
//  iTunesPlayer
//
//  Created by Alex on 16.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    // MARK: - Propertis
    
    weak var delegate: SearchViewController?
    
    private var track: Track! {
        didSet{
            trackNameLabel.text = track.trackName
            artistNameLabel.text = track.artistName
            setIconImage(with: track.artworkUrl60)
            testLabel.text = track.artworkUrl60
        }
    }
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "text"
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.text = "text"
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "text"
        label.font = UIFont.systemFont(ofSize: 6, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - LiveCycles
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
    }
    
    // MARK: - Metods
    
    private func setIconImage(with stringUrl: String?) {
        
        delegate?.getImage(from: stringUrl, complete: { [weak self] (image) in
            self?.iconImageView.image = image
        })
    }
    
    func set(track: Track) {
        self.track = track
    }
    
    private func setupViews() {
        
        addSubview(iconImageView)
        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        
        addSubview(trackNameLabel)
        trackNameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10).isActive = true
        trackNameLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor).isActive = true
        trackNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5).isActive = true
        
        addSubview(artistNameLabel)
        artistNameLabel.leadingAnchor.constraint(equalTo: trackNameLabel.leadingAnchor).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 1).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5).isActive = true
        
        addSubview(testLabel)
        testLabel.leadingAnchor.constraint(equalTo: trackNameLabel.leadingAnchor).isActive = true
        testLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 1).isActive = true
        testLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 5).isActive = true
    }
}
