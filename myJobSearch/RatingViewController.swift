//
//  ViewController.swift
//  EvaluationMessage
//
//  Created by leo_unision on 2017/7/23.
//  Copyright © 2017年 unision. All rights reserved.
//

import UIKit
import Firebase

class RatingViewController: UIViewController,UITextViewDelegate,FloatRatingViewDelegate {
    
    @IBOutlet weak var uitextEvaluationMessage: UITextView!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    
    
    var evContent : UIView!
    var ref : DatabaseReference!
    
    
    var floatStars:Float = 0.0
    
    
    func setDoneOnKeyboard() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.uitextEvaluationMessage.inputAccessoryView = keyboardToolbar
    }
    
    func dismissKeyboard() {
        ref = Database.database().reference(fromURL: "https://jsqchatfirebase.firebaseio.com").child("test").childByAutoId()
        let postInfo = [ "uid": "輸入者", "Description": uitextEvaluationMessage.text!, "stars": floatStars
            , "timestamp": ServerValue.timestamp() ]
            as [String : Any]
        ref.setValue(postInfo)
        
        
        let childautoID = ref.key
        print("childautoID:\(childautoID)資料已建立" )
        view.endEditing(true)
        //do-to: 程式轉場
        self.performSegue(withIdentifier: "content", sender: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        uitextEvaluationMessage.textColor = UIColor.lightGray
        uitextEvaluationMessage.delegate = self
        self.floatRatingView.delegate = self
        self.floatRatingView.rating = floatStars
        setDoneOnKeyboard()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "content"
        {
            let secondVC = segue.destination as! EvaluationContentViewController
            secondVC.stars = floatStars
            secondVC.mydesc = uitextEvaluationMessage.text!
        }
    }
    
    
    //MARK: UITextViewDelegate實作區
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            textView.textAlignment = .left
        }
    }
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float)
    {
        //        print( NSString(format: "%.2f", self.floatRatingView.rating) as String)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float)
    {
        floatStars = self.floatRatingView.rating
        print( NSString(format: "%.2f", self.floatRatingView.rating) as String)
    }
}

