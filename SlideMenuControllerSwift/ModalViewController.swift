//
//  ModalViewController.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 10/02/2018.
//

import UIKit

class ModalViewController: UIViewController,TableViewReorderDelegate,UITableViewDelegate,UITableViewDataSource {

    //ModalView
    
    
    
    
    
    
//    =========================================
//　　　　   CustomCategoryテーブル初期値セット
//    =========================================
    //【テーブル】CustomCategoryViewのテーブルを作成
    var CusCategoryTable: UITableView!
    var cuWidth:CGFloat = 0.0//テーブルの横幅
    var cuHeight:CGFloat = 0.0//テーブルの縦幅
    
    var categoryInfo:[[String:Any]] = []//表示したいセルの配列を初期化
    var selectedRowIndex = -1//何行目か保存されていないときを見分けるための-1を代入
    var categoryId = 0//カテゴリーIDのデフォルト値（カテゴリー：All）を "0" とする
    
    //サイズフラグ
    var firstResize :Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CusCategoryTable = UITableView()
        
        view.backgroundColor = UIColor.green
        AjustTableLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    func AjustTableLayout(){
        cuWidth = self.view.bounds.width
        cuHeight = self.view.bounds.height - 150
        CusCategoryTable.frame = CGRect(x: 0, y: 0, width: cuWidth, height: cuHeight)
        CusCategoryTable.keyboardDismissMode =  .onDrag //テーブルの操作性を良くする
        
        self.view.addSubview(CusCategoryTable)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt: \(indexPath)")
        
        // タップ後すぐ非選択状態にするには下記メソッドを呼び出します．
        // sampleTableView.deselectRow(at: indexPath, animated: true)
    }
    
    
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
        
        cell.selectionStyle = .none//選択時ハイライト無効
        
        //        cell.CategoryTextField.text = ""
        
        //category内容編集するためにidプロパティを更新
        cell.id = categoryInfo[indexPath.row]["id"] as? Int
        
        //表示したい文字の設定
        cell.CategoryTextField?.text = categoryInfo[indexPath.row]["name"] as? String
        
        cell.CategoryTextField.tag = indexPath.row  //okayu
        
        return cell
    }
    
    //カテゴリー一覧呼び込み関数
    func addListCategory(){
        //CoreDataオブジェクト作成
        let categoryDatas = ingCoreData()
        //CoreDataからカテゴリーデータを全件取得
        categoryInfo = categoryDatas.readCategoryAll() as! [[String : Any]]
        
        //テーブルの再描画
        CusCategoryTable.reloadData()
    }
    
    
    //セルのスワイプ表示（デザイン）
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
            //指定されたIDのメモデータをCoreDataから削除
            self.selectedRowIndex = indexPath.row
            let id = self.categoryInfo[self.selectedRowIndex]["id"] as! Int
            //選択されたカテゴリーを削除
            let CoreDataCategory = ingCoreData()
            CoreDataCategory.deleteCategory(id: id)
            
            //選択されたカテゴリーに依存する記事を全件削除
            let CoreDataArticle = ArticleCoreData()
            CoreDataArticle.deleteArticle(category_id: id)
            
            //ビューから指定されたセルを削除
            self.categoryInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
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
