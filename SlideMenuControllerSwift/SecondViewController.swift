//
//  SecondViewController.swift
//  SlideMenuControllerSwift
//
//  Created by 仲松拓哉 on 11/02/2018.



import UIKit

class SecondViewController: UIViewController {
    
    //UITextViewのインスタンスを生成
    let textView: UITextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        //テキストビューを追加
        createText()
        
        //(テスト用)戻るButtonを生成.
//        backBtn()
        
    }
    
    

//    ==================================
//　　　　  UITextViewの設定
//    ==================================
    
    func createText(){
        
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
        
        //キーボードに完了ボタンを追加
        self.setInputAccessoryView()
        //ビューへ反映
        self.view.addSubview(textView)
        
    }
    
    
//    ==================================
//　　　　  キーボードの完了ボタン作成
//    ==================================
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
        
        self.textView.inputAccessoryView = kbToolBar
    }
    
    
//    =======================================
//　　　　  キーボード・モーダルウィンドウを閉じる
//    =======================================
    @objc func commitButtonTapped(sender: Any) {
        //キーボード閉じる
        self.textView.resignFirstResponder()
        //モーダルウィンドウ閉じる
        self.navigationController?.dismiss(animated: true, completion: nil)
        let coreData = ingCoreData()
        
        //カテゴリーをCoreDataへインサート
        coreData.insertCategory(name: textView.text)
        //CoreDataのデータチェック
        coreData.readCategoryAll()
        
    }
    
    
    
//    ==========================================
//      （テスト用）モーダルウィンドウ閉じるボタン
//    ==========================================
    func backBtn(){
        let myButton = UIButton()
        myButton.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        myButton.backgroundColor = UIColor.red
        myButton.layer.masksToBounds = true
        myButton.setTitle("もどる", for: UIControlState.normal)
        myButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        myButton.setTitleColor(UIColor.black, for: UIControlState.highlighted)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:200)
        myButton.tag = 1
        myButton.addTarget(self, action: #selector(SecondViewController.onClickMyButton(sender:)), for: .touchUpInside)
        
        // viewにButtonを追加.
        self.view.addSubview(myButton)
    }
//    ==========================================
//      （テスト用）上記付属ファンクション
//    ==========================================
    @objc func onClickMyButton(sender : UIButton){
        // viewを閉じる.
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
