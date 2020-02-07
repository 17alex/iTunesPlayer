//
//  SearchTableViewCell.swift
//  iTunesPlayer
//
//  Created by Alex on 16.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

protocol TrackTableViewCellProtocol: class {
    
    func getImage(from urlString: String?, complete: @escaping ((UIImage?) -> Void))
    func pressPlusButton(button: UIButton)
}

class TrackTableViewCell: UITableViewCell {
    
    // MARK: - Propertis
    
    weak var delegate: TrackTableViewCellProtocol?
    
    private var track: Track! {
        didSet{
            trackNameLabel.text = track.trackName
            artistNameLabel.text = track.artistName
            setIconImage(with: track.artworkUrl60)
        }
    }
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "text"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        label.text = "text"
        label.font = UIFont.systemFont(ofSize: 10, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
//        button.backgroundColor = .orange
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    @objc
    private func plusButtonPress(button: UIButton) {
        delegate?.pressPlusButton(button: button)
    }
    
    private func setIconImage(with stringUrl: String?) {
        
        delegate?.getImage(from: stringUrl, complete: { [weak self] (image) in
            self?.iconImageView.image = image
        })
    }
    
    func set(track: Track, hiddenPlus: Bool) {
        self.track = track
        plusButton.isHidden = hiddenPlus
    }
    
    private func setupViews() {
        
        addSubview(iconImageView)
        addSubview(trackNameLabel)
        addSubview(artistNameLabel)
        addSubview(plusButton)
        
        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor).isActive = true
        
        trackNameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10).isActive = true
        trackNameLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor).isActive = true
        trackNameLabel.trailingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: -5).isActive = true
        
        artistNameLabel.leadingAnchor.constraint(equalTo: trackNameLabel.leadingAnchor).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo: trackNameLabel.bottomAnchor, constant: 1).isActive = true
        artistNameLabel.trailingAnchor.constraint(equalTo: trackNameLabel.trailingAnchor).isActive = true
        
        plusButton.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        plusButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        plusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        plusButton.widthAnchor.constraint(equalTo: plusButton.heightAnchor).isActive = true
        plusButton.addTarget(self, action: #selector(plusButtonPress(button:)), for: .touchUpInside)
    }
}
