//
//  TrackPlayViewController.swift
//  iTunesPlayer
//
//  Created by Alex on 17.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit
import  AVKit

class TrackPlayerView: UIView {
    
    // MARK: - Property
    
    private let player: AVPlayer = {
       let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false
        return player
    }()
    
    private let playImage = UIImage(systemName: "play.fill")
    private let pauseImage = UIImage(systemName: "pause.fill")
    private let backwardImage = UIImage(systemName: "backward.fill")
    private let forwardImage = UIImage(systemName: "forward.fill")
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        button.tintColor = .black
//        button.backgroundColor = .orange
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let timeSlider: UISlider = {
        let slider = UISlider()
//        slider.backgroundColor = .orange
        slider.setValue(0, animated: false)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "00:00"
//        label.backgroundColor = .yellow
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "00:00"
//        label.backgroundColor = .green
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        label.text = "trackName"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        label.text = "artistName"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(backwardImage, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(playImage, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(forwardImage, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.setValue(0.2, animated: false)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    
    // MARK: - Live Cycles
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupViews()
    }
    
    
    // MARK: - Metods
    
    private func playTrack(stringURL: String?) {
        guard let stringURL = stringURL, let url = URL(string: stringURL) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    func set(track: Track) {
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        playTrack(stringURL: track.previewUrl)
    }
    
    @objc
    private func dismissView() {
        self.removeFromSuperview()
    }
    
    private func setupViews() {
        
        backgroundColor = .white
        
        let timeLabelStackView = UIStackView(arrangedSubviews: [elapsedTimeLabel, remainingTimeLabel])
        timeLabelStackView.axis = .horizontal
        timeLabelStackView.distribution = .fillEqually
        timeLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let timeSliderStackView = UIStackView(arrangedSubviews: [timeSlider, timeLabelStackView])
        timeSliderStackView.axis = .vertical
        timeSliderStackView.distribution = .fill
        timeSliderStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let trackArtistNameStackView = UIStackView(arrangedSubviews: [trackNameLabel, artistNameLabel])
        trackArtistNameStackView.axis = .vertical
        trackArtistNameStackView.distribution = .fill
        trackArtistNameStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let controlStackView = UIStackView(arrangedSubviews: [backwardButton, playPauseButton, forwardButton])
        controlStackView.axis = .horizontal
        controlStackView.distribution = .fillEqually
//        controlStackView.alignment = .center
        controlStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView(arrangedSubviews: [closeButton, iconImageView, timeSliderStackView, trackArtistNameStackView, controlStackView, volumeSlider])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 5
        mainStackView.backgroundColor = .lightGray
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35).isActive = true
        mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        trackArtistNameStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timeLabelStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    
}
