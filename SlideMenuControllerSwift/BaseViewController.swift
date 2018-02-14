//  BaseViewController.swift
//  SlideMenuControllerSwift

//  Created by 仲松拓哉 on 04/02/2018.
//

//TODO
//1.アンダーバーの横幅をカテゴリー追加時にする
//2.


import UIKit
import CoreData

class BaseViewController: UIViewController,UITextViewDelegate,UIScrollViewDelegate{
    
    //デフォルトのメモのTextView
    @IBOutlet weak var postView: UITextView!
    //(ModalView)UITextViewのインスタンスを生成
    let textView: UITextView = UITextView()
    
    
    //【モーダルウィンドウ】パーツ
    @IBOutlet weak var ModalView: UIView!
    @IBOutlet weak var CreateCategoryBtn: UIButton!
    @IBOutlet weak var CustomCategoryBtn: UIButton!
    @IBOutlet weak var CreateCategoryView: UIView!
    @IBOutlet weak var CustomCategoryView: UIView!
    
//    =========================================
//　　　　   CustomCategoryテーブル初期値セット
//    =========================================
    //【テーブル】CustomCategoryViewのテーブルを作成
    @IBOutlet weak var CusCategoryTable: UITableView!
    //カテゴリー一覧変数(CustomCategoryTable)
    //表示したいセルの配列を初期化
    var categoryInfo:[[String:Any]] = []
    //何行目か保存されていないときを見分けるための-1を代入
    var selectedRowIndex = -1
    
    //カテゴリーIDのデフォルト値（カテゴリー：All）を "0" とする
    var categoryId = 0
    
    
    
//    =========================================
//　　　　   モーダルウィンドウボタン
//    =========================================
    //(Btn)CreateCategoryアクション
    
    @IBAction func BtnCreaateCategory(_ sender: UIButton) {
        UIView.animate(withDuration: 0, delay: 0,  animations: {
            self.CustomCategoryView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
        
    }
    //(Btn)CustomCategoryアクション
    @IBAction func BtnCustomCategory(_ sender: UIButton) {
        UIView.animate(withDuration: 0.0, delay: 0.0,  animations: {
            self.CustomCategoryView.frame = CGRect(x: 0, y: 150, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
        
    }
    
    
//    ==================================
//　　　　   カテゴリーオブジェクト
//    ==================================
//    var categoryDatas = ingCoreData()
    
//    ==================================
//　　　　    画像オブジェクト
//    ==================================
    var tabBarWidth: CGFloat!
    var tabBarHeight: CGFloat!
    var screenWidth:CGFloat!
    var screenHeight:CGFloat!
    
//    ==================================
//　　　　 アンダーバーオブジェクト
//    ==================================
    var TestView = UIView()

//    ==================================
//　　　　 スクロールバーオブジェクト
//    ==================================
    var scrollView:UIScrollView = UIScrollView()
    // スクロールバーのサイズ
    let sWidth: CGFloat = 0.0
    let sHeight: CGFloat = 0.0
    // ボタンのX,Y座標
    let sPosX: CGFloat = 0.0
    let sPosY: CGFloat = 0.0
    
    
//    ==================================
//　　　　 カテゴリーボタンオブジェクト
//    ==================================
    var btnCategory: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //カテゴリーデータ全件削除
//        let daldata = ingCoreData()
//        daldata.deleteCategoryAll()
        
        
        //viewTable カテゴリー一覧の並び替え
        CusCategoryTable.reorder.delegate = self as? TableViewReorderDelegate
        //ModalViewを見えない場所にセットする
        cretaModalWindow()
        
        
        
        //(test)ModalView【custom】
        customModalWindow()
        addListCategory()//CoreDataからテーブルデータを取得
        
        //以下ジェスチャーでWindow閉じるイベント
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(BaseViewController.DownSwipeView(sender:)))  //Swift3
        // スワイプの方向を指定
        downSwipe.direction = .down
        // viewにジェスチャーを登録
        CustomCategoryView.addGestureRecognizer(downSwipe)
        
        
        
        
        //タブバーの幅取得
        tabBarWidth = self.view.bounds.width
        tabBarHeight = self.view.bounds.height / 5
        
        //デバッグ用
        read()
        
        //サンプルテキスト作成
        postView.text = "sample text"
        
        //メモメニュー作成
        //行間指定
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        let attributes = [NSAttributedStringKey.paragraphStyle : style]
        postView.attributedText = NSAttributedString(string: postView.text,attributes: attributes)
        //表示テキストのフォントサイズを変更
        postView.font = UIFont.systemFont(ofSize: 16)

        //keyboard上の"Done"ボタンセット
        //"Main"はデフォルト画面のtextview画面
        setInputAccessoryView(viewName: "Main")
        
        //アンダーバー作成
        createTabBar()
        //カテゴリーボタンの追加
        addBtnCategory()
        
//        //カテゴリーボタン削除
//        DeleteScrollView(scv: scrollView)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        //カテゴリーボタン削除
        DeleteScrollView(scv: scrollView)
        scrollView = UIScrollView()
        viewScroll()
//      カテゴリーボタンの追加
        addBtnCategory()
    }
    
    
  
//    ==================================
//　　　　 モーダルウィンドウ作成(create)
//    ==================================
    func cretaModalWindow(){
        
        ModalView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(BaseViewController.DownSwipeView(sender:)))  //Swift3
        // スワイプの方向を指定
        downSwipe.direction = .down
        // viewにジェスチャーを登録
        self.view.addGestureRecognizer(downSwipe)

        
        CreateCategoryView.frame = CGRect(x: 0, y: 150, width: ModalView.bounds.width, height: ModalView.bounds.height - 150)
        CreateCategoryBtn.frame = CGRect(x:0,y:100,width:ModalView.bounds.width / 2, height: 50)
        CustomCategoryBtn.frame = CGRect(x:ModalView.bounds.width / 2 , y:100, width:ModalView.bounds.width / 2, height: 50)
        ModalView.addSubview(CreateCategoryBtn)
        ModalView.addSubview(CustomCategoryBtn)
        CreateCategoryView.addSubview(createText())
        ModalView.addSubview(CreateCategoryView)
        
    }
    
//    ==================================
//　　　　 モーダルウィンドウ作成(custom)
//    ==================================
    func customModalWindow(){
        
        //表示状態
        //        CustomCategoryView.frame = CGRect(x: 0, y: 150, width: self.view.bounds.width, height: self.view.bounds.height)
        //隠れた状態
        CustomCategoryView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        
        
        //スワイプジェスチャー
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(BaseViewController.DownSwipeView(sender:)))  //Swift3
        // スワイプの方向を指定
        downSwipe.direction = .down
        // viewにジェスチャーを登録
        self.view.addGestureRecognizer(downSwipe)
        
        self.view.addSubview(CustomCategoryView)
    }
    
//    ============================================
//　　　　 モーダルウィンドウ ジェスチャーイベント
//    ============================================
    @objc func DownSwipeView(sender: UISwipeGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0,  animations: {
            self.ModalView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.ModalView.bounds.width, height: self.ModalView.bounds.height - 150)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0,  animations: {
            self.CustomCategoryView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
        //キーボード閉じる
        textView.resignFirstResponder()
    }
    
//    =========================================
//　　　　  (モーダルウィンドウ)UITextViewの設定
//    =========================================
    func createText()->UITextView{
        //textViewのイチとサイズを設定
        textView.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        
        //テキストを設定
        textView.text = "入力してください"
        
        //フォントの大きさを設定
        textView.font = UIFont.systemFont(ofSize:20.0)
        
        //textViewの枠線の太さを設定
        textView.layer.borderWidth = 1
        
        //枠線の色をグレーに設定
        textView.layer.borderColor = UIColor.lightGray.cgColor
        
        //テキストを編集できるように設定
        textView.isEditable = true
        
        //TODO:未定義事項
        //1.DONEボタンのセット 2.カテゴリーの保存処理
        //キーボードに完了ボタンを追加
        setInputAccessoryView(viewName: "Modal")
        
        return textView
    }
    
    
//    ==================================
//　　　　 アンダーバーオブジェクト作成
//    ==================================
    private func createTabBar(){
        // ボタンのサイズ.
        let bWidth: CGFloat = self.view.frame.width //iphoneの横いっぱいの長さを取得
        let bHeight: CGFloat = 50 //ノリ
        
        // ボタンのX,Y座標.
        let posX: CGFloat = 0
        let posY: CGFloat = self.view.bounds.height - bHeight
        
        //TODO:TestVeiwのメンバー変数
        TestView = UIView.init(frame: CGRect(x: posX, y: posY, width: bWidth, height: bHeight))
        
        //色指定
        TestView.backgroundColor = UIColor.red
        
        TestView.addSubview(createBtn())//+ボタン
        TestView.addSubview(viewScroll())//スクロール
        self.view.addSubview(TestView)
    }
    
    
//    ==================================
//　　　　 ボタン(カテゴリー追加【+】)作成
//    ==================================
    private func createBtn() -> UIButton{
        
        var myButton: UIButton!
        // Buttonを生成する.
        myButton = UIButton()
        
        // ボタンのサイズ.
        let bWidth: CGFloat = 50
        let bHeight: CGFloat = 50
        
        // ボタンのX,Y座標.
        let posX: CGFloat = self.view.frame.width / 90
        let posY: CGFloat = 0

        // ボタンの設置座標とサイズを設定する.
        myButton.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        
        // ボタンの背景色を設定.
        myButton.backgroundColor = UIColor.blue
        
        // ボタンの枠を丸くする.
        myButton.layer.masksToBounds = true
        
        // コーナーの半径を設定する.
        myButton.layer.cornerRadius = 20.0
        
        // タイトルを設定する(通常時).
        myButton.setTitle("+", for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        myButton.setTitle("新規登録", for: .highlighted)
        myButton.setTitleColor(UIColor.black, for: .highlighted)
        
        // ボタンにタグをつける.
        myButton.tag = 0
        
        // イベントを追加する
        myButton.addTarget(self, action: #selector(self.onClickMyButton(sender:)), for: .touchUpInside)
        return myButton
    }
    
    
    
//    ============================================
//　　　　   ボタン【+】プッシュ後のアクション
//    ============================================
    @objc func onClickMyButton(sender: UIButton) {
//      ------------モーダルウィンドウ-----------
        
        switch sender.tag {
        case 0:
            
//            self.blueView.center = self.view.center
            UIView.animate(withDuration: 0.5, delay: 0.0,  animations: {
                self.ModalView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
            
            
            //モーダルウィンドウの出し方2
//            let second = SecondViewController()
//            let nav = UINavigationController(rootViewController: second)
//            self.present(nav, animated: true, completion: nil)
        case 1:
            print("1")
        default:
            print("デフォルト")
        }
    }
    
    
//    ============================================
//　　　　   ボタン(カテゴリー選択)作成
//    ============================================
    private func btnCategory(inputCategory :String)->UIButton{
        
        var text = "サンプル"
        //関数にデータが入った場合にのみ、そのデータを変数へ
        text = inputCategory
        let font = UIFont(name: "Hiragino Kaku Gothic ProN", size: 18)
        //以下のコマンドで文字列の横幅を取得
        // width.widthでInt型でデータを取得出来る
        let width = text.size(withAttributes: [NSAttributedStringKey.font : font])
        
        
        // Buttonを生成する.
        btnCategory = UIButton()
        
        // ボタンのサイズ
        let bcWidth: CGFloat = width.width
        let bcHeight: CGFloat = 50
        
        // ボタンのX,Y座標
        let bcPosX: CGFloat = 0
        let bcPosY: CGFloat = 0
        
        // ボタンの設置座標とサイズを設定する.
        btnCategory.frame = CGRect(x: bcPosX, y: bcPosY, width: bcWidth, height: bcHeight)
        
        // ボタンの背景色を設定.
        btnCategory.backgroundColor = UIColor.blue
        
        // ボタンの枠を丸くする.
        btnCategory.layer.masksToBounds = true
        
        // コーナーの半径を設定する.
        btnCategory.layer.cornerRadius = 20.0
        
        // タイトルを設定する(通常時).
        btnCategory.setTitle(text, for: .normal)
        btnCategory.setTitleColor(UIColor.white, for: .normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        btnCategory.setTitle(text, for: .highlighted)
        btnCategory.setTitleColor(UIColor.black, for: .highlighted)
        
        // ボタンにタグをつける.
        btnCategory.tag = 1
        
        // イベントを追加する
        btnCategory.addTarget(self, action: #selector(self.onClickMyButton(sender:)), for: .touchUpInside)
        
        self.view.addSubview(btnCategory)
        return btnCategory
    }
    
    
//    ==================================
//　　　　  スクロールオブジェクト作成
//    ==================================
    private func viewScroll()->UIScrollView{
        scrollView.backgroundColor = UIColor.gray
        
        let sWidth: CGFloat = self.view.frame.width - 60 //50はボタンのwidthサイズ
        let sHeight: CGFloat = 50
        
        // ボタンのX,Y座標
        let sPosX: CGFloat = self.view.frame.width / 90 + 60 //ボタン横の幅 + 50はボタンのwidthサイズ
        let sPosY: CGFloat = 0
        
        
        scrollView.frame = CGRect(x: sPosX, y: sPosY, width: sWidth, height: sHeight)
        
        //スクロールの跳ね返り
        scrollView.bounces = false
        
        //TODO:下記のスクロールバーを消す
//        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Delegate を設定
        scrollView.delegate = self
        
        TestView.addSubview(scrollView)
        
        return scrollView
    }
    
    
//    ========================================================
//　　　　  スクロールオブジェクトへカテゴリーボタン追加機能
//    ========================================================
    //スクロールバーオブジェクトにカテゴリーボタンを追加
    func addBtnCategory(){
        var scWidth = 0//コンテンツの中身のwidth
        //カテゴリーボタンの初期化
        let categoryDatas = ingCoreData()
        
        //CoreDataからカテゴリーデータを全件取得
        let inputCategories = categoryDatas.readCategoryAll()
        
        var x = 0// カテゴリーボタンオブジェクトのカウント変数
        for inputCategory in inputCategories{
            //カテゴリーオブジェクトからカテゴリー名だけ取得
            let btnName = inputCategory["name"] as! String
            let catBtn =  btnCategory(inputCategory: btnName)//返り値がボタンオブジェクト
            
            //オブジェクトの重複防止
            catBtn.frame.origin = CGPoint(x: scWidth, y: 0)
            //オブジェクトをスクロールバーへ追加
            scrollView.addSubview(catBtn)
            //オブジェクト全体のwidthを取得
            scWidth += Int(catBtn.layer.bounds.width) + 5
            x += 1
        }
        scrollView.contentSize = CGSize(width: scWidth, height: 50)

    }
    
//    =====================================================
//　　　　   　スクロールオブジェクト内 カテゴリーボタン削除
//    =====================================================
    func DeleteCategoryBtn() {
//        btnCategory = UIButton()
        
        let subviews = btnCategory.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    
//    =====================================================
//　　　　   　スクロールオブジェクト内 スクロールビュー削除
//    =====================================================
    func DeleteScrollView(scv:UIScrollView) {
        //        btnCategory = UIButton()
        scv.removeFromSuperview()
    }

//    =======================================
//　　　　    スクロールイベント（未定義）
//    =======================================
    /* 以下は UITextFieldDelegate のメソッド */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール中の処理
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // ドラッグ開始時の処理
    }
    
    
//    =======================================
//　　　　    ジェスチャーイベント(下スワイプ)
//    =======================================
    @IBAction func keyClose(_ sender: UISwipeGestureRecognizer) {
        postView.resignFirstResponder()
    }
    
    
//    ==================================
//　　　　    CoreData操作(Insert処理)
//    ==================================
    func tapSave(){
        let appD: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        //データベースと接続するために使用
        let viewContext = appD.persistentContainer.viewContext
        
        //Articleエンティティオブジェクトを作成
        let Article = NSEntityDescription.entity(forEntityName: "Article", in: viewContext)
        
        //Articleエンティティにレコード（行）を挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject (entity: Article!, insertInto: viewContext)
        
        //値のセット
        newRecord.setValue(postView.text, forKey: "content")
        newRecord.setValue(Date(), forKey: "saveDate")//Date()で現在日時が取得できる
        newRecord.setValue(categoryId,forKey: "category_id")
        
        do{
            //レコードの即時保存
            //TODO:データ保存時のバリデーション確認
            try viewContext.save()
        }catch{
        }
    }
    
//    ==================================
//　　　　    CoreData操作(Read処理)
//    ==================================
    //既に存在するデータの読込処理
    func read(){
        //AppDelegateを使う用意をする
        let appD: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appD.persistentContainer.viewContext
    
        //どのエンティティを操作するためのオブジェクトを作成
        let query: NSFetchRequest<Article> = Article.fetchRequest()
        
        do{
            //データを一括取得
            let fetchResult = try viewContext.fetch(query)
            
            //データの取得
            for result: AnyObject in fetchResult{
                let content: String = result.value(forKey: "content") as! String
                let saveDate :Date = result.value(forKey: "saveDate") as! Date
                let category: Int64 = (result.value(forKey: "category_id") as? Int64)!
            }
        }catch{
        }
    }
    

//    ==================================
//　　　　    キーボードのDoneボタン追加
//    ==================================
    func setInputAccessoryView(viewName: String) {
//        --------ボタンオブジェクト作成-----------------------------
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                     target: self, action: nil)
//        ------------------------------------------------------
        
        //Main:デフォルトのメモ画面のtextview
        //Modal:モーダルウィンドウのtextview
        //TODO:以下の"action: #selector(self.MaincommitButtonTapped(sender:)"のコードを
        //     この引数senderに引数を入れるとエラーがでる。
        if viewName == "Main" {
            // 完了ボタン
            let commitButton = UIBarButtonItem(
                title: "Done",
                style: .done,
                target: self,
                action: #selector(self.MaincommitButtonTapped(sender:))
            )
            kbToolBar.items = [spacer, commitButton]
            postView.inputAccessoryView = kbToolBar
            
        }else if viewName == "Modal"{
            let commitButton = UIBarButtonItem(
                title: "Done",
                style: .done,
                target: self,
                action: #selector(self.ModalcommitButtonTapped(sender:))
            )
            kbToolBar.items = [spacer, commitButton]
            textView.inputAccessoryView = kbToolBar
            
        }
    }
    
//    ==================================
//　　　　 Doneボタンの実行処理(Main,Modal)
//    ==================================
    //TODO:以下の処理が微妙
    //Main
    @objc func MaincommitButtonTapped(sender: Any) {
        self.resignFirstResponder()

        tapSave()//インサート
        read()//デバッグ用
        postView.resignFirstResponder()//キーボードを閉じる
    }
    
    @objc func ModalcommitButtonTapped(sender: Any) {
        self.resignFirstResponder()
        
        //CoreData処理
        let coreData = ingCoreData()
        coreData.insertCategory(name: textView.text)//インサート
        coreData.readCategoryAll()//データチェック
        
        //カテゴリーボタン削除
        DeleteScrollView(scv: scrollView)
        scrollView = UIScrollView()
        viewScroll()
        //        //カテゴリーボタンの追加
        addBtnCategory()
        
        textView.resignFirstResponder()//キーボードを閉じる
        
        //モーダルウィンドウ閉じる
        UIView.animate(withDuration: 0.5, delay: 0.0,  animations: {
            self.ModalView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.ModalView.bounds.width, height: self.ModalView.bounds.height - 150)
        }, completion: nil)
    }
    
    
//    ==================================
//　　　　  CoreData操作(Delete処理)
//    ==================================
    func Delete(){
        //AppDelegateを使う用意をする
        let appD: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appD.persistentContainer.viewContext
        
        //どのエンティティを操作するためのオブジェクトを作成
        let query: NSFetchRequest<Article> = Article.fetchRequest()
        
        do{
            //削除するデータを取得
            let fetchResult = try viewContext.fetch(query)
            for result: AnyObject in fetchResult {
                let record = result as! NSManagedObject
                //一行ずつ削除
                viewContext.delete(record)
            }
            try viewContext.save()
        } catch{
        }
    }
}



//    ==================================
//　　　　    サイドバーアクション
//    ==================================
extension BaseViewController : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}
