
//サイドバー
import UIKit

//実現したいこと
//1.サイドバーのセルにカテゴリー一覧を反映させたい
//2. "1"を追加するにあたって、"All"は残し、その次の項目から追加していく


enum LeftMenu: Int {
    case note = 0
    case all
    case others
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    //TODO:配列を"Note"と"All"以外、CoreDataに保存されているカテゴリー名から追加する処理にする
    var menus = ["Note", "All", "To Do"]
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
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .note:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .all:
            self.slideMenuController()?.changeMainViewController(self.swiftViewController, close: true)
        //TODO:(カテゴリー作成後反映)ここ以下のviewファイルをコードで全部作成
        case .others:
            self.slideMenuController()?.changeMainViewController(self.OthersViewController, close: true)
        }
    }
}

//以下で遷移先を指定している
//TODO:"todo,go,nonMenu"の部分をothersに変更し、共通の処理を統一する？
extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            print("遷移先テスト")
            print(menu)
            switch menu {
            case .note, .all, .others:
                return BaseTableViewCell.height()
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
            case .note, .all, .others:
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                print(cell)
                cell.setData(menus[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
}
