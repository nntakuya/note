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
    var mvc = ModalViewController()
    var bvc = BaseViewController()
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        slideHeight = (textField.superview?.frame.height)! * CGFloat(textField.tag + 1)
      
    }
    
    func makingCustomCell(){
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
        textField.resignFirstResponder()
        
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
        
        //テーブルの再読込
        UpdateDescriveCategory()
        
        //BaseViewのアンダーバー更新
        bvc.updateScrollBar()
    }
    
    
    func UpdateDescriveCategory(){
        //CoreDataオブジェクト作成
        let categoryDatas = ingCoreData()
        //CoreDataからカテゴリーデータを全件取得
        mvc.categoryInfo = categoryDatas.readCategoryAll() as! [[String : Any]]
        //テーブルの再描画
        mvc.CusCategoryTable.reloadData()
    }
    
}

