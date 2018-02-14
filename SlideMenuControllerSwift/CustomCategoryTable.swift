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

