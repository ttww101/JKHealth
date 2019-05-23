import UIKit
import WebKit

class OverWebViewController: UIViewController, WKNavigationDelegate {

    var titleView: UIView!
    var titleLabel: UILabel!
    var toolsView: UIView!
    var backBtn: UIButton!
    var forwardBtn: UIButton!
    var refreshBtn: UIButton!
    var shareBtn: UIButton!
    var wkWebView: WKWebView!
    
    let exitName = "离开"
    let backName = "上一页"
    let forwardName = "下一页"
    let refreshName = "刷新"
    let shareName = "分享"
    let titleBarColor:UIColor = appMainColor
    let titleTextColor:UIColor = UIColor.white
    let titleTextSize:CGFloat = 17.0
    let toolsBarColor:UIColor = appMainColor
    let toolsBtnColor:UIColor = UIColor.white
    let toolsBtnTextEnableColor:UIColor = appMainColor
    let toolsBtnTextDisableColor:UIColor = UIColor.lightGray
    let toolsBtnTextSize:CGFloat = 13.0
    var cancelClickCallback:(() -> Void)?
    var accordingArray = [DiscussAccordingObject]()
    var isInnerArray = [Bool]()
    var currentUrlIndex = -1
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.view.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.backgroundColor = appMaskColor
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        mainView.addSubview(leftView)
        leftView.translatesAutoresizingMaskIntoConstraints = false
        leftView.backgroundColor = UIColor.clear
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        mainView.addSubview(rightView)
        rightView.translatesAutoresizingMaskIntoConstraints = false
        rightView.backgroundColor = UIColor.clear
        
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        mainView.addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = UIColor.clear
        
        let bottmView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        mainView.addSubview(bottmView)
        bottmView.translatesAutoresizingMaskIntoConstraints = false
        bottmView.backgroundColor = UIColor.clear
        
        titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        mainView.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.clipsToBounds = true
        titleView.backgroundColor = titleBarColor
        
        toolsView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        mainView.addSubview(toolsView)
        toolsView.translatesAutoresizingMaskIntoConstraints = false
        toolsView.backgroundColor = toolsBarColor
        
        wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        mainView.addSubview(wkWebView)
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.backgroundColor = UIColor.groupTableViewBackground
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        titleView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleTextSize)
        titleLabel.textAlignment = NSTextAlignment.center
        
        backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolsView.addSubview(backBtn)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.backgroundColor = toolsBtnColor
        backBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: toolsBtnTextSize)
        backBtn.setTitle(backName, for: UIControl.State.normal)
        backBtn.setTitleColor(toolsBtnTextEnableColor, for: UIControl.State.normal)
        backBtn.setTitleColor(toolsBtnTextDisableColor, for: UIControl.State.highlighted)
        
        forwardBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolsView.addSubview(forwardBtn)
        forwardBtn.translatesAutoresizingMaskIntoConstraints = false
        forwardBtn.backgroundColor = toolsBtnColor
        forwardBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: toolsBtnTextSize)
        forwardBtn.setTitle(forwardName, for: UIControl.State.normal)
        forwardBtn.setTitleColor(toolsBtnTextEnableColor, for: UIControl.State.normal)
        forwardBtn.setTitleColor(toolsBtnTextDisableColor, for: UIControl.State.highlighted)
        
        refreshBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolsView.addSubview(refreshBtn)
        refreshBtn.translatesAutoresizingMaskIntoConstraints = false
        refreshBtn.backgroundColor = toolsBtnColor
        refreshBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: toolsBtnTextSize)
        refreshBtn.setTitle(refreshName, for: UIControl.State.normal)
        refreshBtn.setTitleColor(toolsBtnTextEnableColor, for: UIControl.State.normal)
        refreshBtn.setTitleColor(toolsBtnTextDisableColor, for: UIControl.State.highlighted)
        
        shareBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolsView.addSubview(shareBtn)
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        shareBtn.backgroundColor = toolsBtnColor
        shareBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: toolsBtnTextSize)
        shareBtn.setTitle(shareName, for: UIControl.State.normal)
        shareBtn.setTitleColor(toolsBtnTextEnableColor, for: UIControl.State.normal)
        shareBtn.setTitleColor(toolsBtnTextDisableColor, for: UIControl.State.highlighted)
        
        let titleLabelHeight = NSLayoutConstraint(item: titleLabel,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: 21.0)
        titleLabelHeight.priority = UILayoutPriority(rawValue: 249)
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: NSLayoutConstraint.Axis.vertical)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 750), for: NSLayoutConstraint.Axis.vertical)
        
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 50), for: NSLayoutConstraint.Axis.horizontal)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 50), for: NSLayoutConstraint.Axis.horizontal)
        
        titleLabel.addConstraint(titleLabelHeight)
        
        
        titleView.addConstraints([NSLayoutConstraint(item: titleLabel,
                                                     attribute: NSLayoutConstraint.Attribute.centerY,
                                                     relatedBy: .equal,
                                                     toItem: titleView,
                                                     attribute: .centerY,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: titleLabel,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: titleView,
                                                     attribute: .trailing,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: titleLabel,
                                                     attribute: .leading,
                                                     relatedBy: .equal,
                                                     toItem: titleView,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: titleLabel,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: titleView,
                                                     attribute: .height,
                                                     multiplier: 0.5,
                                                     constant: 0.0)])
        
        self.view.addConstraints([NSLayoutConstraint(item: mainView,
                                                     attribute: .leading,
                                                     relatedBy: .equal,
                                                     toItem: self.view,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: mainView,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: self.view,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: mainView,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: self.view,
                                                     attribute: .trailing,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: mainView,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: self.view,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: 0.0)])
        
        mainView.addConstraints([NSLayoutConstraint(item: leftView,
                                                     attribute: .leading,
                                                     relatedBy: .equal,
                                                     toItem: mainView,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: leftView,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: mainView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: leftView,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: mainView,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: leftView,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: bottmView,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: leftView,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: leftView,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: wkWebView,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: leftView,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: titleView,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: leftView,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: topView,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: leftView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: titleView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.5, constant: 0),
                                  NSLayoutConstraint(item: rightView,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: mainView,
                                                     attribute: .trailing,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: rightView,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: mainView,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: rightView,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: mainView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: rightView,
                                                     attribute: .leading,
                                                     relatedBy: .equal,
                                                     toItem: bottmView,
                                                     attribute: .trailing,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: rightView,
                                                     attribute: .leading,
                                                     relatedBy: .equal,
                                                     toItem: topView,
                                                     attribute: .trailing,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: rightView,
                                                     attribute: .leading,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .trailing,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: rightView,
                                                     attribute: .leading,
                                                     relatedBy: .equal,
                                                     toItem: titleView,
                                                     attribute: .trailing,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: rightView,
                                                     attribute: .leading,
                                                     relatedBy: .equal,
                                                     toItem: wkWebView,
                                                     attribute: .trailing,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: rightView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: titleView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.5, constant: 0),
                                  NSLayoutConstraint(item: topView,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: mainView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: topView,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: titleView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: topView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: titleView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.5, constant: 0),
                                  NSLayoutConstraint(item: bottmView,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: mainView,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: bottmView,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: bottmView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: titleView, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.5, constant: 0),
                                  NSLayoutConstraint(item: titleView,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: wkWebView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: toolsView,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: wkWebView,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: 0.0)])
        
        
        
        
        
        toolsView.addConstraints([NSLayoutConstraint(item: toolsView,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1.0,
                                                     constant: 44.0),
                                  NSLayoutConstraint(item: backBtn,
                                                     attribute: .leading,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: 5.0),
                                  NSLayoutConstraint(item: backBtn,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: -5.0),
                                  NSLayoutConstraint(item: backBtn,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 5.0),
                                  NSLayoutConstraint(item: backBtn,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: forwardBtn,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: -5.0),
                                  NSLayoutConstraint(item: backBtn,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: forwardBtn,
                                                     attribute: .width,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: backBtn,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: refreshBtn,
                                                     attribute: .width,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: backBtn,
                                                     attribute: .width,
                                                     relatedBy: .equal,
                                                     toItem: shareBtn,
                                                     attribute: .width,
                                                     multiplier: 1.0,
                                                     constant: 0.0),
                                  NSLayoutConstraint(item: forwardBtn,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: -5.0),
                                  NSLayoutConstraint(item: forwardBtn,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 5.0),
                                  NSLayoutConstraint(item: forwardBtn,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: refreshBtn,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: -5.0),
                                  NSLayoutConstraint(item: refreshBtn,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: -5.0),
                                  NSLayoutConstraint(item: refreshBtn,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 5.0),
                                  NSLayoutConstraint(item: refreshBtn,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: shareBtn,
                                                     attribute: .leading,
                                                     multiplier: 1.0,
                                                     constant: -5.0),
                                  NSLayoutConstraint(item: shareBtn,
                                                     attribute: .bottom,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .bottom,
                                                     multiplier: 1.0,
                                                     constant: -5.0),
                                  NSLayoutConstraint(item: shareBtn,
                                                     attribute: .top,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .top,
                                                     multiplier: 1.0,
                                                     constant: 5.0),
                                  NSLayoutConstraint(item: shareBtn,
                                                     attribute: .trailing,
                                                     relatedBy: .equal,
                                                     toItem: toolsView,
                                                     attribute: .trailing,
                                                     multiplier: 1.0,
                                                     constant: -5.0)])
        
        self.view.layoutIfNeeded()
        
        titleView.backgroundColor = titleBarColor
        titleLabel.textColor = titleTextColor
        toolsView.backgroundColor = toolsBarColor
        backBtn.backgroundColor = toolsBtnColor
        backBtn.setTitleColor(toolsBtnTextEnableColor, for: UIControl.State.normal)
        forwardBtn.backgroundColor = toolsBtnColor
        forwardBtn.setTitleColor(toolsBtnTextEnableColor, for: UIControl.State.normal)
        refreshBtn.backgroundColor = toolsBtnColor
        refreshBtn.setTitleColor(toolsBtnTextEnableColor, for: UIControl.State.normal)
        shareBtn.backgroundColor = toolsBtnColor
        shareBtn.setTitleColor(toolsBtnTextEnableColor, for: UIControl.State.normal)
        
        titleLabel.text = " "
        accordingArray = [DiscussAccordingObject]()
        isInnerArray = [Bool]()
        currentUrlIndex = -1
        wkWebView.navigationDelegate = self
        
        forwardBtn.addTarget(self, action: #selector(click1), for: UIControl.Event.touchUpInside)
        
        backBtn.addTarget(self, action: #selector(click2), for: UIControl.Event.touchUpInside)
        
        refreshBtn.addTarget(self, action: #selector(click3), for: UIControl.Event.touchUpInside)
        
        shareBtn.addTarget(self, action: #selector(click4), for: UIControl.Event.touchUpInside)
        
        resetBtnColor(abbs: nil)
        
    }
    
    @objc func click1(sender:UIButton) {
        self.forwardBtnClick(abbs: nil)
    }
    
    @objc func click2(sender:UIButton) {
        self.backBtnClick(abbs: nil)
    }
    
    @objc func click3(sender:UIButton) {
        self.refreshBtnClick(abbs: nil)
    }
    
    @objc func click4(sender:UIButton) {
       self.shareBtnClick(abbs: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        if let gotoUrl = webView.url {
            
            print(gotoUrl)
            if (!isSameUrl(abbs: nil, urlx: gotoUrl.absoluteString, urly: accordingArray[currentUrlIndex].accordingUrl)) {
                for i in (currentUrlIndex+1)..<accordingArray.count {
                    accordingArray.remove(at: (accordingArray.count + currentUrlIndex - i))
                    isInnerArray.remove(at: (accordingArray.count + currentUrlIndex - i))
                }
                let accObj = DiscussAccordingObject()
                accObj.accordingTitle = accordingArray[currentUrlIndex].accordingTitle
                accObj.accordingUrl = gotoUrl.absoluteString
                accordingArray.append(accObj)
                isInnerArray.append(false)
                currentUrlIndex = currentUrlIndex + 1
            }
            
        }
        
        self.resetBtnColor(abbs: nil)
        
    }
    
    func resetBtnColor(abbs:Float?) {
        if (currentUrlIndex > 0) {
            backBtn.setTitle(backName, for: UIControl.State.normal)
        } else {
            backBtn.setTitle(exitName, for: UIControl.State.normal)
        }
        if (currentUrlIndex >= 0) {
            refreshBtn.setTitleColor(toolsBtnTextEnableColor, for: UIControl.State.normal)
        } else {
            refreshBtn.setTitleColor(toolsBtnTextDisableColor, for: UIControl.State.normal)
        }
        if (accordingArray.count > (currentUrlIndex + 1)) {
            forwardBtn.setTitleColor(toolsBtnTextEnableColor, for: UIControl.State.normal)
        } else {
            forwardBtn.setTitleColor(toolsBtnTextDisableColor, for: UIControl.State.normal)
        }
    }
    
   @objc func loadTitleUrl(abbs:NSArray?, accordingObj:DiscussAccordingObject) {
        accordingArray.append(accordingObj)
        isInnerArray.append(true)
        currentUrlIndex = currentUrlIndex + 1
        if let gotoUrl:URL = URL(string: accordingArray[currentUrlIndex].accordingUrl) {
            let request:URLRequest = URLRequest(url: gotoUrl)
            self.titleLabel.text = accordingArray[currentUrlIndex].accordingTitle
            self.wkWebView.load(request)
        }
    }
    
    func setCancelCallback(cancelCallback: (() -> Void)?) {
        self.cancelClickCallback = cancelCallback
    }
    
    func backBtnClick(abbs:NSData?) {
        if (currentUrlIndex > 0) {
            if let gotoUrl:URL = URL(string: accordingArray[currentUrlIndex - 1].accordingUrl) {
                let request:URLRequest = URLRequest(url: gotoUrl)
                currentUrlIndex = currentUrlIndex - 1
                self.titleLabel.text = accordingArray[currentUrlIndex].accordingTitle
                self.wkWebView.load(request)
            }
        } else {
            self.dismiss(animated: true) {
                if (self.cancelClickCallback != nil) {
                    self.cancelClickCallback!()
                }
            }
        }
    }
    
    func forwardBtnClick(abbs:NSNumber?) {
        if (accordingArray.count > (currentUrlIndex+1)) {
            if let gotoUrl:URL = URL(string: accordingArray[currentUrlIndex + 1].accordingUrl) {
                let request:URLRequest = URLRequest(url: gotoUrl)
                currentUrlIndex = currentUrlIndex + 1
                self.titleLabel.text = accordingArray[currentUrlIndex].accordingTitle
                self.wkWebView.load(request)
            }
        }
    }
    
    func refreshBtnClick(abbs:NSNumber?) {
        if (currentUrlIndex >= 0) {
            self.titleLabel.text = accordingArray[currentUrlIndex].accordingTitle
            self.wkWebView.reload()
        }
    }
    
    func shareBtnClick(abbs:Float?) {
        
        if (currentUrlIndex >= 0) {
            var shareAll = [Any]()
            if (accordingArray[currentUrlIndex].accordingTitle.count > 0) {
                shareAll.append(accordingArray[currentUrlIndex].accordingTitle)
            }
            if let gotoUrl:URL = URL(string: accordingArray[currentUrlIndex].accordingUrl) {
                shareAll.append(gotoUrl.absoluteString)
                
                let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    func isSameUrl(abbs:Float?, urlx:String, urly:String) -> Bool {
        
        var purex = ""
        var purey = ""
        
        if let lastChar = urlx.last {
            if (lastChar == "/") {
                purex = String(urlx.prefix(urlx.count - 1))
            } else {
                purex = urlx
            }
        }
        if let lastChar = urly.last {
            if (lastChar == "/") {
                purey = String(urly.prefix(urly.count - 1))
            } else {
                purey = urly
            }
        }
        if (String(urlx.prefix(4)).lowercased() == "http") {
            if let firstCharIndex = urlx.firstIndex(of: ":") {
                purex = String(purex.suffix(purex.count - firstCharIndex.encodedOffset - 3))
            }
        }
        if (String(urly.prefix(4)).lowercased() == "http") {
            if let firstCharIndex = urly.firstIndex(of: ":") {
                purey = String(purey.suffix(purey.count - firstCharIndex.encodedOffset - 3))
            }
        }
        if (purex == purey) {
            return true
        } else {
            return false
        }
        
    }
    
}
