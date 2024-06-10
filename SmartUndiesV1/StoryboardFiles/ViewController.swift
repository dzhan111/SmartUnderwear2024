//
//  ViewController.swift
//  FartGif
//
//  Created by David on 7/26/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let fartGif = UIImage.gifImageWithName("circle")
        imageView.image = fartGif
            
    }


}

