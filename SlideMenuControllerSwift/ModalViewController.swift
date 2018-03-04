 //
//  ModalViewController.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 10/02/2018.
//

import UIKit
import CoreData

class ModalViewController: UIViewController,TableViewReorderDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
//    =========================================
//　　　　   モーダルウィンドウの初期値
//    =========================================
    let textView: UITextView = UITextView()//(ModalView)UITextViewのインスタンスを生成
    var ModalView: UIView!
    var CreateCategoryBtn: UIButton!
    var CustomCategoryBtn: UIButton!
    var CreateCategoryView: UIView!
    var CustomCategoryView: UIView!
    
//    =========CustomCategoryテーブル初期値セット==============
    var CusCategoryTable: UITableView!
    var cuWidth:CGFloat = 0.0//テーブルの横幅
    var cuHeight:CGFloat = 0.0//テーブルの縦幅
    
    var categoryInfo:[[String:Any]] = []//表示したいセルの配列を初期化
    var selectedRowIndex = -1//何行目か保存されていないときを見分けるための-1を代入
    var categoryId = 0//カテゴリーIDのデフォルト値（カテゴリー：All）を "0" とする
    
    //サイズフラグ
    var firstResize :Int = 0
    
    
    
//    =========================================
//　　　　   モーダルウィンドウの各値の設定
//    =========================================
    //モーダルウィンドウのマージン設定
    //※変更する場合、CustomPresentationControllerのmarginも変更
    let margin = (x: CGFloat(30), y: CGFloat(220.0))
    
    //
    
    
    
    
    //    =========================================
    //　　　　   モーダルウィンドウボタン
    //    =========================================
    //(Btn)CreateCategoryアクション
//    @IBAction func BtnCreaateCategory(_ sender: UIButton) {
//        UIView.animate(withDuration: 0, delay: 0,  animations: {
//            self.CustomCategoryView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
//        }, completion: nil)
//
//        keyboardClose()
//    }
    
    //(Btn)CustomCategoryアクション
//    @IBAction func BtnCustomCategory(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.0, delay: 0.0,  animations: {
//            self.CustomCategoryView.frame = CGRect(x: 0, y: 150, width: self.view.bounds.width, height: self.view.bounds.height)
//        }, completion: nil)
//        keyboardClose()
//    }

    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CusCategoryTable = UITableView()
        
        CusCategoryTable.register(tableViewCellClass: CustomTableViewCell.self)
        
        view.backgroundColor = UIColor.green
        
        cretaModalWindow()
        addListCategory()//CoreDataからテーブルデータを取得
        //viewTable カテゴリー一覧の並び替え
        CusCategoryTable.reorder.delegate = self as? TableViewReorderDelegate
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        testNotificationForViewwillAppear()
//        self.setNavigationBarItem()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        testNotificationForViewwillDisAppear()

    }
    
    
    
    
    
    
    
//    ==================================
//　　　　 モーダルウィンドウ作成(create)
//    ==================================
    func cretaModalWindow(){
        //オブジェクトの初期化
        ModalView = UIView()
        
    
        ModalView.frame = CGRect(x: 0, y:0, width: self.view.bounds.width - margin.x, height: self.view.bounds.height - margin.y)
        ModalView.backgroundColor = UIColor.black
        
        
        let createBtn = makeCreateBtn()
        let customBtn = makeCustomBtn()
        let createView = makeCreateView()
        let createTable = AjustTableLayout()
        
        ModalView.addSubview(createBtn)
        ModalView.addSubview(customBtn)
        createView.addSubview(createTable)
        
        
//        createView.addSubview(createText())
        ModalView.addSubview(createView)
//        self.view.bringSubview(toFront: ModalView)
        self.view.addSubview(ModalView)
    }
    
    
//    ==================================
//　　　　 モーダルウィンドウ作成(custom)
//    ==================================
    func customModalWindow(){
        //隠れた状態
        CustomCategoryView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        AjustTableLayout()//テーブルのサイズを調整

        
        self.view.addSubview(CustomCategoryView)
    }
    
    

//    =========================================
//　　　　  モーダルウィンドウ パーツ作成
//    =========================================
//    =============createBtnの設定============
    func makeCreateBtn()->UIButton{
        CreateCategoryBtn = UIButton()
        CreateCategoryBtn.frame = CGRect(x: 0,y: 0,width:ModalView.bounds.width / 2, height: 50)
        CreateCategoryBtn.backgroundColor = UIColor.red
        return CreateCategoryBtn
    }
    
//    =============customBtnの設定============
    func makeCustomBtn()->UIButton{
        CustomCategoryBtn = UIButton()
        CustomCategoryBtn.frame = CGRect(x: ModalView.bounds.width / 2 , y: 0, width:ModalView.bounds.width / 2, height: 50)
        CustomCategoryBtn.backgroundColor = UIColor.blue
        
        return CustomCategoryBtn
    }
    
    
//    =============createViewの設定============
    func makeCreateView()->UIView{
        CreateCategoryView = UIView()
        //create画面の大きさ設定
        CreateCategoryView.frame = CGRect(x: 0, y: 50, width: ModalView.bounds.width, height: ModalView.bounds.height - 50)
        CreateCategoryView.backgroundColor = UIColor.gray
        return CreateCategoryView
    }
    
    
//    =============UITextViewの設定============
    
    func createText()->UITextView{
        //textViewのイチとサイズを設定
        textView.frame = CGRect(x: 0, y:0, width: self.view.frame.width - margin.x, height: self.view.frame.height - margin.y)
        textView.placeholder = "新規カテゴリーを入力"
        textView.font = UIFont.systemFont(ofSize:20.0)//フォントの大きさを設定
        textView.layer.borderWidth = 1//textViewの枠線の太さを設定
        textView.layer.borderColor = UIColor.lightGray.cgColor//枠線の色をグレーに設定
        textView.isEditable = true//テキストを編集できるように設定
        setInputAccessoryView()//キーボードに完了ボタンを追加
        
        return textView
    }
    
//    ==============キーボードのDoneボタン追加====================
    func setInputAccessoryView() {
        //--------ボタンオブジェクト作成--------------
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                     target: self, action: nil)
        
        //Modal:モーダルウィンドウのtextview
        
        let commitButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(self.ModalcommitButtonTapped(sender:))
        )
        kbToolBar.items = [spacer, commitButton]
        textView.inputAccessoryView = kbToolBar
            

    }
    
//    ==================================
//　　　　 Doneボタンの実行処理(Modal)
//    ==================================
    @objc func ModalcommitButtonTapped(sender: Any) {
        self.resignFirstResponder()
        
        //CoreData処理
        let coreData = ingCoreData()
        coreData.insertCategory(name: textView.text)//インサート
        coreData.readCategoryAll()//データチェック
        
//        keyboardClose()//キーボードを閉じる
        addListCategory()

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    ==================================
//　　　　　　　 キーボード観察
//    ==================================
    func testNotificationForViewwillAppear() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ModalViewController.keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ModalViewController.keyboardWillHide(_:)) ,
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func testNotificationForViewwillDisAppear(){
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillShow,
                                                  object: self.view.window)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardDidHide,
                                                  object: self.view.window)
    }
    
    
    //TODO:やることリスト
    //CusCatogoryTableの高さを取得する
    //その高さとキーボードの高さの差
    
    @objc func keyboardWillShow(_ notification: Notification) {
        print(#function)
        let info = notification.userInfo!
        
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let topKeyboard = CusCategoryTable.frame.height - keyboardFrame.size.height
        
        // 重なり
        let distance = slideHeight - topKeyboard
        
        print("カテゴリーテーブルの高さ")
        print(CusCategoryTable.frame.height)
        print("keyboardFrame")
        print(keyboardFrame.size.height)
        print("slideHeight")
        print(slideHeight)
        print("topKeyboard")
        print(topKeyboard)
        
        
        //テーブルのscrollView内に余分な高さ(contentOffset)をセット
        if distance >= 0 {
            CusCategoryTable.contentOffset.y = distance
        }
    }
    

    @objc func keyboardWillHide(_ notification: Notification) {

        print(#function)
        CusCategoryTable.contentOffset.y = 0

        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
//    ===============================================
//　　　　　　　　　       テーブル設定
//    ===============================================
    func AjustTableLayout()->UITableView{
        CusCategoryTable.delegate   = self
        CusCategoryTable.dataSource = self
        
        CusCategoryTable.register(CustomTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(CustomTableViewCell.self))
        print(NSStringFromClass(CustomTableViewCell.self))
        self.view.addSubview(CusCategoryTable)
        
        
        cuWidth = self.view.bounds.width
        cuHeight = self.view.bounds.height
        //y座標の "-50"はcreateボタンとcustomボタン分の高さを差し引いた分
        CusCategoryTable.frame = CGRect(x: 0, y: 0, width: cuWidth - margin.x, height: cuHeight - margin.y - 50)
        CusCategoryTable.keyboardDismissMode =  .onDrag //テーブルの操作性を良くする
        
//        self.view.addSubview(CusCategoryTable)
        return CusCategoryTable
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let cell = tableView.dequeueReusableCell(withClass: CustomTableViewCell.self, for: indexPath)
        
//        cell.textinit()
        cell.test()
        
        cell.selectionStyle = .none//選択時ハイライト無効
        
        //        cell.CategoryTextField.text = ""
        
        //category内容編集するためにidプロパティを更新
        cell.id = categoryInfo[indexPath.row]["id"] as? Int
        
        //表示したい文字の設定
        cell.CategoryTextField.text = categoryInfo[indexPath.row]["name"] as? String
//        cell.CategoryTextField.text = "sample"
        
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





extension UITableView {
    
    // func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell
    // の代わりに使用する
    func dequeueReusableCell<T: UITableViewCell>(withClass type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! T
    }
    
    // func dequeueReusableHeaderFooterView(withIdentifier identifier: String) -> UITableViewHeaderFooterView?
    // の代わりに使用する
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass type: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) as! T
    }
    
    // func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
    // func register(_ cellClass: Swift.AnyClass?, forCellReuseIdentifier identifier: String)
    // の代わりに使用する
    func register(tableViewCellClass cellClass: AnyClass) {
        let className = String(describing: cellClass)
        if UINib.fileExists(nibName: className) {
            self.register(UINib.cachedNib(nibName: className), forCellReuseIdentifier: className)
        } else {
            self.register(cellClass, forCellReuseIdentifier: className)
        }
    }
    
    // func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String)
    // func register(_ aClass: Swift.AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String)
    // の代わりに使用する
    func register(headerFooterViewClass aClass: AnyClass) {
        let className = String(describing: aClass)
        if UINib.fileExists(nibName: className) {
            self.register(UINib.cachedNib(nibName: className), forHeaderFooterViewReuseIdentifier: className)
        } else {
            self.register(aClass, forHeaderFooterViewReuseIdentifier: className)
        }
    }
}


extension UINib {
    
    static let nibCache = NSCache<NSString, UINib>()
    
    static func fileExists(nibName: String) -> Bool {
        return Bundle.main.path(forResource: nibName, ofType: "nib") != nil
    }
    
    static func cachedNib(nibName: String) -> UINib {
        if let nib = self.nibCache.object(forKey: nibName as NSString) {
            return nib
        } else {
            let nib = UINib(nibName: nibName, bundle: nil)
            self.nibCache.setObject(nib, forKey: nibName as NSString)
            return nib
        }
    }
}
