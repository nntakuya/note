////
////  SecondViewController.swift
////  SlideMenuControllerSwift
////
////  Created by 仲松拓哉 on 11/02/2018.
//
//import UIKit
//
//class SecondViewController: UIViewController {
//
//    //(ModalView)UITextViewのインスタンスを生成
//    let textView: UITextView = UITextView()
//
//    override func viewDidLoad() {
//
//        super.viewDidLoad()
//
//        self.view.backgroundColor = UIColor.white
//
//        //テキストビューを追加
//        createText()
//    }
//
////    ==================================
////　　　　  UITextViewの設定
////    ==================================
//
//    func createText(){
//        //textViewのイチとサイズを設定
//        textView.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height)
//
//        //textViewにジェスチャーイベントを追加
//        downSwipe()
//
//        //テキストを設定
//        textView.text = "入力してください"
//
//        //フォントの大きさを設定
//        textView.font = UIFont.systemFont(ofSize:20.0)
//
//        //textViewの枠線の太さを設定
//        textView.layer.borderWidth = 1
//
//        //枠線の色をグレーに設定
//        textView.layer.borderColor = UIColor.lightGray.cgColor
//
//        //テキストを編集できるように設定
//        textView.isEditable = true
//
//        //キーボードに完了ボタンを追加
//        self.setInputAccessoryView()
//        //ビューへ反映
//        self.view.addSubview(textView)
//
//    }
//
//
//
//
////    ==================================
////　　　　    スワイプアクション
////    ==================================
//    func downSwipe(){
//        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(SecondViewController.leftSwipeView(sender:)))  //Swift3
//        // スワイプの方向を指定
//        downSwipe.direction = .down
//        // viewにジェスチャーを登録
//        self.view.addGestureRecognizer(downSwipe)
//
//    }
//    //スワイプ発動時、実行
//    @objc func leftSwipeView(sender: UISwipeGestureRecognizer) {
//        print("Down Swipe")
//        //キーボード閉じる
//        self.textView.resignFirstResponder()
//        //モーダルウィンドウ閉じる
//        self.navigationController?.dismiss(animated: true, completion: nil)
//    }
//
//
////    ==================================
////　　　　  キーボードの完了ボタン作成
////    ==================================
//    func setInputAccessoryView() {
//        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
//        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
//        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
//        // スペーサー
//        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
//                                     target: self, action: nil)
//
//        // 完了ボタン
//        let commitButton = UIBarButtonItem(
//            title: "Done",
//            style: .done,
//            target: self,
//            action: #selector(self.commitButtonTapped(sender:))
//        )
//
//        kbToolBar.items = [spacer, commitButton]
//
//        self.textView.inputAccessoryView = kbToolBar
//    }
//
//
////    =======================================
////　　　　  キーボード・モーダルウィンドウを閉じる
////    =======================================
//    @objc func commitButtonTapped(sender: Any) {
//        //キーボード閉じる
//        self.textView.resignFirstResponder()
//        //モーダルウィンドウ閉じる
//        self.navigationController?.dismiss(animated: true, completion: nil)
//
//        let coreData = ingCoreData()
//        //カテゴリーをCoreDataへインサート
//        coreData.insertCategory(name: textView.text)
//        //CoreDataのデータチェック
//        coreData.readCategoryAll()
//    }
//
//
//
//    //TODO:カテゴリー追加後に、既存のカテゴリーを削除
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//}

