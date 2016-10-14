//
//  ViewController.swift
//  PictureLogo
//
//  Created by mac on 16/10/11.
//  Copyright © 2016年 Jon. All rights reserved.
//

import UIKit
let ScreenWidth = UIScreen.mainScreen().bounds.width
let ScreenHeight = UIScreen.mainScreen().bounds.height

class ViewController: UIViewController, UIScrollViewDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!

    let bgImage = UIImageView()         //图纸
    let newImageView = UIImageView()    //图标
    var imagePath = ""                  //图纸存放到本地的路径
    var logosView = [UIImageView]()     //存放所有的logo
//    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configImage()
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(showMenu(_:)))
        bgImage.addGestureRecognizer(swipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:  设置图片
    func configImage() {

        scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 100)
        bgImage.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 100)
        bgImage.image = UIImage(named: "工程图")
        bgImage.userInteractionEnabled = true //可交互
        scrollView.maximumZoomScale = 5
        scrollView.bouncesZoom = false
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.addSubview(bgImage)

        //创建图标
        newImageView.frame = CGRectMake(-100, 0, 100, 50)
        newImageView.image = UIImage(named: "1")
        newImageView.userInteractionEnabled = true
        newImageView.backgroundColor = UIColor.redColor()
        
        //添加手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPan(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(sure(_:)))
        tap.numberOfTapsRequired = 2
        let long = UILongPressGestureRecognizer(target: self, action: #selector(resetFrame(_:)))
        
        newImageView.addGestureRecognizer(pan)
        newImageView.addGestureRecognizer(tap)
        newImageView.addGestureRecognizer(long)
        scrollView.addSubview(newImageView)
        
        //创建侧滑菜单
        
    }
    
    //MARK: 点击按钮移动图标至中心位置
    @IBAction func productPicture(sender: UIButton) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        newImageView.center = CGPoint(x: (scrollView.frame.size.width/2)+x, y: (scrollView.frame.size.height/2)+y)
    }
    
    //MARK: 打印图片
    @IBAction func productImage(sender: UIButton) {
        
        for logo in logosView {
            bgImage.image =  bgImage.image!.waterMarkedImage(logo.image!, markFrame: logo.frame)
        }
        
        saveImage(bgImage.image!)
        
        //重置图标
        newImageView.frame.origin = CGPointMake(-100, 0)
    }
    
    //MARK: 查看图纸
    @IBAction func lookImage(sender: UIButton) {
        let controller = LookImageViewController()
        controller.imagePath = self.imagePath
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    //MARK: 保存图片
    func saveImage(image: UIImage) {
        //当前时间的时间戳
        let timeInterval:NSTimeInterval = NSDate().timeIntervalSince1970
        imagePath = "/Documents/\(Int(timeInterval)).png"
        print(imagePath)
        
        let path = NSHomeDirectory().stringByAppendingString(imagePath)
        let data = UIImagePNGRepresentation(image)
        data!.writeToFile(path, atomically: true)
    }
    
    //MARK: 双击确定
    func sure(sender: UITapGestureRecognizer) {
        
        let n = scrollView.zoomScale
        let newX = newImageView.frame.origin.x
        let newY = newImageView.frame.origin.y
        let newW = newImageView.frame.size.width
        let newH = newImageView.frame.size.height
        
        //创建图标
        let addImage = UIImageView(frame: CGRect(x: newX/n, y: newY/n, width: newW/n, height: newH/n))
        addImage.image = UIImage(named: "1")
        addImage.backgroundColor = UIColor.blueColor()
        addImage.userInteractionEnabled = true
        let long = UILongPressGestureRecognizer(target: self, action: #selector(remove(
            _:)))
        addImage.addGestureRecognizer(long)
        bgImage.addSubview(addImage)
        
        //将图标添加到图标数组中
        logosView.append(addImage)
        
        //重置图标
        newImageView.frame.origin = CGPointMake(-100, 0)
    }
    
    //MARK: 拖动触发事件
    func viewPan(sender: UIPanGestureRecognizer) {
        //打印拖动的坐标
        print("(\(sender.view!.frame.origin.x):\(sender.view!.frame.origin.y))")

        let point = sender.translationInView(self.view)
        sender.view!.center = CGPointMake(sender.view!.center.x+point.x, sender.view!.center.y+point.y)
        sender.setTranslation(CGPointMake(0, 0), inView: self.view)
        
    }
    
    //MARK: 长按删除
    func remove(sender: UILongPressGestureRecognizer) {
        sender.view?.removeFromSuperview()
        
        //从数据中删除
        for (index,item) in logosView.enumerate() {
            if item == sender.view {
                logosView.removeAtIndex(index)
            }
        }
    }
    
    //长按重置图标
    func resetFrame(sender: UILongPressGestureRecognizer) {
        newImageView.frame.origin = CGPointMake(-100, 0)
    }
    
    //MARK: 滑动手势
    func showMenu(sender: UISwipeGestureRecognizer) {
        //TODO: 尚未开发
        if sender.direction == UISwipeGestureRecognizerDirection.Right {
            print("==================")
        }
    }
    
    //MARK: 缩放
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return bgImage;
    }

}

extension UIImage{
    
    //添加图片水印方法
    func waterMarkedImage(waterMarkImage:UIImage, markFrame:CGRect) -> UIImage{
        
        //设置画板大小()
        let imageSize = CGSizeMake(ScreenWidth, ScreenHeight - 100)
        
        //开启图片上下文
        UIGraphicsBeginImageContext(imageSize)

        //图形重绘
        self.drawInRect(CGRectMake(0, 0, imageSize.width, imageSize.height))
        //绘制图片
        waterMarkImage.drawInRect(markFrame)
        //从当前上下文获取图片
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return waterMarkedImage
    }
}

