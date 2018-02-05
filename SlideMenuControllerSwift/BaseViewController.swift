//
//  BaseViewController.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 04/02/2018.
//  Copyright © 2018 Yuji Hato. All rights reserved.
//

import UIKit
import CoreData

class BaseViewController: UIViewController,UITextViewDelegate{

    
    @IBOutlet weak var postView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if #available(iOS 10.0, *) {
            let viewContext = appD.persistentContainer.viewContext
            
            //Articleエンティティオブジェクトを作成
            let Article = NSEntityDescription.entity(forEntityName: "Article", in: viewContext)
            
            //Articleエンティティにレコード（行）を挿入するためのオブジェクトを作成
            let newRecord = NSManagedObject (entity: Article!, insertInto: viewContext)
            
            //値のセット
            newRecord.setValue(postView.text, forKey: "content")
            
            do{
                //レコードの即時保存
                //TODO:データ保存時のバリデーション確認
                try viewContext.save()
                
            }catch{
            }
            
        } else {
            //ここはえりこさんに確認する
        }
    }
    
    //既に存在するデータの読込処理
    func read(){
        //AppDelegateを使う用意をする
        let appD: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            let viewContext = appD.persistentContainer.viewContext
            
            //Articleエンティティオブジェクトを作成
//            let Article = NSEntityDescription.entity(forEntityName: "Article", in: viewContext)
            
            //どのエンティティを操作するためのオブジェクトを作成
            let query: NSFetchRequest<Article> = Article.fetchRequest()
            
            do{
                //データを一括取得
                let fetchResult = try viewContext.fetch(query)
                
                //データの取得
                for result: AnyObject in fetchResult{
                    let content: String? = result.value(forKey: "content") as? String
                    
                    print(content!)
                }
                
            }catch{
                
            }
            
            
        } else {
            //ここはえりこさんに確認する
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
        print("sampleだよ〜ん")
//        tapSave()
//        read()
        
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
