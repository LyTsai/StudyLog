//
//  AVPlayerSample.swift
//  Demo_testUI
//
//  Created by iMac on 2018/9/30.
//  Copyright © 2018年 LyTsai. All rights reserved.
//

import Foundation
import AVFoundation

class AVPlayerSample: NSObject, AVAssetResourceLoaderDelegate {
    fileprivate var playerItem: AVPlayerItem!
    fileprivate var player: AVPlayer!
    fileprivate var timeObserver: Any!
    fileprivate let urlString = "https://annielyticx-content.azurewebsites.net/voice/BrainAge/Q1%20sleep%20m.mp3"
    func create() {
        player = AVPlayer(url: URL(string: urlString)!)
        playerItem = player.currentItem!
        player.play()
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: DispatchQueue.main) { (time) in
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds(self.playerItem.duration)
            
            print("current: \(current), total: \(total)")
        }
        
        playerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        notificationCenter.addObserver(self, selector: #selector(playFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    func removeObservers() {
        player.removeTimeObserver(timeObserver)
        timeObserver = nil
    }
    
    // in viewController or appDelegate??
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
    
//    override func remoteControlReceived(with event: UIEvent?) {
//        switch event!.subtype {
//        case UIEventSubtype.remoteControlPlay:
//            print({"hello"})
//        default:
//            break
//        }
//    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loadedTimeRanges" {
            let ranges = playerItem.loadedTimeRanges // [NSValue]
            let timeRange = ranges.first!.timeRangeValue
            let totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)
            print("total: \(CMTimeGetSeconds(playerItem.duration)), buffer: \(totalBuffer)")
        }else if keyPath == "status" {
            switch playerItem.status {
            case .readyToPlay: print("ready to play")
            case .unknown: print("unknow")
            case .failed: print("failed")
            }
        }
    }
    
    func playFinished() {
        print("play finished")
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
    }
    
    // ------------------------ scheme----------------
    func createWithDelegate() {
        let asset = AVURLAsset(url: URL(string: urlString)!)
//        let resourceLoader = AVAssetResourceLoader()
        asset.resourceLoader.setDelegate(self, queue: DispatchQueue.main)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        addLoadingRequest(loadingRequest)
        return true
    }
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, didCancel loadingRequest: AVAssetResourceLoadingRequest) {
        removeLoadingRequest(loadingRequest)
    }
    
    func addLoadingRequest(_ loadingRequest: AVAssetResourceLoadingRequest) {
        
    }
    func removeLoadingRequest(_ loadingRequest: AVAssetResourceLoadingRequest) {
        
    }
}

