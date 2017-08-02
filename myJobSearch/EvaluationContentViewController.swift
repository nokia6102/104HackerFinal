//
//  ViewController.swift
//  EvaluationContent
//
//  Created by leo_unision on 2017/7/24.
//  Copyright © 2017年 unision. All rights reserved.
//

import UIKit

class EvaluationContentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource    {
    
    var stars : Float =  4.0
    var mydesc: String = "十分愉快的交談過程，對於工作內容及公司的介紹都十分清楚，對專業的要求可以清楚的說明並溝通！"
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var floatRatingView = FloatRatingView()
    @IBOutlet weak var lblDesc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        myTableView.delegate = self
        myTableView.dataSource = self
        self.floatRatingView?.rating = stars
        self.floatRatingView?.editable = false
        lblDesc.text = mydesc

    }
    
    //MARK: Table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
        
        return cell
    }
    
    
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float)
    {
        //        print( NSString(format: "%.2f", self.floatRatingView.rating) as String)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float)
    {
        
        print( NSString(format: "%.2f", (self.floatRatingView?.rating)!) as String)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

