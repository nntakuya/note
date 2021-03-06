 //
//  ModalViewController.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 10/02/2018.
//

import UIKit
import CoreData

class ModalViewController: UIViewController,TableViewReorderDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate {
    
    
//    =========================================
//　　　　   モーダルウィンドウの初期値
//    =========================================
    let textView: UITextView = UITextView()//(ModalView)UITextViewのインスタンスを生成
    var ModalView: UIView!
    var CreateCategoryBtn: UIView!
    var CustomCategoryBtn: UIView!
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
    
    //BaseviewControllerインスタンス
    var bvc:BaseViewController = BaseViewController()//アンダーバー更新に必要
    
    //CustomPresentationControllerインスタンス
    var cpc  = CustomPresentationController.self
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CusCategoryTable = UITableView()
        
        //カスタムセルの設定
        CusCategoryTable.register(tableViewCellClass: CustomTableViewCell.self)
        
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
        ModalView.backgroundColor = UIColor.clear
        
        
        let createBtn = makeCreateBtn()
        let customBtn = makeCustomBtn()
        let createView = makeCreateView()
        let createTable = AjustTableLayout()
        
        ModalView.addSubview(createBtn)
        ModalView.addSubview(customBtn)
        createView.addSubview(createTable)
        createView.addSubview(createText())
        
        ModalView.addSubview(createView)
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
    func makeCreateBtn()->UIView{
        return makingBtn(title: "create", color: "white")
    }
    
    @objc func createAction(sender: UIButton){
        textView.removeFromSuperview()
        //textViewのイチとサイズを設定
        textView.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height - 35)
        textView.placeholder = "新規カテゴリーを入力"
        textView.font = UIFont.systemFont(ofSize:20.0)//フォントの大きさを設定
        textView.layer.borderWidth = 1//textViewの枠線の太さを設定
        textView.layer.borderColor = UIColor.lightGray.cgColor//枠線の色をグレーに設定
        textView.isEditable = true//テキストを編集できるように設定
        setInputAccessoryView()//キーボードに完了ボタンを追加
        
        CreateCategoryView.addSubview(textView)
        
        CreateCategoryBtn.removeFromSuperview()
        CustomCategoryBtn.removeFromSuperview()
        ModalView.addSubview(makingBtn(title: "create", color: "white"))
        ModalView.addSubview(makingBtn(title: "custom", color: "gray"))
        
        
    }
    
    
//    =============customBtnの設定============
    func makeCustomBtn()->UIView{
        return makingBtn(title: "custom", color: "gray")
    }
    @objc func customAction(sender: UIButton){
        textView.removeFromSuperview()
        
        CreateCategoryBtn.removeFromSuperview()
        CustomCategoryBtn.removeFromSuperview()
        ModalView.addSubview(makingBtn(title: "create", color: "gray"))
        ModalView.addSubview(makingBtn(title: "custom", color: "white"))
    }
    
    //    =======ボタンオブジェクト作成関数=========
    // title:"create"or"custom"  ,  color:"white"or"gray"
    func makingBtn(title:String,color:String)->UIView{
        let aboveParts = UIButton()
        let underParts = UIButton()
        
        aboveParts.layer.cornerRadius = 15
        
        if color == "white"{
            aboveParts.backgroundColor = UIColor.white
            underParts.backgroundColor = UIColor.white
            underParts.setTitleColor(UIColor.black, for: .normal)
        }else if color == "gray"{
            aboveParts.backgroundColor = UIColor.gray
            underParts.backgroundColor = UIColor.gray
            underParts.setTitleColor(UIColor.white, for: .normal)
        }
        
        
        if title == "create"{
            CreateCategoryBtn = UIView()
            CreateCategoryBtn.backgroundColor = UIColor.clear
            CreateCategoryBtn.frame = CGRect(x: 0,y: 0,width:ModalView.bounds.width / 2, height: 35)
            aboveParts.frame = CGRect(x:0, y:0, width:CreateCategoryBtn.frame.width + 0.5,height: CreateCategoryBtn.frame.height/2)
            
            underParts.frame = CGRect(x:0, y:CreateCategoryBtn.frame.height/2 - 8,width:CreateCategoryBtn.frame.width,height: CreateCategoryBtn.frame.height/2 + 7)
            
            underParts.setTitle("Create Category", for: .normal)
            
            underParts.addTarget(self, action: #selector(createAction(sender:)), for: .touchUpInside)
            
            CreateCategoryBtn.addSubview(aboveParts)
            CreateCategoryBtn.addSubview(underParts)
            
            return CreateCategoryBtn
            
        }else{
            CustomCategoryBtn = UIView()
            CustomCategoryBtn.backgroundColor = UIColor.clear
            CustomCategoryBtn.frame = CGRect(x: ModalView.bounds.width / 2 , y: 0, width:ModalView.bounds.width / 2, height: 35)
            aboveParts.frame = CGRect(x:0, y:0, width:CustomCategoryBtn.frame.width + 0.5,height: CreateCategoryBtn.frame.height/2)
            
            underParts.frame = CGRect(x:0, y:CustomCategoryBtn.frame.height/2 - 8,width:CreateCategoryBtn.frame.width,height: CreateCategoryBtn.frame.height/2 + 7)
            
            
            underParts.setTitle("Custom Category", for: .normal)
            
            underParts.addTarget(self, action: #selector(customAction(sender:)), for: .touchUpInside)
            
            
            CustomCategoryBtn.addSubview(aboveParts)
            CustomCategoryBtn.addSubview(underParts)
            
            return CustomCategoryBtn
        }
    }
    
    
    
    
//    =============createViewの設定============
    func makeCreateView()->UIView{
        CreateCategoryView = UIView()
        //create画面の大きさ設定
        CreateCategoryView.frame = CGRect(x: 0, y: 34, width: ModalView.bounds.width, height: ModalView.bounds.height - 50)
        CreateCategoryView.backgroundColor = UIColor.clear
        return CreateCategoryView
    }
    
    
//    =============UITextViewの設定============
    
    func createText()->UITextView{
        //textViewのイチとサイズを設定
        textView.frame = CGRect(x: 0, y:0, width: self.view.frame.width - margin.x, height: self.view.frame.height - margin.y - 35)
        textView.placeholder = "新規カテゴリーを入力"
        textView.font = UIFont.systemFont(ofSize:20.0)//フォントの大きさを設定
        textView.layer.borderWidth = 1//textViewの枠線の太さを設定
        textView.layer.borderColor = UIColor.lightGray.cgColor//枠線の色をグレーに設定
        textView.isEditable = true//テキストを編集できるように設定
        textView.returnKeyType = .done
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
        closeModal()
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func closeModal(){
        self.resignFirstResponder()
        
        //CoreData処理
        let coreData = ingCoreData()
        coreData.insertCategory(name: textView.text)//インサート
        coreData.readCategoryAll()//データチェック
        
        textView.resignFirstResponder
        addListCategory()
        
        self.dismiss(animated: true, completion: nil)
        
        bvc.updateScrollBar()
        
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
        CusCategoryTable.frame = CGRect(x: 0, y: 0, width: cuWidth - margin.x, height: cuHeight - margin.y - 35)
        CusCategoryTable.keyboardDismissMode =  .onDrag //テーブルの操作性を良くする
        
//        self.view.addSubview(CusCategoryTable)
        return CusCategoryTable
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt: \(indexPath)")
        
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
        let cell = tableView.dequeueReusableCell(withClass: CustomTableViewCell.self, for: indexPath)
        
        cell.makingCustomCell()
        
        cell.selectionStyle = .none//選択時ハイライト無効
        
        //category内容編集するためにidプロパティを更新
        cell.id = categoryInfo[indexPath.row]["id"] as? Int
        
        //表示したい文字の設定
        cell.CategoryTextField.text = categoryInfo[indexPath.row]["name"] as? String
        
        cell.CategoryTextField.tag = indexPath.row
        
        cell.mvc = self
        cell.bvc = bvc
        
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
        bvc.updateScrollBar()
    }

}





extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(withClass type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! T
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(withClass type: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) as! T
    }
    
    func register(tableViewCellClass cellClass: AnyClass) {
        let className = String(describing: cellClass)
        if UINib.fileExists(nibName: className) {
            self.register(UINib.cachedNib(nibName: className), forCellReuseIdentifier: className)
        } else {
            self.register(cellClass, forCellReuseIdentifier: className)
        }
    }
    
   
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
