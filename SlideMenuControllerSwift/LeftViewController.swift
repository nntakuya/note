//サイドバー
import UIKit

class LeftViewController : UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    //固定項目:"Note","All"
    var menus:[[String:Any]] = [
        [
            "id":-1,
            "name":"Note"
        ],
        [
            "id":-1,
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
        let view = menus[num]["name"] as! String
        if view == "Note"{
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        }else if(view == "All"){
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
        menus = [
            [
                "id":-1,
                "name":"Note"
            ],
            [
                "id":-1,
                "name":"All"
            ]
        ]
        
        //CoreDataにあるカテゴリー名を全件取得
        for inputCategory in inputCategories{
            let addNameCategory = inputCategory["name"] as! String
            let addIdCategory = inputCategory["id"] as! Int
            
            let add_menus = ["id":addIdCategory,"name":addNameCategory] as [String : Any]
            menus.append(add_menus)
        }
        //テーブルの再描画
        tableView.reloadData()
    }
}

//遷移先を指定している
extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return BaseTableViewCell.height()
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
        //BaseTableViewCellというTableViewCellを継承されたクラスを作成
        let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)

        let test = menus[indexPath.row]["name"] as! String
        
        //作成したカテゴリーにのみcateogry_idプロパティにidを指定する
        if (test != "Note" && test != "All"){
//            print(test)
            cell.category_id = menus[indexPath.row]["id"] as! Int
        }
        cell.setData(menus[indexPath.row]["name"])
        
        return cell
    }
}
