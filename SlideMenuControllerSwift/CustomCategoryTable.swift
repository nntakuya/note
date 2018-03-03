//  CustomCategoryTable.swift
//  SlideMenuControllerSwift
//  Created by 仲松拓哉 on 14/02/2018.


import Foundation
import UIKit

var slideHeight:CGFloat = 0.0  


class CustomTableViewCell:  UITableViewCell,UITextFieldDelegate {
    //上記のプロトコル(UITableViewCell)でCellのデリゲートをしているので、
    //Cellのプロパティでidが使用できる
    var CategoryCell: UIView!
    var CategoryTextField = UITextField()
    var id:Int!
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //TODO:おかゆさん
        slideHeight = (textField.superview?.frame.height)! * CGFloat(textField.tag + 1)
      
    }
    
    func test(){
        CategoryCell = self
    
        let cellWidth = Int(self.bounds.size.width - 70)
        let cellHeight = 30
        let cellX = 5
        let cellY = (Int(self.bounds.size.height) - cellHeight) / 2
        
        
        //テキストフィールドのデリゲート先を自分に設定する。
        CategoryTextField.delegate = self
        CategoryTextField.tag = 0
        CategoryTextField.frame = CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight)
        
        self.addSubview(CategoryTextField)
        
    }
    
    
    
    //デリゲートメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
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

