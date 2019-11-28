//
//  WelcomeViewController.swift
//  FirebaseIntegrationDemo
//
//  Created by Dheeraj Arora on 19/11/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import  AVKit

class WelcomeViewController: UIViewController {
    
    var videoPlayer: AVPlayer?
    var videoPlayerLayer: AVPlayerLayer?
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsElements()
        
    }
    override func viewWillAppear(_ animated: Bool) {
       self.navigationController?.setNavigationBarHidden(true, animated: true)
       
        //setup video in background
        setupVideoPlayer()
    }
    func setupViewsElements() {
        
        Utilities.styleFilledButton(btnLogin)
        Utilities.styleFilledButton(btnSignUp)
        
    }
    func setupVideoPlayer(){
        //get the path from the resource in the bundle
        let bundalPath = Bundle.main.path(forResource: "loginbg", ofType: ".mp4")
        guard  bundalPath != nil else {
            return
        }
        //create url from it
        let url = URL(fileURLWithPath: bundalPath!)
        
        //create the video player item
        let item = AVPlayerItem(url: url)
        
        //ceate the player
        videoPlayer = AVPlayer(playerItem: item)
        
        //create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
        
        //Adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        //Add it to the view and play it
       videoPlayer?.playImmediately(atRate: 0.3)
    }

}
