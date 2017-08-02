
import UIKit
import Firebase

class ChannelListViewController: UITableViewController {
    
    var senderDisplayName :String?
    var newChannelTextField :UITextField?
    private var channels: [Channel] = []
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    private var channelRefHandle: DatabaseHandle?
    
    
    enum Section: Int {
        case createNewChannelSection = 0
        case currentChannelSection
    }
    
    //串接
    var detailVC:JobDetailViewController!
    
    var invoice : String = ""
    var companyName : String? = ""
    var senderEmail:String? = ""
    
    //拉最後一筆訊息
    private lazy var messageRef: DatabaseReference = self.channelRef.child("messages")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "線上交談列表"
        self.senderEmail = (Auth.auth().currentUser?.email)!
        
        print(detailVC)
        //自己呼叫自己的IBACTION(Anyobject) 所以裡面需要放self
        //createChannel(self)
        self.navigationItem.setHidesBackButton(true, animated: false)
        observeChannels()
        
    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        if let channel = sender as? Channel{
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            chatVc.channelRef = channelRef.child(channel.id)
        }
    }

    

    
    //MARK: UItableviewdatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currentSection: Section = Section(rawValue: section){
            switch currentSection {
            case .createNewChannelSection:
                return 1
            case .currentChannelSection:
                return channels.count
            }
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifer = (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue ? "NewChannel" : "ExistingChannel"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        
        if (indexPath as NSIndexPath).section == Section.createNewChannelSection.rawValue{
            if let createNewChannelCell = cell as? CreateChannelCell {
                newChannelTextField = createNewChannelCell.newChannelNameField
            }
        }else if (indexPath as NSIndexPath).section == Section.currentChannelSection.rawValue{
            if let cellList = cell as? ChannelListTableViewCell {
            //cell.textLabel?.text = channels[(indexPath as NSIndexPath).row].name
                //imgAvatar改size要先去tableview改row height
                cellList.imgAvatar.image = UIImage(named: "myspace.png")
                cellList.imgAvatar.frame.size = CGSize(width: 80, height: 80)
                cellList.lblTitle.text = channels[(indexPath as NSIndexPath).row].name
                //cellList.lblChat.text =
            }

        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Section.currentChannelSection.rawValue{
            let channel = channels[(indexPath as NSIndexPath).row]
            self.performSegue(withIdentifier: "ShowChannel", sender: channel)
        }
    }
    
    
    //MARK: Channlels
    private func observeChannels(){
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            if let name = channelData["name"] as! String!, name.characters.count > 0 {
                if channelData["senderEmail"] as! String! == self.senderEmail
                    || channelData["receiverEmail"] as! String! == self.senderEmail //加上receiverEmail
                {
                    //當有聊天列表的時候，建立聊天btn應該要disabled
//                    if let createNewChannelCell = self.tableView.dequeueReusableCell(withIdentifier: "NewChannel") as? CreateChannelCell {
//                        createNewChannelCell.createChannelButton.isEnabled = false
//                    }

                self.channels.append(Channel(id: id, name: name))
                    self.tableView.reloadData()
                }
                else{
                    self.newChannelTextField?.text = self.detailVC.companyName
//                    self.createNewChannel()
//                    self.tableView.reloadData()
                }
            }else{
                print("錯誤囉!!")
            }
        })
    }
    
    // MARK :Actions
    @IBAction func createChannel(_ sender: AnyObject) {
        newChannelTextField?.text = detailVC.companyName
        if let name = newChannelTextField?.text { // 1
            let newChannelRef = channelRef.childByAutoId() // 2
            let channelItem = [ // 3
                "name": name,
                "senderEmail" :  senderEmail,
                "companyInvoice" : detailVC.jobInvoice,
                "receiverEmail" : detailVC.receiveEmail
            ]
            newChannelRef.setValue(channelItem) // 4
        }
        
        //            let channelItem = [ // 3
        //                "name": name,
        //                "senderEmail" :  senderEmail,
        //                "companyInvoice" : detailVC.jobInvoice
        //            ]
    }
    /*
    func createNewChannel() {
            let newChannelRef = channelRef.childByAutoId() // 2
            let channelItem = [ // 3
                "name": detailVC.companyName,
                "senderEmail" :  senderEmail,
                "companyInvoice" : detailVC.jobInvoice,
                "receiverEmail" : detailVC.receiveEmail
            ]
            newChannelRef.setValue(channelItem) // 4
    }
    */



    @IBAction func btnLogoutClicked(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do
            {
                try Auth.auth().signOut();
                self.navigationController?.popToRootViewController(animated: true)
            } catch {
                print("Something Error")
            }
        }

        
    }
}
