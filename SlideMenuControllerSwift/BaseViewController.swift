//
//  BaseViewController.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 04/02/2018.
//  Copyright © 2018 Yuji Hato. All rights reserved.
//


//やるべきこと
//1.CoreDataに保存されているデータを一度全部消す
//2.CoreDataのエンティティにidカラム,saveDateを追加
//2-1.配列の初期化をセット
//2-2.Function "read""tapSave"にそれぞれ新しいカラムを追加
//2-3.

import UIKit
import CoreData

class BaseViewController: UIViewController,UITextViewDelegate{

    
    @IBOutlet weak var postView: UITextView!
    
    //カテゴリーIDのデフォルト値（カテゴリー：All）を "0" とする
    var categoryId = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        read()//デバッグ用
        
        //サンプルテキスト作成
        postView.text = "sample text"
        
        //行間指定
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        let attributes = [NSAttributedStringKey.paragraphStyle : style]
        postView.attributedText = NSAttributedString(string: postView.text,attributes: attributes)
        
        //表示テキストのフォントサイズを変更
        postView.font = UIFont.systemFont(ofSize: 16)

        self.setInputAccessoryView()
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
    
    
    
    @IBAction func keyClose(_ sender: UISwipeGestureRecognizer) {
        postView.resignFirstResponder()
    }
    
    
    //Doneボタンが押されたときに、データを保存
    //TODO:以下のバージョンの条件分岐について、えりこさんに確認
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













//TODO:以下、サイドバーのジェスチャー機能だと思われるが、できない
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
