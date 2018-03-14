//サイドバーの"other"欄 カスタムセル


import Foundation
import UIKit


class OtherTableViewCell:  UITableViewCell{

    var id:Int!


    override func awakeFromNib() {
        super.awakeFromNib()
        //テキストフィールドのデリゲート先を自分に設定する。
//        CategoryTextField.delegate = self
//        CategoryTextField.tag = 0
    }

    open class func height() -> CGFloat {
        return 55
    }
    
    //TODO:以下のコードが実行されていない
    open func setData(_ data: Any?) {
        self.textLabel?.font = UIFont(name:"Helvetica", size:18)
        
        
    }

}


