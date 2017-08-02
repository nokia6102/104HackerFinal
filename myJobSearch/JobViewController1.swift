//
//  JobViewController.swift
//  myJobSearch
//
//  Created by chang on 2017/7/12.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit

class JobViewController1: UITableViewController {
    
    var currentRow = 0
    var db:OpaquePointer? = nil
    
    var dicRow = [String:Any?]()
    var arrJob1 = [[String:Any?]]()
    var arrJob2 = [[String:Any?]]()
    var rowSelected = ""
    var vcTop = ViewController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            db = appDelegate.getDB()
        }
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func getSql(){
        //執行sql指令
        let sql = String("SELECT yvtc_num,yvtc_name,yvtc_des,yvtc_visable FROM job_category where substr(yvtc_num,1,6) = '\(rowSelected)' and substr(yvtc_num,7,1) != '0' and substr (yvtc_num,length(yvtc_num)-1,2) = '00';")
        //print(sql!)
        
        //第二層  Where substr(yvtc_num,5,3) <> '000' and substr(yvtc_num,8,3) = '000'
        //第三層  Where substr(yvtc_num,5,3) <> '000' and substr(yvtc_num,8,3) <> '000'
        let cSql = sql?.cString(using: .utf8)
        var statement:OpaquePointer? = nil
        
        sqlite3_prepare(db, cSql!, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW{
            let job_no = sqlite3_column_text(statement, 0)
            let cJobNo = String(cString: job_no!)
            let job_name = sqlite3_column_text(statement, 1)
            let cJobName = String(cString: job_name!)
            
            dicRow = ["job_no": cJobNo,"job_name": cJobName]
            arrJob2.append(dicRow)
        }
        sqlite3_finalize(statement)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrJob1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = arrJob1[indexPath.row]["job_name"] as? String
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "job2"{
            let vc = segue.destination as! JobViewController2
            vc.arrJob2 = self.arrJob2
            vc.vcTop = self.vcTop
            print(vc.vcTop)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取前七位數數字當作搜尋條件
        rowSelected = String((arrJob1[indexPath.row]["job_no"] as! String).characters.prefix(6))
        getSql()
        performSegue(withIdentifier: "job2", sender: nil)
    }
        //不用prepare的方法，storyboard需設id
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "job2vc") as! JobViewController2
//        vc.arrJob2 = self.arrJob2
//        self.present(vc, animated: true, completion: nil)
}
