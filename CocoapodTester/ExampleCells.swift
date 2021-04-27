//
//  ExampleCells.swift
//  ComposableDataSource_Example
//
//  Created by Chrishon Wyllie on 7/8/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import ComposableDataSource
import Celestial
import AVFoundation

struct Constants {
    private init() {}
    
    static let progressLabelHeight: CGFloat = 40
    static let horizontalPadding: CGFloat = 8
    static let verticalPadding: CGFloat = 12.0
}

class ExampleCell: BaseComposableCollectionViewCell {
    
    override func configure(with item: BaseCollectionCellModel, at indexPath: IndexPath) {
        guard let item = item as? URLCellModel else { fatalError() }
        titleLabel.text = item.urlString
    }
    
    fileprivate var progressLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    fileprivate var progressView: UIProgressView = {
        let v = UIProgressView(progressViewStyle: .default)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.progressTintColor = UIColor.red
        return v
    }()
    
    fileprivate var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 17)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.progress = 0
        progressLabel.text = ""
    }
    
    override func setupUIElements() {
//        super.setupUIElements()
        
        contentView.addSubview(containerView)
        
        [titleLabel, progressLabel, progressView].forEach { (subview) in
            super.containerView.addSubview(subview)
        }
        
        // Handle layout...
        
        super.containerView.backgroundColor = .white
        super.containerView.layer.cornerRadius = 10
        super.containerView.clipsToBounds = true
        
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalPadding).isActive = true
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalPadding).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalPadding).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: progressLabel.topAnchor, constant: -Constants.verticalPadding).isActive = true
        
        progressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding).isActive = true
        progressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding).isActive = true
        progressLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -Constants.verticalPadding).isActive = true
        progressLabel.heightAnchor.constraint(equalToConstant: Constants.progressLabelHeight).isActive = true
        
        progressView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.horizontalPadding).isActive = true
        progressView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.horizontalPadding).isActive = true
        progressView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.verticalPadding).isActive = true
    }
    
    func updateCompletion() {
        DispatchQueue.main.async {
            self.progressLabel.text = "Finished Downloadin'!"
        }
    }

    func updateProgress(_ progress: Float, humanReadableProgress: String) {
        DispatchQueue.main.async {
            self.progressView.progress = Float(progress)
            self.progressLabel.text = humanReadableProgress
        }
    }
    
    func updateError() {
        DispatchQueue.main.async {
            self.progressLabel.text = "Error downloading!"
            self.progressLabel.textColor = .red
        }
    }
}













// MARK: - VideoCell

protocol VideoCellDelegate: class {
    func videoCell(_ cell: VideoCell, requestsContainerSizeChanges requiredSize: CGSize)
}
class VideoCell: ExampleCell {
    
    public weak var delegate: VideoCellDelegate?
    
    override func configure(with item: BaseCollectionCellModel, at indexPath: IndexPath) {
        super.configure(with: item, at: indexPath)
        guard let item = item as? VideoCellModel else { fatalError() }

        let urlString = item.urlString
        
        let url = URL(string: urlString)!
        if Celestial.shared.videoExists(for: url, cacheLocation: .fileSystem) {
            titleLabel.text = "Video has been previously cached!"
        }
        
        playerView.loadVideoFrom(urlString: urlString)
        playerView.generateThumbnailImage(shouldCacheInMemory: true, completion: { (image) in
            print("Generated thumbnail image: \(String(describing: image))")
        })
    }
    
    public lazy var playerView: URLVideoPlayerView = {
        let v = URLVideoPlayerView(delegate: self, cacheLocation: .fileSystem)
        v.translatesAutoresizingMaskIntoConstraints = false
//        v.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        v.isMuted = true
        return v
    }()
    
    private lazy var playButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Play", for: .normal)
        btn.backgroundColor = UIColor.white
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        btn.addTarget(self, action: #selector(togglePlaying), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerView.reset()
    }
    
    override func setupUIElements() {
        super.setupUIElements()
        
        [playerView, playButton].forEach { (subview) in
            super.containerView.addSubview(subview)
        }
        
        playerView.backgroundColor = [UIColor.red, .orange, .yellow, .green, .blue].randomElement()
        
        // Handle layout...
        playerView.leadingAnchor.constraint(equalTo: super.containerView.leadingAnchor, constant: 0).isActive = true
        playerView.topAnchor.constraint(equalTo: super.containerView.topAnchor, constant: Constants.verticalPadding).isActive = true
        playerView.trailingAnchor.constraint(equalTo: super.containerView.trailingAnchor, constant: 0).isActive = true
        playerView.bottomAnchor.constraint(equalTo: super.titleLabel.topAnchor, constant: -Constants.verticalPadding).isActive = true
        
        playButton.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: -Constants.horizontalPadding).isActive = true
        playButton.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -Constants.verticalPadding).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    @objc private func togglePlaying() {
        let shouldBeginPlaying: Bool = playerView.isPlaying == false
        shouldBeginPlaying ? playerView.play() : playerView.pause()
        if shouldBeginPlaying {
            playerView.loop(didReachEnd: {
                print("Did reach end, looping")
            })
        } else {
            playerView.stopLooping()
        }
        let newPlayButtonTitle = shouldBeginPlaying ? "Play" : "Pause"
        playButton.setTitle(newPlayButtonTitle, for: UIControl.State.normal)
    }
    
    public func getTotalVerticalPadding() -> CGFloat {
        // The total number vertical padding in between the UI elements.
        // NOTE: This is a hardcoded value for this particular cell.
        return Constants.verticalPadding * 7
    }
}

extension VideoCell: URLVideoPlayerViewDelegate {
    
    func urlVideoPlayerIsReadyToPlay(_ view: URLVideoPlayerView) {
        print("\n")
        print("Self frame: \(self.frame)")
        print("Self containerView frame: \(self.containerView.frame)")
        
        if self.playerView.frame != .zero {
            let playerViewWidth: CGFloat = self.playerView.frame.width
            let requiredSize = view.requiredSizeFor(width: playerViewWidth)
            delegate?.videoCell(self, requestsContainerSizeChanges: requiredSize)
        }
    }
    
    func urlCachableView(_ view: URLCachableView, didFinishDownloading media: Any) {
        super.updateCompletion()
    }
   
    func urlCachableView(_ view: URLCachableView, downloadFailedWith error: Error) {
        super.updateError()
    }
   
    func urlCachableView(_ view: URLCachableView, downloadProgress progress: Float, humanReadableProgress: String) {
        super.updateProgress(progress, humanReadableProgress: humanReadableProgress)
    }
    
}

























// MARK: - ImageCell

class ImageCell: ExampleCell {
    
    override func configure(with item: BaseCollectionCellModel, at indexPath: IndexPath) {
        super.configure(with: item, at: indexPath)

        guard let item = item as? ImageCellModel else { fatalError() }

//        imageView.loadImageFrom(urlString: someCellModel.urlString)

        imageView.loadImageFrom(urlString: item.urlString, progressHandler: { (progress) in
            print("current downlod progress: \(progress)")
            self.updateProgress(progress, humanReadableProgress: "Not sure")
        }, completion: {
            print("Image has finished loading")
            self.updateCompletion()
        }) { (error) in
            print("Error loading image")
            self.updateError()
        }
    }

    // Initialize the URLImageView within the cell as a variable.
    // NOTE: The second initializer is used which does NOT have the urlString argument.
    private lazy var imageView: URLImageView = {
        let img = URLImageView(delegate: self, cacheLocation: .inMemory)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .gray
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    
    
    override func setupUIElements() {
        super.setupUIElements()
        
        [imageView].forEach { (subview) in
            containerView.addSubview(subview)
        }
        
        // Handle layout...
        imageView.leadingAnchor.constraint(equalTo: super.containerView.leadingAnchor, constant: Constants.horizontalPadding).isActive = true
        imageView.topAnchor.constraint(equalTo: super.containerView.topAnchor, constant: Constants.verticalPadding).isActive = true
        imageView.trailingAnchor.constraint(equalTo: super.containerView.trailingAnchor, constant: -Constants.horizontalPadding).isActive = true
        imageView.bottomAnchor.constraint(equalTo: super.titleLabel.topAnchor, constant: -Constants.verticalPadding).isActive = true
    }
}

extension ImageCell: URLCachableViewDelegate {
    
    func urlCachableView(_ view: URLCachableView, didFinishDownloading media: Any) {
//        updateCompletion()
    }
    
    func urlCachableView(_ view: URLCachableView, downloadFailedWith error: Error) {
//        updateError()
    }
    
    func urlCachableView(_ view: URLCachableView, downloadProgress progress: Float, humanReadableProgress: String) {
//        updateProgress(progress, humanReadableProgress: humanReadableProgress)
    }
}
