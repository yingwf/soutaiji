//
//  YYScrollView.swift
//
//
//  Created by  ywf on 16/5/24.
//
//

import UIKit
import SDWebImage

class YYScrollView: UIView,UIScrollViewDelegate {
    private var timer: NSTimer?
    private var sourceArr = [String]()
    private var scrollView: UIScrollView?
    private var pageControl: UIPageControl?
    internal var delegate: UIScrollViewDelegate?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sourceArr = []
        self.initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.sourceArr = []
        self.initSubViews()
        
    }
    
    internal func initWithImgs(imageViews: [String]){
        self.sourceArr = imageViews
        self.userInteractionEnabled = true
        self.initSubViews()
    }
    
    private func initSubViews(){
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        let count = self.sourceArr.count
        
        if scrollView != nil {
            scrollView?.removeFromSuperview()
            scrollView = nil
        }
        self.scrollView = UIScrollView(frame:self.frame)
        self.scrollView!.userInteractionEnabled = true
        self.scrollView!.delegate = self
        self.scrollView!.pagingEnabled = true
        self.scrollView!.contentSize = CGSizeMake(width * CGFloat(sourceArr.count+2), height)
        self.scrollView!.showsVerticalScrollIndicator = false
        self.scrollView!.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView!)
        
        if (count == 0){
            //没有图片时，显示默认图片
            let defaultImageView = UIImageView()
            defaultImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            //defaultImageView.image = UIImage(named: "loading")
            defaultImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            defaultImageView.frame = CGRectMake(0,0,width,height)
            self.scrollView!.addSubview(defaultImageView)
        }else{
            let firstImageView = UIImageView()
            firstImageView.image = UIImage(named: "loading")
            firstImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            firstImageView.sd_setImageWithURL(NSURL(string: self.sourceArr.last!))
            firstImageView.frame = CGRectMake(0,0,width,height)
            firstImageView.contentMode = .ScaleToFill
            self.scrollView!.addSubview(firstImageView)
        }
        
        
        if (count > 0) {
            for index in 0 ... count - 1 {
                let imageView = UIImageView()
                imageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                imageView.sd_setImageWithURL(NSURL(string: sourceArr[index]))
                imageView.frame = CGRectMake(width * CGFloat(index + 1), 0, width, height)
                imageView.contentMode = .ScaleToFill
                self.scrollView!.addSubview(imageView)
            }
        }
        
        if (count > 0){
            let lastImageView = UIImageView()
            lastImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            lastImageView.sd_setImageWithURL(NSURL(string: self.sourceArr.first!))
            
            lastImageView.frame = CGRectMake(width * CGFloat(count + 1),0,width,height)
            lastImageView.contentMode = .ScaleToFill
            self.scrollView!.addSubview(lastImageView)
        }
        
        if self.pageControl != nil{
            self.pageControl?.removeFromSuperview()
            self.pageControl = nil
        }
        self.pageControl = UIPageControl(frame:CGRectMake(0, height-20, width, 20))
        self.pageControl!.numberOfPages = sourceArr.count
        self.pageControl!.currentPage = 0
        self.pageControl!.enabled = true
        self.pageControl!.currentPageIndicatorTintColor = UIColor.whiteColor()
        self.pageControl!.pageIndicatorTintColor = UIColor(red: 0xff/255, green: 0xff/255, blue: 0xff/255, alpha: 0.3)
        //设置页控件点击事件
        self.pageControl!.addTarget(self, action: #selector(pageChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        self.addSubview(self.pageControl!)
        
        
        if (count > 1) {
            self.scrollView!.scrollRectToVisible(CGRectMake(width, 0, width, height), animated: false)
            
            self.timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
            self.scrollView!.scrollEnabled=true
        }else{
            self.scrollView!.scrollEnabled=false
        }
        
    }
    
    
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //        let scrollviewW =  self.scrollView.frame.size.width
    //        let page = Int((self.scrollView.contentOffset.x + CGFloat( scrollviewW / 2)) / scrollviewW)
    //        self.pageControl.currentPage = page
    //    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.removeTimer()
    }
    //    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        self.addTimer()
    //    }
    //开启定时器
    func addTimer(){
        self.timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
    }
    //关闭定时器
    func removeTimer(){
        self.timer?.invalidate()
    }
    
    func nextImage(){
        let width = self.scrollView!.frame.size.width
        let height = self.scrollView!.frame.size.height
        var currentPage = Int(self.scrollView!.contentOffset.x/width)
        
        if(currentPage == 0){
            currentPage = self.sourceArr.count - 1
        }else if(currentPage == self.sourceArr.count + 1){
            currentPage = 0
        }else{
            currentPage = currentPage - 1
        }
        
        let rect = CGRectMake(CGFloat(currentPage + 2) * width, 0, width, height)
        self.scrollView!.scrollRectToVisible(rect, animated: true)
        
        currentPage += 1
        
        if (currentPage == sourceArr.count){
            //            let newRect = CGRectMake(viewSize.width,0,viewSize.width,viewSize.height)
            //            self.scrollView!.scrollRectToVisible(newRect, animated: true)
            currentPage = 0
        }
        self.pageControl!.currentPage = currentPage
        
    }
    
    //点击页控件时事件处理
    func pageChanged(sender:UIPageControl) {
        //根据点击的页数，计算scrollView需要显示的偏移量
        var frame = self.scrollView!.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage + 1)
        frame.origin.y = 0
        //展现当前页面内容
        scrollView!.scrollRectToVisible(frame, animated:true)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView){
        //自动切换结束动画时
        let width = self.scrollView!.frame.size.width
        let height = self.scrollView!.frame.size.height
        let currentPage = Int(self.scrollView!.contentOffset.x/width)
        
        if (currentPage == 0) {
            self.scrollView!.scrollRectToVisible(CGRectMake(width * CGFloat(sourceArr.count), 0, width, height), animated:false)
            
        }else if (currentPage == sourceArr.count + 1) {
            self.scrollView!.scrollRectToVisible(CGRectMake(width, 0, width, height),animated:false)
        }
        
    }
    //    func changePage(sender: AnyObject) {
    //        UIView.animateWithDuration(0.3, animations:{
    //            let whichPage = self.pageControl.currentPage
    //            self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * CGFloat(whichPage), 0)
    //        })
    //
    //    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let width = self.scrollView!.frame.size.width
        let height = self.scrollView!.frame.size.height
        let currentPage = Int(self.scrollView!.contentOffset.x/width)
        
        if (currentPage == 0) {
            self.scrollView!.scrollRectToVisible(CGRectMake(width * CGFloat(sourceArr.count), 0, width, height), animated:false)
            self.pageControl!.currentPage = sourceArr.count - 1
            
        }else if (currentPage == sourceArr.count + 1) {
            self.scrollView!.scrollRectToVisible(CGRectMake(width, 0, width, height),animated:false)
            self.pageControl!.currentPage = 0
        }
        else {
            self.pageControl!.currentPage = currentPage - 1
        }
        
        if (sourceArr.count>1) {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
            self.scrollView!.scrollEnabled = true
        }
        else
        {
            self.scrollView!.scrollEnabled = false
        }
        
    }
    
    
    
    
}