//
//  SwiftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//



import UIKit

class SwiftViewController: UIViewController,UITableViewDelegate,UITableViewDataSource   {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
//        cell.textLabel?.text = teaList[indexPath.row]
        
        //文字設定したセルを返す
        return cell
    }
    
    //ここに、テーブルを作成する
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationBarItem()
    }
    
}







