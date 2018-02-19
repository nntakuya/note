//サイドバー
import UIKit

class LeftViewController : UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    //固定項目:"Note","All"
    var menus = ["Note", "All"]
    
    
    var menusTest:[[String:Any]] = [
        [
            "id":Int(),
            "name":"Note"
        ],
        [
            "id":Int(),
            "name":"All"
        ]
    ]
    

    var mainViewController: UIViewController!
    var AllViewController: UIViewController!
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
        let AllViewController = storyboard.instantiateViewController(withIdentifier: "AllViewController") as! AllViewController
        self.AllViewController = UINavigationController(rootViewController: AllViewController)
        
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
            self.slideMenuController()?.changeMainViewController(self.AllViewController, close: true)
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
        
        
        //TODO:以下のカテゴリー一覧を文字列で管理している
        //それをオブジェクトで管理するように書き換える？
        //"name"カラムだけでなく、"id"も追加するべき？
        
        //CoreDataにあるカテゴリー名を全件取得
        for inputCategory in inputCategories{
            let addNameCategory = inputCategory["name"] as! String
            let addIdCategory = inputCategory["id"] as! Int
            
            menus.append(addNameCategory)
            
            //(テスト用)サイドバーのセルにidのプロパティを追加したい
            let add_menus = ["id":addIdCategory,"name":addNameCategory] as [String : Any]
            menusTest.append(add_menus)
        }
        //テーブルの再描画
        tableView.reloadData()
    }
}

//遷移先を指定している
extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        for list in menus{
//            print(list)
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
    //セルの数指定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    //セル表示データを指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        for list in menus{
            if (list == "Note" || list == "All"){
                //BaseTableViewCellというTableViewCellを継承されたクラスを作成
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                
                cell.setData(menus[indexPath.row])
                return cell
            }
            //"Note"と"All"以外にカテゴリーIDを振る
            else{
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                //TODO:menusTestのディクショナリからidとnameを取得し、cellのプロパティにそれぞれ当てはめる
                cell.category_id = menusTest[indexPath.row]["id"] as! Int
                cell.setData(menusTest[indexPath.row]["name"])
                
//                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
