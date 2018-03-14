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
    
    var SortIcon = UIView()
    var borderOne = UIView()
    var borderTwo = UIView()
    var borderThree = UIView()
    
    //test
    var countLabel = 0
    var firstWidth = Int()
    
    
    func makingSortIcon(){
        //ラベルをつける
        //最初のセルの幅のみを取得
        //2回目以降のセルの読込があった場合は、1回目のデータを読み込む
        
        if countLabel == 0 {
            firstWidth = Int(self.bounds.size.width)
            countLabel += 1
        }
        
        SortIcon.frame = CGRect(x: firstWidth, y: 0, width: 40, height: 40)
        borderOne.frame = CGRect(x: 0, y: 15, width: SortIcon.frame.size.width, height: 1)
        borderOne.backgroundColor = UIColor.black
        borderTwo.frame = CGRect(x: 0, y: 20, width: SortIcon.frame.size.width, height: 1)
        borderTwo.backgroundColor = UIColor.black
        borderThree.frame = CGRect(x: 0, y: 25, width: SortIcon.frame.size.width, height: 1)
        borderThree.backgroundColor = UIColor.black
        
        SortIcon.addSubview(borderOne)
        SortIcon.addSubview(borderTwo)
        SortIcon.addSubview(borderThree)
        self.addSubview(SortIcon)
        
    }
    
    open class func height() -> CGFloat {
        return 45
    }
    
    open func setData(_ data: Any?) {
        let attribute : NSAttributedString = NSAttributedString(
            string:"",
            attributes:  [NSAttributedStringKey.font: UIFont(name: "Helvetica-W6", size: 20)!]
        )
        CategoryTextField.attributedText = attribute
        
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        slideHeight = (textField.superview?.frame.height)! * CGFloat(textField.tag + 1)
      
    }
    
    func makingCustomCell(){
        CategoryCell = self
    
//        let cellWidth = Int(self.bounds.size.width - 90)
        let cellWidth = Int(self.bounds.size.width * 0.7)
        let cellHeight = 30
        let cellX = 20
        let cellY = (Int(self.bounds.size.height) - cellHeight) / 2
        
        let attribute : NSAttributedString = NSAttributedString(
            string:"",
            attributes:  [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 20)!]
        )
        CategoryTextField.attributedText = attribute
        
//        makingSortIcon()
        
        
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

