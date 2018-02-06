import UIKit
import CoreData

//(仮)"All"のセルとして扱う

class SwiftViewController: UIViewController,UITableViewDelegate,UITableViewDataSource   {
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    //表示したいセルの配列を初期化
    var artTitle:[String] = []
    
    //何行目か保存されていないときを見分けるための-1を代入
    var selectedRowIndex = -1
    
    
    
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
        //タップされた行の番号
        
        print("\(artTitle[indexPath.row])がタップされました")
        
        // 選択された行番号をメンバ変数に保存したい(セグエを使って画面移動する時に発動するメソッドが違うもののため、そこで使えるようにする)
        selectedRowIndex = indexPath.row
        
        //セグエの名前を指定して、画面遷移処理を発動(つける名前はshowDetail。ストーリーボード上でidtifierで指定)
        //下のoverride で定義している prepare関数 と下のpreformSegueが結びついている
        performSegue(withIdentifier: "Detail", sender: nil)
        
    }
    
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
    
    
    //TODO:リファクタリングする
    func read(){
        //AppDelegateを使う用意をする
        let appD: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if #available(iOS 10.0, *) {
            let viewContext = appD.persistentContainer.viewContext
            
            //どのエンティティを操作するためのオブジェクトを作成
            let query: NSFetchRequest<Article> = Article.fetchRequest()
            
            do{
                //データを一括取得
                let fetchResult = try viewContext.fetch(query)
                
                //データの取得
                for result: AnyObject in fetchResult{
                    let content: String? = result.value(forKey: "content") as? String
                    
                    artTitle.append(content!)
                    print(content!)
                }
                
            }catch{
            }
            
        } else {
            //ここはえりこさんに確認する
        }
    }
    
}







