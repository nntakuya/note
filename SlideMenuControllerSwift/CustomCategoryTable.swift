//  CustomCategoryTable.swift
//  SlideMenuControllerSwift
//  Created by 仲松拓哉 on 14/02/2018.


import Foundation
import UIKit

var slideHeight:CGFloat = 0.0  //okayu


class CustomTableViewCell:  UITableViewCell,UITextFieldDelegate {
    //上記のプロトコル(UITableViewCell)でCellのデリゲートをしているので、
    //Cellのプロパティでidが使用できる
    var CategoryCell: UIView!
    var CategoryTextField = UITextField()
    var id:Int!
    

    func textinit(){
        self.CategoryTextField.frame = self.frame
    }
    // required initializer
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        CategoryCell = CustomTableViewCell()
        
//        CategoryTextField = UITextField()
        CategoryTextField.text = ""
        
        //テキストフィールドのデリゲート先を自分に設定する。
        CategoryTextField.delegate = self
        CategoryTextField.tag = 0
//        CategoryTextField.isUserInteractionEnabled = true
        
        self.addSubview(CategoryTextField)
        //ジェスチャーの登録
//        CategoryTextField.isUserInteractionEnabled = true
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomTableViewCell.textFieldTap))
//        tapGesture.cancelsTouchesInView = false
//        CategoryCell.addGestureRecognizer(tapGesture)
        
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //TODO:おかゆさん
        slideHeight = (textField.superview?.frame.height)! * CGFloat(textField.tag + 1)
      
    }
    
    func test(){
        CategoryCell = self
        
//        CategoryTextField.text = ""
        
        //テキストフィールドのデリゲート先を自分に設定する。
        CategoryTextField.delegate = self
        CategoryTextField.tag = 0
        CategoryTextField.frame = CGRect(x: 0, y: 0, width: 30, height: 10)
        
        
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



//extension BaseViewController: UITableViewDelegate,UITableViewDataSource {
//
//
//    @objc func iconTappedAction(sender:AnyObject?) {
//        guard let gestures = sender?.gestureRecognizers! else { return }
//        for gesture in gestures {
//            if let gesture = gesture as? UITapGestureRecognizer {
//                //ここでtextfieldのlocation情報が取得出来れば理想
//                let tappedLocation = gesture.location(in: CusCategoryTable)
//                let tappedIndexPath = CusCategoryTable.indexPathForRow(at: tappedLocation)
//                let tappedRow = tappedIndexPath?.row
//
//                if tappedRow != nil {
//                    print(tappedRow as! Int)
//                }
//            }
//        }
//
//    }
//
//
//
//
////    @objc func keyboardWillShow(_ notification: Notification) {
////
////        let info = notification.userInfo!
////
////        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
////
////        // bottom of textField
////        let bottomTextField = textField.frame.origin.y + textField.frame.height
////        // top of keyboard
////        let topKeyboard = screenHeight - keyboardFrame.size.height
////        // 重なり
////        let distance = bottomTextField - topKeyboard
////
////        if distance >= 0 {
////            // scrollViewのコンテツを上へオフセット + 20.0(追加のオフセット)
////            scrollView.contentOffset.y = distance + 20.0
////        }
////    }
////
////    @objc func keyboardWillHide(_ notification: Notification) {
////        scrollView.contentOffset.y = 0
////    }
////
//
//
//
//
//
//    //テーブルレイアウト調整
//    func AjustTableLayout(){
//        cuWidth = self.view.bounds.width
//        cuHeight = self.view.bounds.height - 150
//        CusCategoryTable.frame = CGRect(x: 0, y: 0, width: cuWidth, height: cuHeight)
//        CusCategoryTable.keyboardDismissMode =  .onDrag //テーブルの操作性を良くする
//    }
//
//
//
//
//
////    func textFieldShouldClear(_ textField: UITextField) -> Bool {
////        textField.resignFirstResponder()
////        return true
////    }
////    func keyboardWillBeShown(notification: NSNotification) {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
////
////
////        if let userInfo = notification.userInfo {
////            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue, let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
////                restoreScrollViewSize()
////
////                let convertedKeyboardFrame = CusCategoryTable.convert(keyboardFrame, from: nil)
////                let offsetY: CGFloat = CGRectGetMaxY(cell.frame) - CGRectGetMinY(convertedKeyboardFrame)
////                if offsetY < 0 { return }
////                updateScrollViewSize(moveSize: offsetY, duration: animationDuration)
////            }
////        }
////    }
////
////    func keyboardWillBeHidden(notification: NSNotification) {
////        restoreScrollViewSize()
////    }
////
////    func updateScrollViewSize(moveSize: CGFloat, duration: TimeInterval) {
////        UIView.beginAnimations("ResizeForKeyboard", context: nil)
////        UIView.setAnimationDuration(duration)
////
////        let contentInsets = UIEdgeInsetsMake(0, 0, moveSize, 0)
////        CusCategoryTable.contentInset = contentInsets
////        CusCategoryTable.scrollIndicatorInsets = contentInsets
////        CusCategoryTable.contentOffset = CGPoint(0, moveSize)
////
////        UIView.commitAnimations()
////    }
////
////    func restoreScrollViewSize() {
////        CusCategoryTable.contentInset = UIEdgeInsetsZero
////        CusCategoryTable.scrollIndicatorInsets = UIEdgeInsetsZero
////    }
////
////
////
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt: \(indexPath)")
//
//        // タップ後すぐ非選択状態にするには下記メソッドを呼び出します．
//        // sampleTableView.deselectRow(at: indexPath, animated: true)
//    }
//
//
//
//
//
//
//
//
//
//
//
//    //テーブルの数をカウント
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categoryInfo.count
//    }
//
//    //セルに文字列を表示
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //セル並び替えの際に使用
//        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
//            return spacer
//        }
//
//        //文字列を表示するセルの取得
//        //以下 "CustomTableViewCell" はテスト用にセット
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
//
//        cell.selectionStyle = .none//選択時ハイライト無効
//
////        cell.CategoryTextField.text = ""
//
//        //category内容編集するためにidプロパティを更新
//        cell.id = categoryInfo[indexPath.row]["id"] as? Int
//
//        //表示したい文字の設定
//        cell.CategoryTextField?.text = categoryInfo[indexPath.row]["name"] as? String
//
//        cell.CategoryTextField.tag = indexPath.row  //okayu
//
//        return cell
//    }
//
//    //カテゴリー一覧呼び込み関数
//    func addListCategory(){
//        //CoreDataオブジェクト作成
//        let categoryDatas = ingCoreData()
//        //CoreDataからカテゴリーデータを全件取得
//        categoryInfo = categoryDatas.readCategoryAll() as! [[String : Any]]
//
//        //テーブルの再描画
//        CusCategoryTable.reloadData()
//    }
//
//
//    //セルのスワイプ表示（デザイン）
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
//
//            //指定されたIDのメモデータをCoreDataから削除
//            self.selectedRowIndex = indexPath.row
//            let id = self.categoryInfo[self.selectedRowIndex]["id"] as! Int
//            //選択されたカテゴリーを削除
//            let CoreDataCategory = ingCoreData()
//            CoreDataCategory.deleteCategory(id: id)
//
//            //選択されたカテゴリーに依存する記事を全件削除
//            let CoreDataArticle = ArticleCoreData()
//            CoreDataArticle.deleteArticle(category_id: id)
//
//            //ビューから指定されたセルを削除
//            self.categoryInfo.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//        deleteButton.backgroundColor = UIColor.red
//
//        return [deleteButton]
//    }
//}
//
//
//
////セルの並び替え処理
////方針: 配列の要素のデータを個別にアップデートする設計にする
//extension BaseViewController: TableViewReorderDelegate {
//    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        //1. 全体の列のデータを取得(viewdidload)で可
//        let category = categoryInfo[sourceIndexPath.row]
//
//        //2. 選択されたセルの要素から、全体データの配列からセルを特定。その削除。
//        categoryInfo.remove(at: sourceIndexPath.row)
//
//        //3.削除したカテゴリーオブジェクトを最終移動セルの場所に追加。
//        categoryInfo.insert(category, at: destinationIndexPath.row)
//
//        //カテゴリーの配列を個別でアップデート処理
//        var i = 0
//         for category in categoryInfo{
//            let id =  category["id"]
//            var sort_id = category["sort_id"]
//
//            //sort_idを更新
//            sort_id = i
//
//            //CoreDataのカテゴリー個別アップデートを行う
//            let coreDataUpdate = ingCoreData()
//            coreDataUpdate.sortChange(id: id as! Int, sort_id: sort_id as! Int)
//            i += 1
//        }
//        //5.テーブルの再読込
//        CusCategoryTable.reloadData()
//    }
//}

