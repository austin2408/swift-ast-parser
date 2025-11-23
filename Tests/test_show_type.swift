import UIKit

class TestViewController: UIViewController {
    // UI types
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let tableView: UITableView
    
    // Custom UI type
    let customView = CustomCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // Numeric types
    let intValue = 42
    let uintValue = UInt64(100)
    let doubleValue = 1.5
    let floatValue: Float = 3.14
    
    // String types
    let name = "test"
    let explicitString: String = "hello"
    
    // Boolean
    let isEnabled = true
    let isDisabled = false
    
    // Collections
    let numbers = [1, 2, 3]
    let dictionary = ["key": "value"]
    
    // Property access
    let color = UIColor.red
    
    init() {
        self.tableView = UITableView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CustomCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
