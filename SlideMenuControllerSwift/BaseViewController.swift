///  Created by 仲松拓哉 on 04/02/2018.


import UIKit
import CoreData

class BaseViewController: UIViewController,UITextViewDelegate,UIScrollViewDelegate{
    
    var categoryId = 0
    
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
    
    
//    ==================================
//　　　　 アンダーバーオブジェクト パーツ
//    ==================================
    
//    ======アンダーバー 土台===============
    var TestView = UIView()

//    ======スクロールバーオブジェクト========
    var scrollView:UIScrollView = UIScrollView()
    // スクロールバーのサイズ
    let sWidth: CGFloat = 0.0
    let sHeight: CGFloat = 0.0
    // ボタンのX,Y座標
    let sPosX: CGFloat = 0.0
    let sPosY: CGFloat = 0.0
    
    
//    ======＋ボタンオブジェクト=======
    
    
//    ======カテゴリーボタンオブジェクト=======
    var btnCategory: UIButton!
    
//    ======(選択後)カテゴリー表示オブジェクト==
    var DisplayCategoryBoard = UIView() //大枠
    var DisplayCategory = UIButton() //選択されたカテゴリーを表示
//    var DisplayLabel = UILabel() //選択されたカテゴリー名を表示
    
    
    
    
    
//    ====================================================================================================================================================================================================================================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        CreatePostView()//メインのメモ機能
        
        createTabBar()//アンダーバー作成
        //カテゴリーボタンの追加
        addBtnCategory()
    
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
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated)
        keyboardClose()
        
    }
    
    //スクロールオブジェクトのリロード
    func updateScrollBar(){
        DeleteScrollView(scv: scrollView)//スクロールオブジェクト削除
        scrollView = UIScrollView()
        viewScroll()
        addBtnCategory()//カテゴリーボタンの追加
    }
    
    
    
//    ==========================================
//　　　　 postViewのスクロール機能
//    ==========================================
    func CreatePostView(){
        self.view.backgroundColor = UIColor(displayP3Red: 250/250, green: 250/250, blue: 248/250, alpha: 1)
        
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
        postView.backgroundColor = UIColor(displayP3Red: 250/250, green: 250/250, blue: 248/250, alpha: 1)
        postView.placeholder = "Input Text"
        
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2 //行間指定
        let attributes = [NSAttributedStringKey.paragraphStyle : style]
        postView.attributedText = NSAttributedString(string: postView.text,attributes: attributes)
        postView.font = UIFont.systemFont(ofSize: 18) //フォントサイズを変更
        
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

    
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            postView.contentInset = UIEdgeInsets.zero
        } else {
            postView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height + 80, right: 0)
        }
        postView.scrollIndicatorInsets = postView.contentInset
        let selectedRange = postView.selectedRange
        postView.scrollRangeToVisible(selectedRange)
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
        
        
        TestView.backgroundColor = UIColor.white
        //アンダーバーにシャドウを追加
        TestView.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
        
        
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
        let bWidth: CGFloat = 40
        let bHeight: CGFloat = 40
        
        // ボタンのX,Y座標.
//        let posX: CGFloat = self.view.frame.width / 90
        let posX: CGFloat = (self.view.frame.width / 90 + 60 - bWidth) / 2
        let posY: CGFloat = (50 - bHeight) / 2 //50はアンダーバーの高さ

        // ボタンの設置座標とサイズを設定する.
        myButton.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        myButton.backgroundColor = UIColor(displayP3Red: 201/250, green: 80/250, blue: 63/250, alpha: 1)
        myButton.layer.masksToBounds = true// ボタンの枠を丸くする.
        myButton.layer.cornerRadius = myButton.frame.size.width * 0.5
        
        // タイトルを設定する(通常時).
        myButton.setTitle("＋", for: .normal)
        myButton.setTitleColor(UIColor.white, for: .normal)
        
        myButton.tag = 0// ボタンにタグをつける.
        
        // イベントを追加する
        myButton.addTarget(self, action: #selector(self.onClickPlusButton(sender:)), for: .touchUpInside)
        return myButton
    }
    
    //プラスボタンプッシュ時のファンクション
    @objc func onClickPlusButton(sender: UIButton) {
        let modalViewController = ModalViewController()
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = self
        //下記コードはスクロールオブジェクト更新のため
        modalViewController.bvc = self //modalViewControllerにBaseViewControllerオブジェクトプロパティを作成
        present(modalViewController, animated: true, completion: nil)
        
        
        //カテゴリー表示欄を削除
        
        
        UIView.animate(withDuration: 0.8, delay: 0.0,  animations: {}, completion: {
            _ in
            self.DisplayCategoryBoard.removeFromSuperview()
            self.postScrollView.frame = CGRect(x: 0, y: 70, width: self.view.bounds.width, height: self.view.bounds.height)
        })
        
        
        
    }
    
    
    @objc func DownSwipePostView(sender: UISwipeGestureRecognizer) {
        //キーボード閉じる
        postView.resignFirstResponder()
    }
    
    
//    ============================================
//　　　　   ボタン(カテゴリー選択)作成
//    ============================================
    private func btnCategory(inputCategory :String , categoryId:Int)->UIButton{
        
        //関数にデータが入った場合にのみ、そのデータを変数へ
        var text = inputCategory
        
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
        var bcWidth: CGFloat = width.width + 15
        
        if bcWidth < 45 {
            bcWidth = 45
        }
        
        
        let bcHeight: CGFloat = 40
        
        // ボタンのX,Y座標
        let bcPosX: CGFloat = 0
        let bcPosY: CGFloat = 0
        
        // ボタンの設置座標とサイズを設定する.
        btnCategory.frame = CGRect(x: bcPosX, y: bcPosY, width: bcWidth, height: bcHeight)
        
        // ボタンの背景色を設定.
        btnCategory.backgroundColor = UIColor(displayP3Red: 238/250, green: 188/250, blue: 64/250, alpha: 1)
        
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
    
    
    
//    ==================================
//　　　　  スクロールオブジェクト作成
//    ==================================
    private func viewScroll()->UIScrollView{
        scrollView.backgroundColor = UIColor.white
        
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
    func addBtnCategory(){
        var scWidth = 0 //ボタンのx座標
        let scHight = 5 //ボタンのy座標
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
            catBtn.frame.origin = CGPoint(x: scWidth, y: scHight)
            //オブジェクトをスクロールバーへ追加
            scrollView.addSubview(catBtn)
            //オブジェクト全体のwidthを取得(ボタンオブジェクトの間のスペース確保)
            scWidth += Int(catBtn.layer.bounds.width) + 10
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
    
    
    
//    ============================================
//　　　　   選択されたカテゴリー名を表示（画面うえ）
//    ============================================
    
    @objc func onClickCategoryButton(sender: UIButton) {
        //ビューの位置をモーダルウィンドウの下に表示する
        
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
        DisplayCategory = UIButton()//初期化
        
        DisplayCategoryBoard.frame = CGRect(x: 0, y: 67, width: self.view.bounds.width, height: 50)
        DisplayCategoryBoard.backgroundColor = UIColor(displayP3Red: 250/250, green: 250/250, blue: 248/250, alpha: 1)
        
        
        let catgoryName = categoryData["name"] as! String
        
        let font = UIFont(name: "Hiragino Kaku Gothic ProN", size: 18)
        //以下のコマンドで文字列の横幅を取得
        // width.widthでInt型でデータを取得出来る
        let width = catgoryName.size(withAttributes: [NSAttributedStringKey.font : font])
        
        // ボタンのサイズ
        var bcWidth: CGFloat = width.width + 15
        
        if bcWidth < 45 {
            bcWidth = 45
        }
        
        
        let bcHeight: CGFloat = 40
        
        // ボタンのX,Y座標
        let bcPosX: CGFloat = 8
        let bcPosY: CGFloat = 11
        
        // ボタンの設置座標とサイズを設定する.
        DisplayCategory.frame = CGRect(x: bcPosX, y: bcPosY, width: bcWidth, height: bcHeight)
        
        // ボタンの背景色を設定.
        DisplayCategory.backgroundColor = UIColor(displayP3Red: 238/250, green: 188/250, blue: 64/250, alpha: 1)
        
        // ボタンの枠を丸くする.
        DisplayCategory.layer.masksToBounds = true
        
        // コーナーの半径を設定する.
        DisplayCategory.layer.cornerRadius = 20.0
        
        
        // タイトルを設定する(通常時).
        DisplayCategory.setTitle(catgoryName, for: .normal)
        DisplayCategory.setTitleColor(UIColor.white, for: .normal)
        
        DisplayCategoryBoard.addSubview(DisplayCategory)
        self.view.addSubview(DisplayCategoryBoard)
        
        //TODO:このカテゴリー表示オブジェクト作成関数とは別に、表示関数を作成し、その中に以下のコードを組み込む
        categoryId = categoryData["id"] as! Int //インサートするカテゴリーを更新
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
//    =======================================
//　　　　    キーボード閉じるアクション
//    =======================================
    //TODO:以下の関数を条件分岐で適切な処理を実行させる必要がある。
    func keyboardClose(){
        postView.resignFirstResponder()
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
                title: "Save",
                style: .done,
                target: self,
                action: #selector(self.MaincommitButtonTapped(sender:))
            )
            kbToolBar.items = [spacer, commitButton]
            postView.inputAccessoryView = kbToolBar
            
        }
    }
    
//    ==================================
//　　　　 Doneボタンの実行処理(Main,Modal)
//    ==================================
    @objc func MaincommitButtonTapped(sender: Any) {
        self.resignFirstResponder()

        tapSave()//インサート
        keyboardClose()//キーボードを閉じる

        postView.text = ""
        
        
        //TODO:カテゴリー表示オブジェクトのアニメーション
        
//        self.transform = self.transform.rotated(by: rotate.rotation)
//        rotate.rotation = 0
        purupuru()
    }
    
    
    func purupuru(){
//        DisplayCategory.transform = self.transform.rotated(by: rotate.rotation)
//        rotate.rotation = 0
        var transRotate = CGAffineTransform()
        
//        UIView.animate(withDuration: 0.2, delay: 0.0,  animations: {
//            let angle = 20 * CGFloat.pi / 180
//            transRotate = CGAffineTransform(rotationAngle: CGFloat(angle));
//            self.DisplayCategory.transform = transRotate
//        }, completion: {
//            _ in
//            let angle = -40 * CGFloat.pi / 180
//            transRotate = CGAffineTransform(rotationAngle: CGFloat(angle));
//            self.DisplayCategory.transform = transRotate
//        })
        UIView.animateKeyframes(withDuration: 1.5, delay: 0.0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1, animations: {
                let angle = 20 * CGFloat.pi / 180
                transRotate = CGAffineTransform(rotationAngle: CGFloat(angle));
                self.DisplayCategory.transform = transRotate
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.2 , relativeDuration: 0.2, animations: {
                let angle = -20 * CGFloat.pi / 180
                transRotate = CGAffineTransform(rotationAngle: CGFloat(angle));
                self.DisplayCategory.transform = transRotate
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.6 , relativeDuration: 0.2, animations: {
                let angle = 0 * CGFloat.pi / 180
                transRotate = CGAffineTransform(rotationAngle: CGFloat(angle));
                self.DisplayCategory.transform = transRotate
            })

//            UIView.addKeyframe(withRelativeStartTime: 1.0 , relativeDuration: 0.2, animations: {
//                let angle = 0 * CGFloat.pi / 180
//                transRotate = CGAffineTransform(rotationAngle: CGFloat(angle));
//                self.DisplayCategory.transform = transRotate
//            })
//
            
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



extension BaseViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,presenting: UIViewController?,source: UIViewController) -> UIPresentationController?{
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
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
        print("SlideMenuControllerDelegate: rightWillO  pen")
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
