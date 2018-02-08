//
//  DetailViewController.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 05/02/2018.
//  Copyright © 2018 Yuji Hato. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController,UITextViewDelegate {
    
    
    @IBOutlet weak var postView: UITextView!
    
    //セル一覧から選択されたセルのsaveDateを取得
    var saveDate = Date()
    
    //表示したいセルの配列を初期化
    var artInfo:[String:Any] = [
            "content":String(),
            "saveDate":Date(),
            "categoryId":Int()
    ]
    
    //選択された行番号が受け渡されるプロパティ
    var passedIndex = -1 //渡されないことを判別するために-1を代入

    override func viewDidLoad() {
        super.viewDidLoad()

        //CoreDataからデータを取得し、artTitle配列にデータ挿入
        read()
        
        //TODO:下記の書き方だと、おそらく想定の配列のデータの中身を取得出来ない可能性がある気がする
        print(artInfo)
        postView.text = artInfo["content"] as! String
        
        //TODO:下記にノートの初期設定を書く
        //行間指定
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        let attributes = [NSAttributedStringKey.paragraphStyle : style]
        postView.attributedText = NSAttributedString(string: postView.text,attributes: attributes)
        
        //表示テキストのフォントサイズを変更
        postView.font = UIFont.systemFont(ofSize: 16)
        
        self.setInputAccessoryView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //TODO:以下saveDataをkeyにCoreDataからデータを引っ張る

    func read(){
        //AppDelegateを使う用意をする
        let appD: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appD.persistentContainer.viewContext
        
        //どのエンティティを操作するためのオブジェクトを作成
        let query: NSFetchRequest<Article> = Article.fetchRequest()
        
        
        //絞り込み検索
        //カテゴリーIDをキーにCoreDataを検索
        let namePredicte = NSPredicate(format: "saveDate = %@", saveDate as CVarArg)
        query.predicate = namePredicte
        
        
        do{
            //データを一括取得
            let fetchResult = try viewContext.fetch(query)
            
            //データの取得
            for result: AnyObject in fetchResult{
                artInfo["content"] = result.value(forKey: "content") as? String
                artInfo["saveDate"] =  result.value(forKey: "saveDate") as? Date
                artInfo["categoryId"] = (result.value(forKey: "category_id") as? Int64)!
                
                print(artInfo)
            }
        }catch{
            print("エラーだよ")
        }
    }
}
