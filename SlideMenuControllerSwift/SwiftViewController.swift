import UIKit
import CoreData

//(仮)"All"のセルとして扱う
//memo:
//・ArticleエンティティのカテゴリーIDが0のデータを取得したい
//・サイドバーから各セルに対し、カテゴリーIDを割り振る必要がある。
//・最初は(カテゴリーID = 0)つまり、Allだと仮定して進める


//やるべきこと
//1.CoreDataに保存されているデータを一度全部消す
//2.CoreDataのエンティティにidカラム,saveDateを追加
//2-1.配列の初期化をセット
//2-2.Function "read""create"にそれぞれ新しいカラムを追加
//2-3.

// └ idにインクリ機能をつくる
//  └ managedObjectのプロパティを保存して、更新
//3.カテゴリー別のデータを取得（データの絞込）のコードを追加

//3.サンプルデータを挿入
//4.削除機能



class SwiftViewController: UIViewController,UITableViewDelegate,UITableViewDataSource   {
    
    @IBOutlet weak var myTableView: UITableView!
    
    //表示したいセルの配列を初期化
    var artTitle:[String] = []
    
    //何行目か保存されていないときを見分けるための-1を代入
    var selectedRowIndex = -1
    
    //カテゴリーがALLだと仮定
    var categoryId = 0
    
    /////////////////// テーブルについて /////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artTitle.count
    }
    
    //TODO:セルのビュー調整
    //TODO:データのread等
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //文字列を表示するセルの取得(セルの再利用)
        // セルは一つのオブジェクト。なので、そのオブジェクトを一つ取得する
        // 一つのオブジェクトを表示したい項目の数だけ用意すると、とんでもないメモリを消費するので、メモリを節約するために、使いまわせるセルを使いまわす。
        //3-1.myTableViewにはストーリーボード上でCellを配置しておく
        //3-2. 配置したセルには"Cell#という名前をつける
        //      identifierの欄に記述
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // cellはUITableViewCellオブジェクト
        // テキストラベル
        cell.textLabel?.textColor = UIColor.orange
        
        //表示したい文字の設定
        //indexPath.row 今表示しようとしている行の行番号。0からスタート
        //        cell.textLabel?.text = "\(indexPath.row)行目"
        cell.textLabel?.text = artTitle[indexPath.row]
        print("cell")
        
        //文字設定したセルを返す
        return cell
    }
    
    
    //問題:以下のファンクションが起動していない
    //セルをタップした時発動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 選択された行番号をメンバ変数に保存したい(セグエを使って画面移動する時に発動するメソッドが違うもののため、そこで使えるようにする)
        selectedRowIndex = indexPath.row
        
        //セグエの名前を指定して、画面遷移処理を発動(つける名前はshowDetail。ストーリーボード上でidtifierで指定)
        //下のoverride で定義している prepare関数 と下のpreformSegueが結びついている
        performSegue(withIdentifier: "Detail", sender: nil)
        
    }
    
    /////////////////// セルについて /////////////////////////////
    //セルのスワイプ表示（表示）
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            artTitle.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    //セルのスワイプ表示（デザイン）
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            self.artTitle.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    ///////////////////// 画面遷移 ////////////////////////////
    
    
    //セグエを使って画面遷移してる時発動
    //上のtableView関数で定義されているperformSegue関数を使用することで使用が可能になる。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //移動先の画面のインスタンスを取得
        //segue.destination : セグエが持っている、目的地（移動先の画面）
        //as ダウンキャスト変換 広い範囲から限定したデータ型へ型変換するときに使用
        //as! 型変換して、オプショナル型からデータを取り出す
        var dvc:DetailViewController = segue.destination as! DetailViewController
        
        //移動先の画面のプロパティに、選択された行番号を代入（これで,DetailViewControllerに選択された行番号が渡せる)
        dvc.passedIndex = selectedRowIndex
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:tableviewの選択されたセルの値を取得するファンクションが機能していない
//        self.tableView.allowsSelection = true
        
        read()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
    
    ///////////////////// CoreData操作 ////////////////////////////
    
    
    //TODO:リファクタリングする
    
    
    func read(){
        //AppDelegateを使う用意をする
        let appD: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appD.persistentContainer.viewContext
        
        //どのエンティティを操作するためのオブジェクトを作成
        let query: NSFetchRequest<Article> = Article.fetchRequest()
        
        
        //絞り込み検索
        let namePredicte = NSPredicate(format: "category_id = %d", categoryId)
        query.predicate = namePredicte
   
        
        do{
            //データを一括取得
            print("test1")
            let fetchResult = try viewContext.fetch(query)
            print("test2")
            //データの取得
            for result: AnyObject in fetchResult{
                let content: String? = result.value(forKey: "content") as? String
                let saveDate: Date? =  result.value(forKey: "saveDate") as? Date
                let category: Int64 = (result.value(forKey: "category_id") as? Int64)!
                
                print("test")
                
                let df = DateFormatter()
                df.dateFormat = "yyyy/MM/dd"
                df.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
                let date = df.string(from: saveDate!)
                
                artTitle.append(content!)
                print(content!)
                print(date)
                print(category)
            }
        }catch{
            print("エラーだよ")
        }
    }
    
    
    
    //(テスト)絞り込み
//    func readTest(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        let predicate = NSPredicate(format: "id = %d", 1)
//        fetchRequest.predicate = predicate
//
//        // 検索
//        do {
//            let users = try appDelegate.managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
//            for user in users {
//                print("\(user.id) \(user.name)")
//            }
//        } catch let error as NSError {
//            print(error)
//        }
//    }
    
    
    
    
    
    
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







