
//  Created by 仲松拓哉 on 04/02/2018.

import UIKit
import CoreData

class BaseViewController: UIViewController,UITextViewDelegate,UIScrollViewDelegate{
    
    //メインのメモ機能
    var postView: UITextView = UITextView()
    var postViewX :CGFloat = 0.0
    var postVeiwY :CGFloat = 0.0
    var postViewWidth :CGFloat = 0.0
    var postViewheight :CGFloat = 0.0
    
    //TODO:メモ機能をscrollView内へ
    var postScrollView:UIScrollView = UIScrollView()
    // スクロールバーのサイズ
    var postWidth: CGFloat = 0.0
    var postHeight: CGFloat = 0.0
    // ボタンのX,Y座標
    var postPosX: CGFloat = 0.0
    var postPosY: CGFloat = 0.0
    
    
    //【モーダルウィンドウ】パーツ
    let textView: UITextView = UITextView()//(ModalView)UITextViewのインスタンスを生成
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
    var cuWidth:CGFloat = 0.0//テーブルの横幅
    var cuHeight:CGFloat = 0.0//テーブルの縦幅
    
    var categoryInfo:[[String:Any]] = []//表示したいセルの配列を初期化
    var selectedRowIndex = -1//何行目か保存されていないときを見分けるための-1を代入
    var categoryId = 0//カテゴリーIDのデフォルト値（カテゴリー：All）を "0" とする
    
    //サイズフラグ
    var firstResize :Int = 0
    
    
    
//    =========================================
//　　　　   モーダルウィンドウボタン
//    =========================================
    //(Btn)CreateCategoryアクション
    @IBAction func BtnCreaateCategory(_ sender: UIButton) {
        UIView.animate(withDuration: 0, delay: 0,  animations: {
            self.CustomCategoryView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
        
        keyboardClose()
    }
    
    //(Btn)CustomCategoryアクション
    @IBAction func BtnCustomCategory(_ sender: UIButton) {
        UIView.animate(withDuration: 0.0, delay: 0.0,  animations: {
            self.CustomCategoryView.frame = CGRect(x: 0, y: 150, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
        keyboardClose()
    }

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
    
//    ==================================
//　　　　 (選択後)カテゴリー表示オブジェクト
//    ==================================
    var DisplayCategoryBoard = UIView() //大枠
    var DisplayCategory = UIView() //選択されたカテゴリーを表示
    var DisplayLabel = UILabel() //選択されたカテゴリー名を表示
    
    
    
    
    
    
//    ====================================================================================================================================================================================================================================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        CreatePostView()//メインのメモ機能
//        makePostScoll()

//        read()
        
        createTabBar()//アンダーバー作成
        //カテゴリーボタンの追加
        addBtnCategory()
        
        //viewTable カテゴリー一覧の並び替え
        CusCategoryTable.reorder.delegate = self as? TableViewReorderDelegate
        //【ModalView】
        cretaModalWindow()//create
        customModalWindow()//custom
        addListCategory()//CoreDataからテーブルデータを取得
    
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
        
        updateScrollBar()//カテゴリーボタンの追加
        
        //test
        testNotificationForViewwillAppear()
        
        
    }
    
    //TODO:改善必要
    // └ サイドバーの表示がされる際に、キーボードを閉じる
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        keyboardClose()
        
        //test
        testNotificationForViewwillDisAppear()
    }
    
    //スクロールオブジェクトのリロード
    func updateScrollBar(){
        DeleteScrollView(scv: scrollView)//スクロールオブジェクト削除
        scrollView = UIScrollView()
        viewScroll()
        addBtnCategory()//カテゴリーボタンの追加
    }
    
    
    
//    ==========================================
//　　　　 テスト：postViewにスクロール機能追加
//    ==========================================
    func CreatePostView(){
        
        //以下コンテンツ幅をつまりpostViewの高さを少し大きくする
        //scrollviewの幅は画面全体の幅へ
        // ボタンのX,Y座標
        postPosX = 0
        postPosY = 70
        
        postWidth = self.view.bounds.width
        postHeight = self.view.bounds.height
        
        
        postScrollView.frame = CGRect(x: postPosX, y: postPosY, width: postWidth, height: postHeight)
        
        postScrollView.bounces = true//スクロールの跳ね返り
        
        postScrollView.showsHorizontalScrollIndicator = false //スクロールバー非表示
        
        postScrollView.delegate = self// Delegate を設定
        
        
        //1.textViewの高さをずらす
        postViewX = 0
        postVeiwY = 0
        postViewWidth = self.view.bounds.width
        postViewheight = self.view.bounds.height + 5
        postView.frame = CGRect(x: postViewX, y: postVeiwY, width: postViewWidth, height: postViewheight)
        postView.keyboardDismissMode = .interactive //textfieldのUIをインタラクティブへ
        
        //サンプルテキスト作成
//        postView.text = "sample text"
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2//行間指定
        let attributes = [NSAttributedStringKey.paragraphStyle : style]
        postView.attributedText = NSAttributedString(string: postView.text,attributes: attributes)
        postView.font = UIFont.systemFont(ofSize: 18)//フォントサイズを変更
        
        //keyboard上の"Done"ボタンセット
        //"Main"はデフォルト画面のtextview画面
        setInputAccessoryView(viewName: "Main")
        
        
        
        //スクロールビューの中身の大きさを指定
        postScrollView.contentSize = CGSize(width: postViewWidth, height: postViewheight)
        
        postScrollView.addSubview(postView)
        self.view.addSubview(postScrollView)

        
    }
    
    /* 以下は UITextFieldDelegate のメソッド */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロール中の処理
        print("didScroll")
        postView.resignFirstResponder()
    }

    
    
    
    //カスタムテーブルキーボードバグ修正テスト
    //TODO:作業中
    func testNotificationForViewwillAppear() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BaseViewController.keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BaseViewController.keyboardWillHide(_:)) ,
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
    
    //okayu
    @objc func keyboardWillShow(_ notification: Notification) {
        print(#function)
        let info = notification.userInfo!
        
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let topKeyboard = CusCategoryTable.frame.height - keyboardFrame.size.height
        //        // 重なり
        let distance = slideHeight - topKeyboard
        
        print(slideHeight)
        print(topKeyboard)
        

        let LocationCurrentModal = ModalView.frame.origin.y//モーダルウィンドウのy座標取得
        
        //モーダルウィンドウのy座標が0.0の場合、つまりiphone画面上に表示されている場合に、以下のコードを実行する
        if LocationCurrentModal == 0.0 {
//            print("success")
            
            if firstResize == 0{
                print("上")
                //テーブルのscrollView内に余分な高さ(contentOffset)をセット
                if distance >= 0 {
                    CusCategoryTable.contentOffset.y = distance
                }
                
                CusCategoryTable.frame.size.height  = CusCategoryTable.frame.height - keyboardFrame.size.height
                firstResize += 1
                
            }else{
                print("下")
                
                CusCategoryTable.contentOffset.y = 0
                
                CusCategoryTable.frame.size.height  = self.view.bounds.height - 150
//                CusCategoryTable.reloadData()
                //テーブルサイズフラグをオフ(=0)にする
                firstResize = 0
                //            CusCategoryTable.reloadData()
            }
            print(firstResize)
//            slideHeight = 0.0
            
        }
    }
    
    //この解除の部分をどこで解除するのか
    @objc func keyboardWillHide(_ notification: Notification) {
        let info = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        print(#function)
        CusCategoryTable.contentOffset.y = 0
        
        print(firstResize)
        
        CusCategoryTable.frame.size.height  = self.view.bounds.height - 150
        firstResize = 0
        
//        if firstResize == 0{
//            CusCategoryTable.frame.size.height  = CusCategoryTable.frame.height - keyboardFrame.size.height
//            firstResize += 1
//        }else{
//            CusCategoryTable.frame.size.height  = self.view.bounds.height
//            CusCategoryTable.reloadData()
//            //テーブルサイズフラグをオフ(=0)にする
//            firstResize = 0
//            //            CusCategoryTable.reloadData()
//        }
//
        
    }
    
    
    
    

    
    
    
    
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            postView.contentInset = UIEdgeInsets.zero
//            CusCategoryTable.contentInset = UIEdgeInsets.zero
        } else {
            postView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 80, right: 0)
//            CusCategoryTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        postView.scrollIndicatorInsets = postView.contentInset
        let selectedRange = postView.selectedRange
        postView.scrollRangeToVisible(selectedRange)
        
//        CusCategoryTable.scrollIndicatorInsets = CusCategoryTable.contentInset
//        let selectedRangeTable = CusCategoryTable.selectedRange
//        CusCategoryTable.scrollRangeToVisible(selectedRangeTable)
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
        self.view.bringSubview(toFront: ModalView)
    }
    
    
//    ==================================
//　　　　 モーダルウィンドウ作成(custom)
//    ==================================
    func customModalWindow(){
        //隠れた状態
        CustomCategoryView.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height)
        AjustTableLayout()//テーブルのサイズを調整
        
        //スワイプジェスチャー
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(BaseViewController.DownSwipeView(sender:)))  //Swift3
        downSwipe.direction = .down// スワイプの方向を指定
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
        
        keyboardClose()
    }
    
    
//    =========================================
//　　　　  (モーダルウィンドウ)UITextViewの設定
//    =========================================
    func createText()->UITextView{
        //textViewのイチとサイズを設定
        textView.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height)
        textView.placeholder = "新規カテゴリーを入力"
        textView.font = UIFont.systemFont(ofSize:20.0)//フォントの大きさを設定
        textView.layer.borderWidth = 1//textViewの枠線の太さを設定
        textView.layer.borderColor = UIColor.lightGray.cgColor//枠線の色をグレーに設定
        textView.isEditable = true//テキストを編集できるように設定
        setInputAccessoryView(viewName: "Modal")//キーボードに完了ボタンを追加
        
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
        TestView = UIView.init(frame: CGRect(x: posX, y: posY, width: bWidth, height: bHeight))
        
        TestView.backgroundColor = UIColor.red//色指定
        
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
        myButton.backgroundColor = UIColor.blue// ボタンの背景色を設定.
        myButton.layer.masksToBounds = true// ボタンの枠を丸くする.
        myButton.layer.cornerRadius = 20.0// コーナーの半径を設定する.
        
        // タイトルを設定する(通常時).
        myButton.setTitle("+", for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        
        myButton.tag = 0// ボタンにタグをつける.
        
        // イベントを追加する
        myButton.addTarget(self, action: #selector(self.onClickPlusButton(sender:)), for: .touchUpInside)
        return myButton
    }
    //プラスボタンプッシュ時のファンクション
    @objc func onClickPlusButton(sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0.0,  animations: {
            self.ModalView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    


    
    //TODO:下記のキーボードを閉じるファンクションをインタラクティブに設定
    @objc func DownSwipePostView(sender: UISwipeGestureRecognizer) {
        //キーボード閉じる
        postView.resignFirstResponder()
    }
    
    
//    ============================================
//　　　　   ボタン(カテゴリー選択)作成
//    ============================================
    private func btnCategory(inputCategory :String , categoryId:Int)->UIButton{
        
        var text = "サンプル"
        //関数にデータが入った場合にのみ、そのデータを変数へ
        text = inputCategory
        
        //カテゴリーIDを取得し、tagとしてセット
        let catId = categoryId
        
        let font = UIFont(name: "Hiragino Kaku Gothic ProN", size: 18)
        //以下のコマンドで文字列の横幅を取得
        // width.widthでInt型でデータを取得出来る
        let width = text.size(withAttributes: [NSAttributedStringKey.font : font])
        
        btnCategory = UIButton()// Buttonを生成する.
        //TODO:ボタンオブジェクトにカテゴリーIDを特定するキーを付けたい
        btnCategory.tag = catId //カテゴリーIDをButtonオブジェクトのtagにセット
        
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
        
        // イベントを追加する
        btnCategory.addTarget(self, action: #selector(self.onClickCategoryButton(sender:)), for: .touchUpInside)
        
        return btnCategory
    }
//    ============================================
//　　　　   カテゴリーボタン選択アクション
//    ============================================
    @objc func onClickCategoryButton(sender: UIButton) {
        //memo:sender.tagでtagを取得可能
        
        //メモ欄に表示するカテゴリーのスペースを確保
        UIView.animate(withDuration: 0.0, delay: 0.0,  animations: {
            self.postScrollView.frame = CGRect(x: 0, y: 120, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
        
        //選択されたカテゴリー情報を取得
        let readCoreData = ingCoreData()
        let categoryData = readCoreData.readCategory(id: sender.tag)
        
        //postViewの移動したスペースに大枠のViewを作成
        DeleteUIView(scv: DisplayCategoryBoard)//カテゴリー表示欄の初期化
        DisplayCategoryBoard = UIView()//初期化
        DisplayCategory = UIView()//初期化
        DisplayLabel = UILabel()//初期化
        
        DisplayCategoryBoard.frame = CGRect(x: 0, y: 67, width: self.view.bounds.width, height: 50)
        DisplayCategoryBoard.backgroundColor = UIColor.gray

        
        let catgoryName = categoryData["name"] as! String
        DisplayLabel.text = catgoryName
        DisplayLabel.textColor = UIColor.white
        
        let font = UIFont(name: "Hiragino Kaku Gothic ProN", size: 18)
        
        // width.widthでInt型でデータを取得出来る
        let catwidth = catgoryName.size(withAttributes: [NSAttributedStringKey.font : font as Any])
        
        
        DisplayLabel.frame = CGRect(x:DisplayCategory.bounds.height/2 + 4, y:DisplayCategory.bounds.width/2,width: catwidth.width,height: 50)
        
        // ボタンのX,Y座標
        let catX: CGFloat = 10
        let catY: CGFloat = 0
        // ボタンのサイズ
        let catWidth: CGFloat = catwidth.width
        let catHeight: CGFloat = 50
        
        DisplayCategory.layer.masksToBounds = true// ボタンの枠を丸くする.
        DisplayCategory.layer.cornerRadius = 20.0// コーナーの半径を設定する.
        
        DisplayCategory.frame = CGRect(x: catX, y: catY, width: catWidth, height: catHeight)
        DisplayCategory.backgroundColor = UIColor.blue
        
        DisplayCategory.addSubview(DisplayLabel)
        DisplayCategoryBoard.addSubview(DisplayCategory)
        self.view.addSubview(DisplayCategoryBoard)
        
        categoryId = categoryData["id"] as! Int //インサートするカテゴリーを更新
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
        
        scrollView.bounces = false//スクロールの跳ね返り
        
        scrollView.showsHorizontalScrollIndicator = false //スクロールバー非表示
        
        scrollView.delegate = self// Delegate を設定
        
        TestView.addSubview(scrollView)
        
        return scrollView
    }
    
    
//    ========================================================
//　　　　  スクロールオブジェクトへカテゴリーボタン追加機能
//    ========================================================
    //スクロールバーオブジェクトにカテゴリーボタンを追加
    //TODO:ボタンオブジェクトにカテゴリー名もしくは、カテゴリーIDを追加
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
            let btnId = inputCategory["id"] as! Int
            let catBtn =  btnCategory(inputCategory: btnName, categoryId: btnId)//返り値がボタンオブジェクト
            
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
        let subviews = btnCategory.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    
//    =====================================================
//　　　　   　スクロールオブジェクト内 スクロールビュー削除
//    =====================================================
    func DeleteScrollView(scv:UIScrollView) {
        scv.removeFromSuperview()
    }
    
//    =====================================================
//　　　　   　カテゴリー表示欄削除
//    =====================================================
    func DeleteUIView(scv:UIView) {
        scv.removeFromSuperview()
    }

//    =======================================
//　　　　    ジェスチャーイベント(下スワイプ)
//    =======================================
    @IBAction func keyClose(_ sender: UISwipeGestureRecognizer) {
//        postView.resignFirstResponder()
        keyboardClose()
    }
    
    
//    =======================================
//　　　　    キーボード閉じるアクション
//    =======================================
    //TODO:以下の関数を条件分岐で適切な処理を実行させる必要がある。
    func keyboardClose(){
        postView.resignFirstResponder()
        textView.resignFirstResponder()
        CusCategoryTable.reloadData()
        updateScrollBar()//Topメモ欄のスクロールオブジェクトの再読込
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
//        read()//デバッグ用
        keyboardClose()//キーボードを閉じる
    }
    
    @objc func ModalcommitButtonTapped(sender: Any) {
        self.resignFirstResponder()
        
        //CoreData処理
        let coreData = ingCoreData()
        coreData.insertCategory(name: textView.text)//インサート
        coreData.readCategoryAll()//データチェック
        
        keyboardClose()//キーボードを閉じる
        
        //TODO:CustomCategoryテーブルの再読込
        addListCategory()
        
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
