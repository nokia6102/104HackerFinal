
import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var detailVC:JobDetailViewController!
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.tabBarController?.tabBar.isHidden = false
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

  

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if Auth.auth().currentUser != nil {
        performSegue(withIdentifier: "LoginToChat", sender: nil)
    }
  }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //let navVc = segue.destination as! UINavigationController
        
        if segue.identifier == "LoginToChat"{
        let channelVc = segue.destination as! ChannelListViewController
        channelVc.detailVC = self.detailVC
        channelVc.senderDisplayName = txtUsername.text
        }
}
    
    
    @IBAction func signIn(_ sender: UIButton) {
        
        if txtUsername.text != "" && txtPassword.text != ""
        {
            Auth.auth().signIn(withEmail: txtUsername.text!, password: txtPassword.text!, completion: { (user, error) in
                if error != nil
                {
                    let alert = UIAlertController(title: "錯誤", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    //新增預設登入
                    self.performSegue(withIdentifier: "LoginToChat", sender: nil)
                    //UserDefaults.standard.set(user!.email, forKey: "user")
                    //UserDefaults.standard.synchronize()
                    
                    
                    //let delegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    //delegate.rememberLogin()
                }
            })
        }else{
            print("請提供資訊")
        }
        
        
        
    }
    @IBAction func signUp(_ sender: UIButton) {
        
        if txtUsername.text != "" && txtPassword.text != ""
        {
            Auth.auth().createUser(withEmail: txtUsername.text!, password: txtPassword.text!, completion: { (user, error) in
                if error != nil{
                    let alert = UIAlertController(title: "錯誤", message: error?.localizedDescription, preferredStyle: .alert)
                    let ok  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.performSegue(withIdentifier: "LoginToChat", sender: nil)
                    
                    //UserDefaults.standard.set(user!.email, forKey: "user")
                    //UserDefaults.standard.synchronize()
                    
                    
                    //let delegate :AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    //delegate.rememberLogin()
                }
            })
            
        }else{
            let alert = UIAlertController(title: "錯誤", message: "請提供正確資訊", preferredStyle: .alert)
            let ok  = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
  
}

