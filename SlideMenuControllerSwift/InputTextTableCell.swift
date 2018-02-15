////
////  InputTextTableCell.swift
////  SlideMenuControllerSwift
////
////  Created by 仲松拓哉 on 15/02/2018.
////  Copyright © 2018 Yuji Hato. All rights reserved.
////
//
//import UIKit
//
//protocol InputTextTableCellDelegate {
//    func textFieldDidEndEditing(cell: InputTextTableCell, value: NSString) -> ()
//}
//
//class InputTextTableCell: UITableViewCell, UITextFieldDelegate {
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//    }
//
//    static func height() -> CGFloat {
//        return 75.0
//    }
//
//    // MARK: - UITextFieldDelegate
//    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    // 追加
//    internal func textFieldDidEndEditing(_ textField: UITextField) {
//        self.delegate.textFieldDidEndEditing(self, value: textField.text!)
//    }
//
//
//}

