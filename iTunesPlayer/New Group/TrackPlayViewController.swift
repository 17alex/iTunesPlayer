//
//  TrackPlayViewController.swift
//  iTunesPlayer
//
//  Created by Alex on 17.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class TrackPlayViewController: UIViewController {
    
    // MARK: - Property
    
    private let playImage = UIImage(systemName: "play.fill")
    private let pauseImage = UIImage(systemName: "pause.fill")
    private let backwardImage = UIImage(systemName: "backward.fill")
    private let forwardImage = UIImage(systemName: "forward.fill")
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.image = UIImage(systemName: "chevron.down")
        button.setTitle("close", for: .normal)
        button.titleColor(for: .normal)
        button.backgroundColor = .orange
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
        slider.backgroundColor = .orange
        slider.setValue(0, animated: false)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private let elapsedTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "00:00"
        label.backgroundColor = .yellow
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "00:00"
        label.backgroundColor = .green
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(backwardImage, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(playImage, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(forwardImage, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.backgroundColor = .orange
        slider.setValue(0.2, animated: false)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    
    // MARK: - Live Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - Metods
    
    
    private func setupViews() {
        
        view.backgroundColor = .white
        
        let timeLabelStackView = UIStackView(arrangedSubviews: [elapsedTimeLabel, remainingTimeLabel])
        timeLabelStackView.axis = .horizontal
        timeLabelStackView.distribution = .fillEqually
        timeLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let timeSliderStackView = UIStackView(arrangedSubviews: [timeSlider, timeLabelStackView])
        timeSliderStackView.axis = .vertical
        timeSliderStackView.distribution = .fill
        timeSliderStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let controlStackView = UIStackView(arrangedSubviews: [backwardButton, playPauseButton, forwardButton])
        controlStackView.axis = .horizontal
        controlStackView.distribution = .fillEqually
        controlStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView(arrangedSubviews: [closeButton, iconImageView, timeSliderStackView, controlStackView, volumeSlider])
        mainStackView.axis = .vertical
        mainStackView.distribution = .fill
        mainStackView.spacing = 10
        mainStackView.backgroundColor = .lightGray
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor).isActive = true
        timeLabelStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    
}
