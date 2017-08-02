
import UIKit
import Firebase
import JSQMessagesViewController


final class ChatViewController: JSQMessagesViewController {

  // MARK: Properties
    var channelRef: DatabaseReference?
    var channel: Channel? {
        didSet {
            title = channel?.name
        }
    }
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    private lazy var messageRef: DatabaseReference = self.channelRef!.child("messages")
    private var newMessageRefHandle: DatabaseHandle?
    
    private lazy var userIsTypingRef: DatabaseReference =
        self.channelRef!.child("typingIndicator").child(self.senderId) // 1
    private var localTyping = false // 2
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            // 3
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    private lazy var usersTypingQuery: DatabaseQuery =
        self.channelRef!.child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)

    let arrAvatar = [UIImage(named: "yelp.png"),UIImage(named: "myspace.png")]
  
  // MARK: View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //senderId
    self.senderId = Auth.auth().currentUser?.uid
    
    collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize(width: 30, height: 30)
    collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: 30, height: 30)
    self.inputToolbar.contentView.leftBarButtonItem = nil
    self.observeMessages()
    self.tabBarController?.tabBar.isHidden = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.observeTyping()

    
//    // messages from someone else
//    addMessage(withId: "foo", name: "Mr.Bolt", text: "I am so fast!")
//    // messages sent from local sender
//    addMessage(withId: senderId, name: "Me", text: "I bet I can run faster than you!")
//    addMessage(withId: senderId, name: "Me", text: "I like to run!")
//    // animates the receiving of a new message on the view
//    finishReceivingMessage()

  }
  
  // MARK: Collection view data source (and related) methods
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    private func addMessage(withId id: String, name: String, text: String){
        if let message = JSQMessage(senderId: id, displayName: name, text: text){
            messages.append(message)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.row]
        
        if message.senderId == senderId{
            cell.textView.textColor = UIColor.white
            cell.avatarImageView.image = arrAvatar[0]
        }else{
            cell.textView.textColor = UIColor.black
            cell.avatarImageView.image = arrAvatar[1]
        }
        return cell
    }
    
    

  
  // MARK: Firebase related methods
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            "senderId": senderId!,
            "senderName": senderDisplayName,
            "text": text!,
            ]
        
        itemRef.setValue(messageItem)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
        isTyping = false
    }
    
    private func observeMessages(){
        messageRef = channelRef!.child("messages")
        let messageQuery = messageRef.queryLimited(toLast: 25)
        
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) in
            let messageData = snapshot.value as! Dictionary<String,String>
            
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"] as String!, let text = messageData["text"] as String!, text.characters.count > 0{
                self.addMessage(withId: id, name: name, text: text)
                self.finishReceivingMessage()

            }else{
                print("訊息錯誤")
            }

        })
    }

  
  
  // MARK: UI and User Interaction
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage{
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }

    private func setupIncomingBubble() -> JSQMessagesBubbleImage{
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.row]
        if message.senderId == senderId{
            return outgoingBubbleImageView
        }else{
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
  
  // MARK: UITextViewDelegate methods
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        print(isTyping = textView.text != "")
    }
    private func observeTyping() {
        let typingIndicatorRef = channelRef!.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        
        usersTypingQuery.observe(.value) { (data: DataSnapshot) in
            // 2 You're the only one typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            // 3 Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottom(animated: true)
        }

    }

}
