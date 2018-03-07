
import UIKit

extension UITableView {
    
    private struct AssociatedKeys {
        static var reorderController: UInt8 = 0
    }
    
    /// An object that manages drag-and-drop reordering of table view cells.
    public var reorder: ReorderController {
        if let controller = objc_getAssociatedObject(self, &AssociatedKeys.reorderController) as? ReorderController {
            return controller
        } else {
            let controller = ReorderController(tableView: self)
            objc_setAssociatedObject(self, &AssociatedKeys.reorderController, controller, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return controller
        }
    }
    
}
