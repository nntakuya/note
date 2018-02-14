
//  ingCoreData.swift
//  ingCalc
//
import CoreData
import UIKit

//rirekiCount : 現在の履歴の数
//max_rid     : 現在の最大の idの位置
//maxNum      : 最大の値

//【タスク】
//・sort_id作成するfunction

//~sort_id~
//(やりたいこと)
//データが並び替えられた際、データが並び替えられた順にsort_idを並び替えたい
//上記のことが必要な場合は、データが並び替えられた時のみ
//それ以外の場合では、idと同じ処理(カテゴリーが増える度に、CoreDataから最新のsort_idを取得し、+1でsort_idを更新
//（必要なこと）
//


class ingCoreData {
    //AppDelegateを使う用意をしておく（インスタンス化）
    let appDalegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var dics:[NSDictionary] = []
    var idCount:Int = -1
    var min_id:Int = -1
    //最大値をidとsort_idの最大値の初期値をセット
    var max_sort_id:Int = -1
    var max_id:Int = -1
    private let maxNum:Int = 10
    
    
    //【目的】①データベースのIDの最大値の取得　②データベースのsort_idの最大値を取得
    init() {
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        //エンティティオブジェクトを作成する
        let myEntity = NSEntityDescription.entity(forEntityName: "Category", in: viewContext)
        let query:NSFetchRequest<Category> = Category.fetchRequest()
        query.entity = myEntity
        
        
        //取り出しの順番
        //最大値の取得：①id　②sort_id
        
        //①idの最大値取得
        let sortDescripter = NSSortDescriptor(key: "saveData", ascending: true)//ascendind:true 昇順 古い順、false 降順　新しい順
        query.sortDescriptors = [sortDescripter]
        do {
            //クエリを実行し、"fetchResults"へ(おそらく配列？）
            let fetchResults = try viewContext.fetch(query)
            //もしidが-1(エラー)の場合、1以上ある場合は実行
            if(idCount != 0){
                //CoreDataから呼び出された配列データ(fetchResults)をfetchへ
                for fetch:AnyObject in fetchResults {
                    //idとsort_idそれぞれの最大値を取得
                    max_id = (fetch.value(forKey: "id") as? Int)!
                }
//                NSLog("coreDataの数\(idCount)")
                NSLog("max_ridの値:\(max_id)")
            }
        }
        catch{
        }
        
        //②idの最大値取得
        let sortIdDescripter = NSSortDescriptor(key: "sort_id", ascending: true)//ascendind:true 昇順 古い順、false 降順　新しい順
        query.sortDescriptors = [sortIdDescripter]
        do {
            //クエリを実行し、"fetchResults"へ(おそらく配列？）
            let sortIdFetchResults = try viewContext.fetch(query)
            
            //CoreDataから呼び出された配列データ(fetchResults)をfetchへ
            for fetch:AnyObject in sortIdFetchResults {
                //idとsort_idそれぞれの最大値を取得
                max_sort_id = (fetch.value(forKey: "sort_id") as? Int)!
            }
            NSLog("max_sort_idの値:\(max_sort_id)")
        }
        catch{
        }
    }
    
    
    
    
    //==============================
    // Create
    //==============================
    func createRecord(id:Int, name:String, sort_id:Int) {
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        
        //エンティティオブジェクトを作成する
        let myEntity = NSEntityDescription.entity(forEntityName: "Category", in: viewContext)
        
        //ToDOエンティティにレコードを挿入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: myEntity!, insertInto: viewContext)
        
        //値のセット
        newRecord.setValue(id, forKey: "id")
        newRecord.setValue(name, forKey: "name")
        //TODO:idの並び替えをするidを作成する
        newRecord.setValue(sort_id, forKey: "sort_id")
        //日付保存
        newRecord.setValue(Date(), forKey: "saveData")
        
        //レコードの即時保存
        do {
            try viewContext.save()
            //メンバ変数をアップデート
//            idCount = idCount + 1
            max_id = id
            max_sort_id = sort_id
        } catch {
            //エラーが発生した時に行う例外処理を書いておく
        }
    }
    
    //==============================
    //           Read All
    //==============================
    //既に存在するデータの読み込み処理
    func readCategoryAll() -> [NSDictionary] {
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        
        //エンティティオブジェクトを作成する
        let myEntity = NSEntityDescription.entity(forEntityName: "Category", in: viewContext)
        
        let query:NSFetchRequest<Category> =  Category.fetchRequest()
        query.entity = myEntity
        
        //取り出しの順番
        //ascendind:true 昇順 古い順、false 降順　新しい順
        let sortDescripter = NSSortDescriptor(key: "sort_id", ascending: true)
        query.sortDescriptors = [sortDescripter]
        
        //データを一括取得
        do {
            
            let fetchResults = try viewContext.fetch(query)
            if( fetchResults.count != 0) {
                for fetch:AnyObject in fetchResults {
                    let id:Int = (fetch.value(forKey: "id") as? Int)!
                    let name:String = (fetch.value(forKey: "name") as? String)!
                    let sort_id:Int = (fetch.value(forKey: "sort_id") as? Int)!
                    let saveData:NSDate = (fetch.value(forKey: "saveData") as? NSDate)!

                    let dic =  ["id":id,"name":name,"sort_id":sort_id,"saveData":saveData] as [String : Any]
                    
                    dics.append(dic as NSDictionary)
                }
            }
            print(dics)
            
        } catch  {
            print(error)
            
        }
        return dics
    }
    
    
    //==============================
    // Read 1
    //==============================
    func readCategory(id:Int) -> NSDictionary {
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        var dic:NSDictionary = NSDictionary()
        
        //どのエンティティからデータを取得してくるか設定
        let query:NSFetchRequest<Category> =  Category.fetchRequest()
        
        //===== 絞り込み =====
        let idPredicate = NSPredicate(format: "id = %d", id)
        query.predicate = idPredicate
        
        
        //===== データ１件取得（idを指定しているので) =====
        do {
            
            let fetchResults = try viewContext.fetch(query)
            
            //きちんと保存できているか、１行ずつ表示（デバッグエリア）
            for fetch:AnyObject in fetchResults {
                let id:Int = (fetch.value(forKey: "id") as? Int)!
                let name:String = (fetch.value(forKey: "name") as? String)!
                let sort_id:Int = (fetch.value(forKey: "sort_id") as? Int)!
                let saveData:NSDate = (fetch.value(forKey: "saveData") as? NSDate)!

                dic =  ["id":id,"name":name,"sort_id":sort_id,"saveData":saveData]
                
                print(dic)
                
            }
            
        } catch  {
        }
        return (dic as NSDictionary)
    }
    
    
    //==============================
    // Delete all
    //==============================
    func deleteCategoryAll() {
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        
        //どのエンティティからデータを取得してくるか設定（ToDoエンティティ）
        let query:NSFetchRequest<Category> =  Category.fetchRequest()
        
        do {
            //削除するデータを取得（今回は全て取得）
            let fetchResults = try viewContext.fetch(query)
            
            //１行ずつ削除
            
            for fetch:AnyObject in fetchResults{
                //削除処理を行うために型変換
                let record = fetch as! NSManagedObject  // 扱いやすいように型変換
                viewContext.delete(record)
            }
            //削除した状態を保存
            try viewContext.save()
            idCount = 0
        } catch  {
        }
    }
    
    //==============================
    // Delete 1
    //==============================
    func deleteCategory(id:Int) {
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        
        //どのエンティティからデータを取得してくるか設定（ToDoエンティティ）
        let query:NSFetchRequest<Category> =  Category.fetchRequest()
        
        //===== 絞り込み =====
        let idPredicate = NSPredicate(format: "id = %d", id)
        query.predicate = idPredicate
        
        
        do {
            //削除するデータを取得
            let fetchResults = try viewContext.fetch(query)
            
            //１行ずつ削除
            
            for fetch:AnyObject in fetchResults{
                //削除処理を行うために型変換
                let record = fetch as! NSManagedObject  // 扱いやすいように型変換
                viewContext.delete(record)
                
            }
            //削除した状態を保存
            try viewContext.save()
            idCount = idCount - 1

            
        } catch  {
            
//            if Constants.DEBUG == true {
//                print(#function)
                print("削除するレコードなかったよ")
//            }
            
        }
        
    }
    
    //==============================
    // Edit　今回は使わないけど記述残しとく
    //==============================
    
//    func editRireki(id:Int, result:String, resultText:String) {
//        print(#function)
//        //エンティティを操作するためのオブジェクトを作成する
//        let viewContext = appDalegate.persistentContainer.viewContext
//
//        //どのエンティティからデータを取得してくるか設定（ToDoエンティティ）
//        let query:NSFetchRequest<Rireki> =  Rireki.fetchRequest()
//
//
//        //===== 絞り込み =====
//        let idPredicate = NSPredicate(format: "id = %d", id)
//        query.predicate = idPredicate
//
//        do {
//
//            let fetchResults = try viewContext.fetch(query)
//
//            if (fetchResults.count == 0) {
//                //なければ新規で作る
//                print(#function)
//                print("ないので作ります。")
//                createRecord(id: id, result: result, resultText: resultText)
//                return  // 作って終了する
//            }
//
//            for fetch:AnyObject in fetchResults {
//
//                //更新する対象のデータをNSManagedObjectにダウンキャスト
//                let record = fetch as! NSManagedObject
//                //値のセット
//                record.setValue(id, forKey: "id")
//                record.setValue(result, forKey: "result")
//                record.setValue(resultText, forKey: "resultText")
//
//                //レコードの即時保存
//                do {
//                    try viewContext.save()
//                } catch {
//                    //エラーが発生した時に行う例外処理を書いておく
//                    print(#function)
//                    print("保存できなかった")
//                }
//
//
//            }
//        } catch  {
//        }
//    }
    
    
    
//==============================================
//　カテゴリーの並び替えが行われた際に、
//sort_idを全件取得し、昇順にidの再割当てする処理
//==============================================
    func sortChange(categoryArray:[[String:Any]]){
        //エンティティを操作するためのオブジェクトを作成する
        let viewContext = appDalegate.persistentContainer.viewContext
        
        //エンティティオブジェクトを作成する
        let myEntity = NSEntityDescription.entity(forEntityName: "Category", in: viewContext)
        
        //どのエンティティからデータを取得してくるか設定（ToDoエンティティ）
        let query:NSFetchRequest<Category> =  Category.fetchRequest()
        query.entity = myEntity
        
        //取り出しの順番
        //ascendind:true 昇順 古い順、false 降順　新しい順
        let sortDescripter = NSSortDescriptor(key: "sort_id", ascending: true)
        query.sortDescriptors = [sortDescripter]
        
        
        do {
            let fetchResults = try viewContext.fetch(query)
            
            var i = 0
            for fetch:AnyObject in fetchResults {
                //更新する対象のデータをNSManagedObjectにダウンキャスト
                let record = fetch as! NSManagedObject
                //値のセット
                record.setValue(categoryArray[i]["sort_id"], forKey: "sort_id")
                i += 1
                print(record)
                print(categoryArray)
                //レコードの即時保存
                do {
                    try viewContext.save()
                } catch {
                    //エラーが発生した時に行う例外処理を書いておく
                    print(#function)
                    print("保存できなかった")
                }
            }
        } catch  {
        }
    }
    
    
    //==============================
    // 挿入 履歴maxnum件　最新に入れる
    //　戻り値：　挿入したid
    //==============================
    
    func insertCategory(name:String) -> Int {
        //新しいidとsort_idをセット
        let newid:Int = max_id + 1
        let new_sort_id:Int = max_sort_id + 1
        
        //maxNumは初期値でセットした値
        createRecord(id: newid, name: name, sort_id: new_sort_id)
        
//        if(idCount > maxNum ) {
//            deleteRireki(id: min_id)
//        }
        
        return newid
    }
}

