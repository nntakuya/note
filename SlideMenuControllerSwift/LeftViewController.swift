//サイドバー
import UIKit

//実現したいこと
//1.サイドバーのセルにカテゴリー一覧を反映させたい
//2. "1"を追加するにあたって、"All"は残し、その次の項目から追加していく

//【メモ】
//CoreDataからカテゴリー名を全件取得
//menus配列にappendしていく
//menus配列にあるデータをサイドバーのセルに表示していく
//遷移先をOthersViewControllerにする

//TODO:列挙体を使わない方向で考えるべき
//└ 列挙体がどういう場面で使用されているのか確認
//└ changeViewController, tableView, extension LeftViewController
//└

enum LeftMenu: Int {
    case note = 0
    case all
    case others
    case others1
    case others2
    case others3
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}


class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    //TODO:配列を"Note"と"All"以外、CoreDataに保存されているカテゴリー名から追加する処理にする(ファンクション作成済)
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
        addListCategory()
        
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    //目的:サイドバーのカテゴリー項目から詳細画面へ遷移
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .note:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .all:
            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        //TODO:(カテゴリー作成後反映)ここ以下のviewファイルをコードで全部作成
        default:
            self.slideMenuController()?.changeMainViewController(self.OthersViewController, close: true)
        }
    }
    
    
    //カテゴリー一覧を配列に組み込むファンクション
    func addListCategory(){
        //CoreDataオブジェクト作成
        let categoryDatas = ingCoreData()
        //CoreDataからカテゴリーデータを全件取得
        let inputCategories = categoryDatas.readCategoryAll()
        
        for inputCategory in inputCategories{
            //カテゴリーオブジェクトからカテゴリー名だけ取得
            let addCategory = inputCategory["name"] as! String
            menus.append(addCategory)
        }
    }
}


//遷移先を指定している
extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            print("遷移先テスト")
            print(menu)
            switch menu {
            case .note, .all:
                return BaseTableViewCell.height()
            default:
                return 60
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
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
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            case .note, .all:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                print(cell)
                cell.setData(menus[indexPath.row])
                return cell
            default:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                print(cell)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
