//
//  LoginViewController.swift
//  Meet
//
//  Created by Zhang on 9/9/16.
//  Copyright © 2016 Meet. All rights reserved.
//

import UIKit

typealias ApplyCodeClouse = () -> Void
typealias ProtocolClouse = () -> Void
typealias NewUserLoginClouse = () -> Void
typealias ReloadMeViewClouse = () ->Void
typealias LoginWithDetailClouse = () ->Void
typealias LoginWithOrderListClouse = () ->Void
typealias OrderListShorOrderButton = () ->Void

class LoginViewController: UIViewController {

    var mobileField:UITextField!
    var smsCodeField:UITextField!
    
    var loginButton:UIButton!
    
    var timeDownLabel:TimeDownView!

    var keyboardHeight:CGFloat!
    
    var originFrame:CGRect!
    
    var reloadMeViewClouse:ReloadMeViewClouse!
    var applyCodeClouse:ApplyCodeClouse!
    var protocolClouse:ProtocolClouse!
    var newUserLoginClouse:NewUserLoginClouse!
    var loginWithDetailClouse:LoginWithDetailClouse!
    var loginWithOrderListClouse:LoginWithOrderListClouse!
    var orderListShorOrderButton:OrderListShorOrderButton!
    
    let viewModel = LoginViewModel()
    
    var loginLabel:UILabel!
    
    var phoneStr : String? = ""
    
    var smsCodeStr : String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setUpNavigationBar()
        self.setUpView()
        self.setupForDismissKeyboard()
        self.changeLoginButtonColor()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    func setUpView() {
        loginLabel = UILabel()
        loginLabel.text = "立即登录"
        loginLabel.font = LoginViewLabelFont
        loginLabel.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        self.view.addSubview(loginLabel)
        
        let mobileLabel = self.setUpLabel("移动电话")
        self.view.addSubview(mobileLabel)
        
        let smsCode = self.setUpLabel("短信验证码")
        self.view.addSubview(smsCode)
        
        mobileField = self.setUpTextField()
        mobileField.becomeFirstResponder()
        mobileField.tag = 1
        mobileField.returnKeyType = .Next
        mobileField.keyboardType = .PhonePad
        self.view.addSubview(mobileField)
        
        smsCodeField = self.setUpTextField()
        smsCodeField.tag = 2
        smsCodeField.returnKeyType = .Done
        smsCodeField.keyboardType = .NumberPad
        self.view.addSubview(smsCodeField)
        
        let lineLabel1 = self.setUpLineLabel()
        self.view.addSubview(lineLabel1)
        
        let lineLabel2 = self.setUpLineLabel()
        self.view.addSubview(lineLabel2)
        
        loginButton = self.setUpLoginButton()
        loginButton.frame = CGRectMake(36, 374, 70, 46)
        self.view.addSubview(loginButton)
        
        timeDownLabel = TimeDownView()
        timeDownLabel.layer.cornerRadius = 15.0
        timeDownLabel.backgroundColor = UIColor.clearColor()
        timeDownLabel.smsCodeClouse = { _ in
            self.smsButtonClick()
        }
        self.view.addSubview(timeDownLabel)
        
        loginLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.view.snp_top).offset(21)
            make.left.equalTo(self.view.snp_top).offset(40)
            make.size.equalTo(CGSizeMake(ScreenWidth - 80, 42))
        }
        
        mobileLabel.snp_makeConstraints { (make) in
            make.top.equalTo(loginLabel.snp_bottom).offset(38)
            make.left.equalTo(self.view.snp_top).offset(40)
            make.size.equalTo(CGSizeMake(44, 16))
        }
        
        mobileField.snp_makeConstraints { (make) in
            make.top.equalTo(mobileLabel.snp_bottom).offset(8)
            make.left.equalTo(self.view.snp_left).offset(39)
            make.right.equalTo(self.view.snp_right).offset(-120)
            make.height.equalTo(29)
        }
        
        timeDownLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.view.snp_right).offset(-40)
            make.bottom.equalTo(lineLabel1.snp_bottom).offset(-15)
            make.size.equalTo(CGSizeMake(70, 30))
        }
        
        lineLabel1.snp_makeConstraints { (make) in
            make.top.equalTo(mobileField.snp_bottom).offset(15)
            make.right.equalTo(self.view.snp_right).offset(-40)
            make.left.equalTo(self.view.snp_left).offset(40)
            make.height.equalTo(1)
        }
        
        smsCode.snp_makeConstraints { (make) in
            make.top.equalTo(lineLabel1.snp_bottom).offset(19)
            make.left.equalTo(self.view.snp_left).offset(40)
            make.size.equalTo(CGSizeMake(55, 16))
        }
        
        smsCodeField.snp_makeConstraints { (make) in
            make.top.equalTo(smsCode.snp_bottom).offset(8)
            make.left.equalTo(self.view.snp_left).offset(39)
            make.right.equalTo(self.view.snp_right).offset(-40)
            make.height.equalTo(29)
        }
        
        lineLabel2.snp_makeConstraints { (make) in
            make.top.equalTo(smsCodeField.snp_bottom).offset(15)
            make.right.equalTo(self.view.snp_right).offset(-40)
            make.left.equalTo(self.view.snp_left).offset(40)
            make.height.equalTo(1)
        }

    }
    
    func keyboardWillAppear(notification: NSNotification) {
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        keyboardHeight = (keyboardinfo?.CGRectValue.size.height)!
        originFrame = self.loginButton.frame
        let frame = self.loginButton.frame
        UIView.animateWithDuration(0.25, animations: { 
            self.loginButton.frame = CGRectMake(36, ScreenHeight - self.keyboardHeight - 130, frame.size.width, frame.size.height)
            }) { (finish) in
                
        }
        
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        UIView.animateWithDuration(0.25, animations: {
            self.loginButton.frame = CGRectMake(36, self.originFrame.origin.y, 70, 46)
        }) { (finish) in
            
        }
    }
    
    func setUpTextField() -> UITextField {
        let textField = UITextField()
        textField.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        textField.tintColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
        textField.delegate = self
        return textField
    }
    
    func setUpLabel(str:String) -> UILabel {
        let label = UILabel()
        label.text = str
        label.font = LoginInfoLabelFont
        label.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        return label
    }
    
    func setUpLineLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor.init(hexString: HomeDetailViewNameColor)
        return label
    }
    
    func loginButtonClick() {
        if  phoneStr!.length != 11 {
            MainThreadAlertShow("手机号码输入有误", view: self.view)
            return
        }else if smsCodeStr!.length != 4 {
            MainThreadAlertShow("验证码输入", view: self.view)
            return
        }
        
        loginLabel.text = "正在登录，请稍候..."
        
        viewModel.loginSms(phoneStr, code: smsCodeStr, applyCode:"", success: { (dic) in
            UserInfo.synchronizeWithDic(dic)
            UserInfo.sharedInstance().uid = (dic as NSDictionary).objectForKey("uid")?.stringValue
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isNewUser")
            UserInfo.sharedInstance().mobile_num = self.mobileField.text
            if self.newUserLoginClouse != nil{
                self.newUserLoginClouse()
            }
        }) { (dic) in
            if ((dic as NSDictionary).objectForKey("error") as! String) == "oldUser" {
                self.viewModel.getUserInfo(self.phoneStr, success: { (dic) in
                    UserInfo.synchronizeWithDic(dic)
                    UserInfo.sharedInstance().isFirstLogin = true
                    if self.reloadMeViewClouse != nil{
                        self.reloadMeViewClouse()
                        self.dismissViewControllerAnimated(true, completion: { 
                            
                        })
                    }
                    
                    if self.loginWithDetailClouse != nil {
                        self.loginWithDetailClouse()
                        self.dismissViewControllerAnimated(true, completion: {
                            
                        })
                    }
                    
                    if self.loginWithOrderListClouse != nil {
                        self.loginWithOrderListClouse()
                        self.dismissViewControllerAnimated(true, completion: {
                            
                        })
                    }
                    self.dismissViewControllerAnimated(true, completion: {
                        
                    })
                    }, fail: { (dic) in
                        self.loginLabel.text = "重试"
                    }, loadingString: { (msg) in
                        
                })
            }else if ((dic as NSDictionary).objectForKey("error") as! String) == "noneuser"{
                MainThreadAlertShow("该手机号用户不存在", view: self.view)
                self.loginLabel.text = "重试"
            }else{
                 MainThreadAlertShow("验证码输入有误或已过期", view: self.view)
                self.smsCodeField.textColor = UIColor.init(hexString: MeProfileCollectViewItemSelect)
                self.loginLabel.text = "重试"
            }
        }
    }

    func changeLoginButtonColor() {
        smsCodeField.textColor = UIColor.init(hexString: HomeDetailViewNameColor)
        if phoneStr!.length == 11 && smsCodeStr!.length == 4 {
            loginButton.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: HomeDetailViewNameColor), size: CGSizeMake(70, 46)), forState: .Normal)
        }else{
            loginButton.setBackgroundImage(UIImage.init(color: UIColor.init(hexString: PlaceholderImageColor), size: CGSizeMake(70, 46)), forState: .Normal)
        }
    }
    
    func setUpLoginButton() -> UIButton{
        let loginButton = UIButton(type: .Custom)
        loginButton.clipsToBounds = true
        loginButton.setImage(UIImage.init(named: "login_next"), forState: .Normal)
        loginButton.layer.cornerRadius = 24
        loginButton.addTarget(self, action: #selector(LoginViewController.loginButtonClick), forControlEvents: .TouchUpInside)
        return loginButton
    }
    
    func smsButtonClick() {
        if String.isValidateMobile(phoneStr) || phoneStr!.length == 11 {
            viewModel.senderSms(mobileField.text, success: { (dic) in
                self.smsCodeField.becomeFirstResponder()
                }, fail: { (dic) in
                    MainThreadAlertShow((dic as NSDictionary).objectForKey("error") as! String, view: self.view)
            })
        }else{
            MainThreadAlertShow("手机号错误", view: self.view)
        }
    }
    
    func setUpNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "me_dismissBlack")?.imageWithRenderingMode(.AlwaysOriginal), style: .Plain, target: self, action: #selector(LoginViewController.disMissView))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(color: UIColor.whiteColor(), size: CGSizeMake(ScreenWidth, 64)), forBarMetrics: .Default)
        self.navigationItemWhiteColorAndNotLine()
    }
    
    func disMissView() {
        self.dismissViewControllerAnimated(true) { 
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoginViewController : UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string != "" {
            if textField.tag == 1 {
                phoneStr = (textField.text?.stringByAppendingString(string))!
            }else if textField.tag == 2 {
                smsCodeStr = (textField.text?.stringByAppendingString(string))!
            }
        }else{
            if textField.tag == 1 {
                if textField.text?.length == 0 || (range.location == 0 && string == ""){
                    phoneStr = textField.text!
                }else{
                    phoneStr = ""
                }
            }else if textField.tag == 2 {
                if textField.text?.length == 0 || (range.location == 0 && string == "") {
                    smsCodeStr = textField.text!
                }else{
                    smsCodeStr = ""
                }
            }
        }

        self.changeLoginButtonColor()
        return true
    }
}
