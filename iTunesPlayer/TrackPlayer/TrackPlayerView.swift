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
    
    var mainStackView: UIStackView!
    weak var delegate: SearchViewController?
    
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
        button.addTarget(self, action: #selector(minimizePlayer), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 5
        imageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "00:00"
//        label.backgroundColor = .green
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
        button.setImage(pauseImage, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(playPayseButtonPress), for: .touchUpInside)
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
        backgroundColor = .orange
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
        let artworkUrl600 = track.artworkUrl60?.replacingOccurrences(of: "60x60", with: "600x600")
        setIconImage(with: artworkUrl600)
        playTrack(stringURL: track.previewUrl)
        addObserverStartTime()
        addObserveCurrentTime()
    }
    
    private func enlargeIconImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.iconImageView.transform = .identity
        }, completion: nil)
    }
    
    private func reduceIconImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: { [weak self] in
            self?.iconImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: nil)
    }
    
    private func addObserverStartTime() {
        let time = CMTimeMake(value: 1, timescale: 10)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeIconImageView()
        }
    }
    
    private func addObserveCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 5)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (cmTime) in
            self?.elapsedTimeLabel.text = cmTime.toDisplayString()
            
            if let durationCmTime = self?.player.currentItem?.duration {
                self?.remainingTimeLabel.text = String("-" + (durationCmTime - cmTime).toDisplayString())
                self?.updateTimeSlider(percentage: Float(CMTimeGetSeconds(cmTime) / CMTimeGetSeconds(durationCmTime)))
            } else {
                self?.remainingTimeLabel.text = String("--:--")
                self?.updateTimeSlider(percentage: 0)
            }
        }
    }
    
    private func updateTimeSlider(percentage: Float) {
        timeSlider.value = percentage
    }
    
    private func setIconImage(with stringUrl: String?) {
        
        delegate?.getImage(from: stringUrl, complete: { [weak self] (image) in
            self?.iconImageView.image = image
        })
    }
    
    @objc
    private func playPayseButtonPress() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(pauseImage, for: .normal)
            enlargeIconImageView()
        } else {
            player.pause()
            playPauseButton.setImage(playImage, for: .normal)
            reduceIconImageView()
        }
    }
    
    @objc
    private func minimizePlayer() {
        delegate?.minimizePlayer()
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
        
        mainStackView = UIStackView(arrangedSubviews: [closeButton, iconImageView, timeSliderStackView, trackArtistNameStackView, controlStackView, volumeSlider])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 2
        mainStackView.backgroundColor = .lightGray
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25).isActive = true
        mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        trackArtistNameStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timeLabelStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        
    }
    
    
}
