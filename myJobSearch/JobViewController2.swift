//
//  JobViewController2.swift
//  myJobSearch
//
//  Created by chang on 2017/7/12.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit

class JobViewController2: UITableViewController {
    
    var currentRow = 0
    var db:OpaquePointer? = nil
    
    var dicRow = [String:Any?]()
    var arrJob2 = [[String:Any?]]()
    var arrJob3 = [[String:Any?]]()
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
        let sql =  String("SELECT yvtc_num,yvtc_name,yvtc_des,yvtc_visable FROM job_category where substr(yvtc_num,1,6) = '\(rowSelected)' and substr(yvtc_num,7,1) != '0' and substr (yvtc_num,-1,2) != '00';")
        
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
            arrJob3.append(dicRow)
        }

        sqlite3_finalize(statement)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrJob2.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = arrJob2[indexPath.row]["job_name"] as? String
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "job3" {
            let vc = segue.destination as! JobViewController3
            vc.arrJob3 = self.arrJob3
            vc.vcTop = self.vcTop
            print(vc.vcTop)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelected = String((arrJob2[indexPath.row]["job_no"] as! String).characters.prefix(6))
        getSql()
        performSegue(withIdentifier: "job3", sender: nil)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
