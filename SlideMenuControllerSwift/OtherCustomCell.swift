//サイドバーの"other"欄 カスタムセル


import Foundation
import UIKit


class OtherTableViewCell:  UITableViewCell,UITextFieldDelegate {
    //上記のプロトコル(UITableViewCell)でCellのデリゲートをしているので、
    //Cellのプロパティでidが使用できる
    @IBOutlet weak var CategoryCell: UIView!
    @IBOutlet weak var CategoryTextField: UITextField!
    var id:Int!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //テキストフィールドのデリゲート先を自分に設定する。
        CategoryTextField.delegate = self
        CategoryTextField.tag = 0
    }
    
    //デリゲートメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        //キーボードを閉じる。
        CategoryTextField.resignFirstResponder()
        
        updateCategoryName()//カテゴリー名を更新
        
        return true
    }
    
    //入力完了後に呼び出し
    func textFieldDidEndEditing(_ textField:UITextField){
        print("入力完了後に呼び出し")
        updateCategoryName()//カテゴリー名更新
    }
    
    //カテゴリー名更新
    func updateCategoryName(){
        let categoryCore = ingCoreData()
        let inputText = CategoryTextField.text as! String
        categoryCore.UpdateCategoryName(id: id, name: inputText)
    }
}

