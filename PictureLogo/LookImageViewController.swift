//
//  LookImageViewController.swift
//  PictureLogo
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 Jon. All rights reserved.
//

import UIKit

class LookImageViewController: UIViewController {

    @IBOutlet weak var myImage: UIImageView!
    var imagePath = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: 获取图片
    func getImage() {
        var data = NSData()
        let path = NSHomeDirectory().stringByAppendingString(imagePath)
        
        do {
            try  data = NSData(contentsOfFile: path, options: .UncachedRead)
        } catch {
            print("找不到文件")
        }
        myImage.image = UIImage(data: data)
    }


}
