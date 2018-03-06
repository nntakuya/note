//
//  BaseTableViewCell.swift
//  SlideMenuControllerSwift

//ここでサイドバーの設定をしている
import UIKit

open class BaseTableViewCell : UITableViewCell {
    class var identifier: String { return String.className(self) }
    //カテゴリーIDを作成
    var category_id:Int = -1
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
    }
    
    open class func height() -> CGFloat {
        return 55
    }
    
    open func setData(_ data: Any?) {
//        self.backgroundColor = UIColor(hex: "F1F8E9")
//        self.textLabel?.font = UIFont.italicSystemFont(ofSize: 18)
        self.textLabel?.font = UIFont(name:"Helvetica", size:18)
        
//        self.textLabel?.textColor = UIColor(hex: "9E9E9E")
        if let menuText = data as? String {
            self.textLabel?.text = menuText
        }
//        makingSeparator()
        
    }
    
    func makingSeparator(){
        let border = UIView()
        border.frame = CGRect(x: 3, y: 55, width: self.frame.size.width - 3, height: 1)
        self.addSubview(border)
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
    
    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {
    }
  
}
