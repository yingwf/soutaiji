//
//  BuyContactViewController.swift
//  SouTaiji
//
//  Created by  ywf on 16/3/31.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class BuyContactViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var payLabel: UILabel!
    
    let reuseIdentifier = "BuyContactCollectionViewCell"
    let contactNumberArray = ["半年","一年"]
    let contactFeeArray = [600, 1000]
    var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Register cell classes
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerNib(UINib(nibName: "BuyContactCollectionViewCell", bundle:nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsetsMake(7, 7, 0, 7)
        let width = UIScreen.mainScreen().bounds.width/2 - 10
        layout.itemSize = CGSize(width: width, height: 63)
        self.collectionView.collectionViewLayout = layout
        self.collectionView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        
        
        self.setBackButton()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BuyContactCollectionViewCell
        // Configure the cell
        cell.contactNumberLabel.text = contactNumberArray[indexPath.row]
        cell.contactFeeLabel.text = String(contactFeeArray[indexPath.row]) + "元"
        return cell
    }
    
    
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.contentView.layer.borderWidth = 1
        cell?.contentView.layer.borderColor = UIColor(red: 0x8c/255, green: 0x18/255, blue: 0x02/255, alpha: 1).CGColor
        payLabel.text = "￥\(contactFeeArray[indexPath.item])元"
        self.currentIndex = indexPath.row
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath){
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.contentView.layer.borderWidth = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoPay(sender: AnyObject) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PayViewController") as! PayViewController
        vc.payType = .Vip
        vc.productName = "购买会员（\(contactNumberArray[currentIndex])期）"
        vc.orderFee = contactFeeArray[currentIndex]
        vc.month = currentIndex == 0 ? 6 : 12
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
