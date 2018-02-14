//
//  CustomCategoryTable.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 14/02/2018.
//

import Foundation
import UIKit


extension BaseViewController: UITableViewDelegate,UITableViewDataSource {
//    ==========================
//　　　　  　テーブル作成
//    ==========================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(categoryInfo.count)
        return categoryInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let spacer = tableView.reorder.spacerCell(for: indexPath) {
            return spacer
        }
        
        //文字列を表示するセルの取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //表示したい文字の設定
        cell.textLabel?.text = categoryInfo[indexPath.row]["name"] as? String
        //文字設定したセルを返す
        return cell
    }
    
    
    //カテゴリー一覧呼び込み関数
    func addListCategory(){
        //CoreDataオブジェクト作成
        let categoryDatas = ingCoreData()
        //CoreDataからカテゴリーデータを全件取得
        categoryInfo = categoryDatas.readCategoryAll() as! [[String : Any]]
        
        //テーブルの再描画
        //        tableView.reloadData()
    }
    
    //セルのスワイプ表示（デザイン）
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
            //指定されたIDのメモデータをCoreDataから削除
            self.selectedRowIndex = indexPath.row
            self.Delete()
            //ビューから指定されたセルを削除
            //            self.artInfo.remove(at: indexPath.row)
            //            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    
}

//セルの並び替え処理
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
        
        print(categoryInfo)
        
        //4.CoreDataのsort_idをアップデート
        let coreDataUpdate = ingCoreData()
        coreDataUpdate.sortChange(categoryArray: categoryInfo)
        
        //5.テーブルの再読込
        CusCategoryTable.reloadData()
        
        
    }
}
