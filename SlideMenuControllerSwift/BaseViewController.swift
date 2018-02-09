//
//  BaseViewController.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 04/02/2018.
//  Copyright © 2018 Yuji Hato. All rights reserved.
//

import UIKit
import CoreData

class BaseViewController: UIViewController,UITextViewDelegate,UIScrollViewDelegate {

    
    @IBOutlet weak var postView: UITextView!
    
    //カテゴリーIDのデフォルト値（カテゴリー：All）を "0" とする
    var categoryId = 0
    
//    ==================================
//　　　　    画像オブジェクト作成
//    ==================================
    var tabBarWidth: CGFloat!
    var tabBarHeight: CGFloat!
    var screenWidth:CGFloat!
    var screenHeight:CGFloat!
    var scrollView:UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.setInputAccessoryView()
        
        //ボタンオブジェクトセット
        createTabBar()
        
        //テスト関数
//        testScroll()
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
    }
    
    
//    ==================================
//　　　　    アンダーバーオブジェクト作成
//    ==================================
    
    private func createTabBar(){
        
        // ボタンのサイズ.
        let bWidth: CGFloat = self.view.frame.width //iphoneの横いっぱいの長さを取得
        let bHeight: CGFloat = 50 //ノリ
        
        // ボタンのX,Y座標.
        let posX: CGFloat = 0
        
        let posY: CGFloat = self.view.bounds.height - bHeight
        
        let TestView = UIView.init(frame: CGRect(x: posX, y: posY, width: bWidth, height: bHeight))
        //色指定
        TestView.backgroundColor = UIColor.red
        
        
        TestView.addSubview(createBtn())
        TestView.addSubview(viewScroll())
        self.view.addSubview(TestView)
    }
    
//    ==================================
//　　　　    ボタンオブジェクト作成
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
        myButton.tag = 1
        
        // イベントを追加する
        myButton.addTarget(self, action: #selector(self.onClickMyButton(sender:)), for: .touchUpInside)
        return myButton
    }
    /*
     ボタンのイベント.
     */
    @objc func onClickMyButton(sender: UIButton) {
        print("onClickMyButton")
    }
    
    
//    ==================================
//　　　　   スクロールオブジェクト作成
//    ==================================
    
    private func viewScroll()->UIScrollView{
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.gray
        
        // 表示窓のサイズと位置を設定
        //x: 0, y: 0, width: 50, height:50
        // スクロールバーのサイズ.
        let sWidth: CGFloat = self.view.frame.width - 60 //50はボタンのwidthサイズ
        let sHeight: CGFloat = 50
        
        // ボタンのX,Y座標.
        let sPosX: CGFloat = self.view.frame.width / 90 + 60 //ボタン横の幅 + 50はボタンのwidthサイズ
        let sPosY: CGFloat = 0
        
        scrollView.frame = CGRect(x: sPosX, y: sPosY, width: sWidth, height: sHeight)
        
        
        // 中身の大きさを設定
        scrollView.contentSize = CGSize(width: 1000, height: 600)
        
        // スクロールの跳ね返り
        scrollView.bounces = false
        
        // スクロールバーの見た目と余白
        scrollView.indicatorStyle = .white
        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Delegate を設定
        scrollView.delegate = self
        
        // ScrollViewの中身を作る
        for i in 1 ..< 9 {
            let label = UILabel()
            label.text = "ラベル\(i)"
            label.sizeToFit()
            label.backgroundColor = UIColor.blue
            label.center = CGPoint(x: 100 * i, y: 60 * i)
            scrollView.addSubview(label)
        }
        
//        self.view.addSubview(scrollView)
        
        return scrollView
    }
    
    /* 以下は UITextFieldDelegate のメソッド */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール中の処理
        print("didScroll")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // ドラッグ開始時の処理
        print("beginDragging")
    }
    
    

    
//    ==================================
//　　　　    ジェスチャーイベント
//    ==================================
    
    @IBAction func keyClose(_ sender: UISwipeGestureRecognizer) {
        postView.resignFirstResponder()
    }
    
    
    //Doneボタンが押されたときに、データを保存
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
//　　　　    CoreData操作
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
                
                print(content)
                print(saveDate)
                print(category)
            }
            
        }catch{
        }
    }
    
    //ToDo保留
    func setInputAccessoryView() {
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                     target: self, action: nil)

        // 完了ボタン
        let commitButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(self.commitButtonTapped(sender:))
        )
        
        kbToolBar.items = [spacer, commitButton]
        
        postView.inputAccessoryView = kbToolBar
    }
    
    
    //おそらく以下はボタンを押した後のアクション定義する場所
    //@objcはググる
    // #selectorをつけるから、
    @objc func commitButtonTapped(sender: Any) {
        self.resignFirstResponder()
        tapSave()
        read()//デバッグ用
//        Delete()
        postView.resignFirstResponder()
    }
    
    //削除機能
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
