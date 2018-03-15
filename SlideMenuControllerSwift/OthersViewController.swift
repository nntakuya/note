
import UIKit
import CoreData

class OthersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource   {
    
    @IBOutlet weak var myTableView: UITableView!
    //表示したいセルの配列を初期化
    var artInfo:[[String:Any]] = []
    
    //何行目か保存されていないときを見分けるための-1を代入
    var selectedRowIndex = -1
    //カテゴリーがALLだと仮定
    var categoryId = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //文字列を表示するセルの取得
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let cell = OtherTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        //表示したい文字の設定
        cell.textLabel?.text = artInfo[indexPath.row]["content"] as? String
        
        cell.contentView.backgroundColor = UIColor(displayP3Red: 250/250, green: 250/250, blue: 248/250, alpha: 1)
        tableView.backgroundColor = UIColor(displayP3Red: 250/250, green: 250/250, blue: 248/250, alpha: 1)
        
        //文字設定したセルを返す
        return cell
    }
    
    //セルをタップした時発動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択されたセルの番号を取得
        selectedRowIndex = indexPath.row
        
        //セグエの名前を指定して、画面遷移処理を発動(つける名前はshowDetail。ストーリーボード上でidtifierで指定)
        performSegue(withIdentifier: "categoryDetail", sender: nil)
    }
    

    //セルのスワイプ表示（デザイン）
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) -> Void in
            
            //指定されたIDのメモデータをCoreDataから削除
            self.selectedRowIndex = indexPath.row
            let DeleteCoreData = ArticleCoreData()
            let delDate = self.artInfo[self.selectedRowIndex]["saveDate"]
            DeleteCoreData.Delete(date: delDate!)
            
            //ビューから指定されたセルを削除
            self.artInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OtherTableViewCell.height()
    }
    
    
    ///////////////////// 画面遷移 ////////////////////////////
    //セグエを使って画面遷移してる時発動
    //上のtableView関数で定義されているperformSegue関数を使用することで使用が可能になる。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cdavc:CategoryDetailArticleViewController = segue.destination as! CategoryDetailArticleViewController
        
        //移動先の画面のプロパティに、選択された行番号を代入
        cdavc.passedIndex = selectedRowIndex
        
        //TODO:DetailにsaveDateの値を渡す
        cdavc.saveDate = artInfo[selectedRowIndex]["saveDate"] as! Date
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.reloadData()

        
        
        //TODO:テスト
        myTableView.registerCellClass(OtherTableViewCell.self)
        UINavigationBar.appearance().barTintColor = UIColor(displayP3Red: 250/250, green: 250/250, blue: 248/250, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //ページが読み込まれた時に、CoreDataからデータを引っ張るｚ
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        //サイドバーで指定されたcategoryIdをグローバル変数から取得
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        categoryId = appDelegate.categoryId
        
        
        //配列を初期化
        artInfo = []
        read()
        
        let categoryData = ingCoreData()
        let selectedCategory = categoryData.readCategory(id: categoryId)
        
        self.navigationItem.title = selectedCategory["name"] as? String
        // フォント種をTime New Roman、サイズを10に指定
        //        self.navigationController?.navigationBar.titleTextAttributes
        //            = [NSAttributedStringKey.font: UIFont(name: "Times New Roman", size: 15)!]
        
        
        
        myTableView.reloadData()
        
        
        //セグエから
            if let indexPathForSelectedRow = myTableView.indexPathForSelectedRow {
            myTableView.deselectRow(at: indexPathForSelectedRow, animated: true)
        }
    }
    
    ///////////////////// CoreData操作 ////////////////////////////
    func read(){
        //AppDelegateを使う用意をする
        let appD: AppDelegate = UIApplication.shared.delegate as! AppDelegate

        let viewContext = appD.persistentContainer.viewContext

        //どのエンティティを操作するためのオブジェクトを作成
        let query: NSFetchRequest<Article> = Article.fetchRequest()


        //絞り込み検索
        //カテゴリーIDをキーにCoreDataを検索
        let namePredicte = NSPredicate(format: "category_id = %d", categoryId)
        query.predicate = namePredicte


        do{
            //データを一括取得
            let fetchResult = try viewContext.fetch(query)

            //データの取得
            for result: AnyObject in fetchResult{
                let content: String? = result.value(forKey: "content") as? String
                let saveDate: Date? =  result.value(forKey: "saveDate") as? Date
                let category: Int64 = (result.value(forKey: "category_id") as? Int64)!

                let dic = ["content":content!,"saveDate":saveDate!,"categoryId":category] as [String : Any]

                artInfo.append(dic)
            }
        }catch{
            print("エラーだよ")
        }
    }
}

