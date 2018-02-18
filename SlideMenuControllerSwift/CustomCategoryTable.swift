//
//  CustomCategoryTable.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 14/02/2018.
//
//


//目的：カテゴリー内容の編集
//【出来てること】
//1.テーブルのセルの上に、textFieldをセット
//2.そのtextFieldに、データを反映

//【出来ていないこと】
//1.レイアウトが一気に崩れた
//2.指定したセルの特定方法が不明

//【プログラムの設計】
//1.選択されたセルを特定する必要がある
// └ textFieldからデータを取得する方法
// └ セルからデータを取得する
//2.特定したセルをキーに選択されたカテゴリーを特定(categoryInfo配列を使用予定)
//3.categoryInfoの情報を上書き
//4.CoreDataに情報を反映


import Foundation
import UIKit


class CustomTableViewCell:  UITableViewCell,UITextFieldDelegate {

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
    
    
//    //入力開始前に呼び出し
//    func textFieldShouldBeginEditing(_ textField:UITextField) -> Bool {
//        print("入力開始前に呼び出し")
//        return true
//    }
    //入力完了後に呼び出し
    func textFieldDidEndEditing(_ textField:UITextField){
        print("入力完了後に呼び出し")
        updateCategoryName()//カテゴリー名更新
    }
    
    func updateCategoryName(){
        let categoryCore = ingCoreData()
        let inputText = CategoryTextField.text as! String
        categoryCore.UpdateCategoryName(id: id, name: inputText)
    }
}

extension BaseViewController: UITableViewDelegate,UITableViewDataSource {

//    ==========================
//　　　　  　テーブル作成
//    ==========================
    //テーブルの数をカウント
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryInfo.count
    }
    
    //セルに文字列を表示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セル並び替えの際に使用
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        //文字列を表示するセルの取得
        //以下 "CustomTableViewCell" はテスト用にセット
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        //TODO:以下のコードの内容を確認する
        //問題：セル内のtextFieldが選択された状態で、セルが選択されたと認識されないこと
//        cell.CategoryTextField.delegate = self as? UITextFieldDelegate
//        cell.CategoryTextField.tag = indexPath.row
        

        //category内容編集するためにidプロパティを更新
        cell.id = categoryInfo[indexPath.row]["id"] as? Int
        
        //表示したい文字の設定
        cell.CategoryTextField?.text = categoryInfo[indexPath.row]["name"] as? String
        
        return cell
    }
    
    
    //行を編集するための関数（メモがからの時は削除ボタンを出なくする）
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        print(indexPath.row)
        return false
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

    
    //カテゴリー一覧呼び込み関数
    func addListCategory(){
        //CoreDataオブジェクト作成
        let categoryDatas = ingCoreData()
        //CoreDataからカテゴリーデータを全件取得
        categoryInfo = categoryDatas.readCategoryAll() as! [[String : Any]]
        
        //テーブルの再描画
        //tableView.reloadData()
    }

    
    //セルのスワイプ表示（デザイン）
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
            //指定されたIDのメモデータをCoreDataから削除
            self.selectedRowIndex = indexPath.row
//            self.Delete()
            //TODO:確認事項　下記コードはindexPath.rowで要素を指定した方が良いのか？
            let id = self.categoryInfo[self.selectedRowIndex]["id"] as! Int
            let CoreData = ingCoreData()
            CoreData.deleteCategory(id: id)
            
            //ビューから指定されたセルを削除
            self.categoryInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
}

//セルの並び替え処理
//方針: 配列の要素のデータを個別にアップデートする設計にする
extension BaseViewController: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update data model
        
        //必要な作業
        //全体の配列、配列の削除処理(remove)、配列の追加処理(insert)
        
        //1. 全体の列のデータを取得(viewdidload)で可
        let category = categoryInfo[sourceIndexPath.row]
        
        //2. 選択されたセルの要素から、全体データの配列からセルを特定。その削除。
        categoryInfo.remove(at: sourceIndexPath.row)
        
        //3.削除したカテゴリーオブジェクトを最終移動セルの場所に追加。
        categoryInfo.insert(category, at: destinationIndexPath.row)
        
        //カテゴリーの配列を個別でアップデート処理
        var i = 0
         for category in categoryInfo{
            let id =  category["id"]
            var sort_id = category["sort_id"]
            
            //sort_idを更新
            sort_id = i
            
            //CoreDataのカテゴリー個別アップデートを行う
            let coreDataUpdate = ingCoreData()
            coreDataUpdate.sortChange(id: id as! Int, sort_id: sort_id as! Int)
            
            i += 1
        }
        //5.テーブルの再読込
        CusCategoryTable.reloadData()
    }
}
