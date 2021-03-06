
import UIKit
import CoreData

class AllViewController: UIViewController,UITableViewDelegate,UITableViewDataSource   {
    
    @IBOutlet weak var myTableView: UITableView!
    
    //表示したいセルの配列を初期化
    var artInfo:[[String:Any]] = []
    
    //何行目か保存されていないときを見分けるための-1を代入
    var selectedRowIndex = -1
    //カテゴリーがALLだと仮定
    var categoryId = 0
    
    /////////////////// テーブルについて /////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artInfo.count
    }
    
    //TODO:セルのビュー調整
    //TODO:データのread等
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //文字列を表示するセルの取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //表示したい文字の設定
        cell.textLabel?.text = artInfo[indexPath.row]["content"] as? String
        
        //文字設定したセルを返す
        return cell
    }
    
    //セルをタップした時発動
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //選択されたセルの番号を取得
        selectedRowIndex = indexPath.row
        
        //セグエの名前を指定して、画面遷移処理を発動(つける名前はshowDetail。ストーリーボード上でidtifierで指定)
        performSegue(withIdentifier: "Detail", sender: nil)
    }
    
    
    //セルのスワイプ表示（デザイン）
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
            
            //指定されたIDのメモデータをCoreDataから削除
            self.selectedRowIndex = indexPath.row
            self.Delete()
            
            //ビューから指定されたセルを削除
            self.artInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        
        return [deleteButton]
    }
    
    
    ///////////////////// 画面遷移 ////////////////////////////
    
    //セグエを使って画面遷移してる時発動
    //上のtableView関数で定義されているperformSegue関数を使用することで使用が可能になる。
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc:DetailViewController = segue.destination as! DetailViewController
        
        //移動先の画面のプロパティに、選択された行番号を代入
        dvc.passedIndex = selectedRowIndex
        
        //TODO:DetailにsaveDateの値を渡す
        dvc.saveDate = artInfo[selectedRowIndex]["saveDate"] as! Date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.reloadData()
    }
    
    //ページが読み込まれた時に、CoreDataからデータを引っ張るｚ
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
        
        //配列を初期化
        artInfo = []
        //CoreDataからArticleデータ全件取得
//        let readArticle = ArticleCoreData()
//        artInfo =  readArticle.readArticleAll() as! [[String : Any]]
        
        read()
        myTableView.reloadData()
    }
    
    ///////////////////// CoreData操作 ////////////////////////////
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
    
    
    //削除機能
    func Delete(){
        //AppDelegateを使う用意をする
        let appD: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appD.persistentContainer.viewContext
        
        //どのエンティティを操作するためのオブジェクトを作成
        let query: NSFetchRequest<Article> = Article.fetchRequest()
        
        //削除するセルのsaveDateをdelIdへ
        let delId = artInfo[selectedRowIndex]["saveDate"] as! Date
        
        //絞り込み検索
        //カテゴリーIDをキーにCoreDataを検索
        let namePredicte = NSPredicate(format: "saveDate = %@", delId as! CVarArg)
        query.predicate = namePredicte
        
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
