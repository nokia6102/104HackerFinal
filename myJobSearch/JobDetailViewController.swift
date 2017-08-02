//
//  JobDetailViewController.swift
//  myJobSearch
//
//  Created by chang on 2017/7/23.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit

class JobDetailViewController: UIViewController{

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblJob: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblOther: UILabel!
    @IBOutlet weak var lblInvoice: UILabel!
    
    var JsrVC:JobSearchResultViewController!
    var selectedRow = 0
    var jobInvoice = ""
    var companyName = ""
    var receiveEmail = "104@104.104"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentRow = JsrVC.resultJob[selectedRow]
        
        lblJob.text = currentRow["job_title"] as? String
        lblCompany.text = currentRow["job_name"] as? String
        lblContent.text = currentRow["job_desc"] as? String
        lblOther.text = currentRow["job_other"] as? String
        lblInvoice.text = currentRow["job_invoice"] as? String
        companyName = (currentRow["job_name"] as? String)!
        jobInvoice = (currentRow["job_invoice"] as? String)!
        
        
        
        //ScrollView拉contentView進來後需要設定好constraint後才能資料才不會跑版
        scrollView.contentSize.height = contentView.frame.height
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatLogin"{
            let vc = segue.destination as! LoginViewController
                vc.detailVC = self
        }
    }

    @IBAction func btnChatInvited(_ sender: Any) {
        performSegue(withIdentifier: "chatLogin", sender: nil)
    }


}
