//サイドバー
import UIKit

class LeftViewController : UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    //TODO:配列を"Note"と"All"以外、CoreDataに保存されているカテゴリー名から追加する処理にする(ファンクション作成済)
    //固定項目:"Note","All"
    var menus = ["Note", "All"]
    
    //TODO:カテゴリー名に応じた名前のviewControllerを生成する
    var mainViewController: UIViewController!
    var swiftViewController: UIViewController!
    var OthersViewController: UIViewController!
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //menusの配列にCoreDataのカテゴリー名を追加する
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swiftViewController = storyboard.instantiateViewController(withIdentifier: "SwiftViewController") as! SwiftViewController
        self.swiftViewController = UINavigationController(rootViewController: swiftViewController)
        
        let OthersViewController = storyboard.instantiateViewController(withIdentifier: "OthersViewController") as! OthersViewController
        self.OthersViewController = UINavigationController(rootViewController: OthersViewController)
        
        self.tableView.registerCellClass(BaseTableViewCell.self)
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addListCategory()
//        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    //目的:サイドバーのカテゴリー項目から詳細画面へ遷移
    func changeViewController(num: Int) {
        if menus[num] == "Note"{
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        }else if(menus[num] == "All"){
            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        }else{
            self.slideMenuController()?.changeMainViewController(self.OthersViewController, close: true)
        }
    }
    
    
    //カテゴリー一覧を配列に組み込むファンクション
    func addListCategory(){
        //CoreDataオブジェクト作成
        let categoryDatas = ingCoreData()
        //CoreDataからカテゴリーデータを全件取得
        let inputCategories = categoryDatas.readCategoryAll()
        //menus配列をイニシャライズ
        menus = ["Note", "All"]
        
        //CoreDataにあるカテゴリー名を全件取得
        for inputCategory in inputCategories{
            let addCategory = inputCategory["name"] as! String
            menus.append(addCategory)
        }
        //テーブルの再描画
        tableView.reloadData()
    }
}


//TODO:なぜextensionが上手くいってないのか
// └ 上記でセットしているfunctionがなぜか反応しない
//遷移先を指定している
extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        for list in menus{
            print(list)
            if (list == "Note" || list == "All"){
                return BaseTableViewCell.height()
            }else{
                return 60
            }
        }
        
        return CGFloat()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.changeViewController(num: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
        }
    }
}


//以下は、サイドバーのビューの体裁を整えている。
extension LeftViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        for list in menus{
            if (list == "Note" || list == "All"){
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                print(cell)
                cell.setData(menus[indexPath.row])
                return cell
            }else{
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                print(cell)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
