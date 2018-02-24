////
////  ScrollBaseView.swift
////  SlideMenuControllerSwift
////
////  Created by 仲松拓哉 on 24/02/2018.
////  Copyright © 2018 Yuji Hato. All rights reserved.
////
//
//import UIKit
//
//extension BaseViewController{
//
////    =========================================
////　　　　  　 キーボード表示・非表示時の通知登録
////    =========================================
//    // 通知登録処理
//    func registerNotification() -> () {
//        let center: NotificationCenter = NotificationCenter.default
//        center.addObserver(self, selector: Selector(("keyboardWillShow:")), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        center.addObserver(self, selector: Selector(("keyboardWillHide:")), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//
//    // 通知登録解除処理
//    func unregisterNotification() -> () {
//        let center: NotificationCenter = NotificationCenter.default
//        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
//
//
////    =========================================
////　　　　  　 スクロール処理を作成
////    =========================================
//    // Keyboard表示前処理
//    func keyboardWillShow(notification: NSNotification) -> () {
//        scrollTableCell(notification: notification, showKeyboard: true)
//    }
//
//    // Keyboard非表示前処理
//    func keyboardWillHide(notification: NSNotification) -> () {
//        scrollTableCell(notification: notification, showKeyboard: false)
//    }
//
//
//
//    // TableViewCellをKeyboardの上までスクロールする処理
//    func scrollTableCell(notification: NSNotification, showKeyboard: Bool) -> () {
//        if showKeyboard {
//            // keyboardのサイズを取得
//            var keyboardFrame: CGRect = CGRect.zero
//            if let userInfo = notification.userInfo {
//                if let keyboard = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
//                    keyboardFrame = keyboard.cgRectValuecgRectValue
//                }
//            }
//
//            // keyboardのサイズが変化した分ContentSizeを大きくする
//            let diff: CGFloat = keyboardFrame.size.height - keyboardFrame.size.height
//            let newSize: CGSize = CGSizeMake(tableView.contentSize.width, tableView.contentSize.height + diff)
//            tableView.contentSize = newSize
//            keyboardFramekeyboardFrame = keyboardFrame
//
//            // keyboardのtopを取得
//            let keyboardTop: CGFloat = UIScreen.main.bounds.size.height - keyboardFrame.size.height;
//
//            // 編集中セルのbottomを取得
//            let cell: InputTextTableCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: editingPath.row, inSection: editingPath.section)) as! InputTextTableCell
//            let cellBottom: CGFloat
//            cellBottom = cell.frame.origin.y - tableView.contentOffset.y + cell.frame.size.height;
//
//            // 編集中セルのbottomがkeyboardのtopより下にある場合
//            if keyboardTop < cellBottom {
//                // 編集中セルをKeyboardの上へ移動させる
//                let newOffset: CGPoint = CGPointMake(tableView.contentOffset.x, tableView.contentOffset.y + cellBottom - keyboardTop)
//                tableView.setContentOffset(newOffset, animated: true)
//            }
//        } else {
//            // 画面を下に戻す
//            let newSize: CGSize = CGSizeMake(tableView.contentSize.width, tableView.contentSize.height - lastKeyboardFrame.size.height)
//            tableView.contentSize = newSize
//            tableView.scrollToRowAtIndexPath(editingPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
//            lastKeyboardFrame = CGRectZero;
//        }
//    }
//
//
//
//
//
//
//}

