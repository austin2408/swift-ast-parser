import UIKit

class PhotoViewController: UIViewController {
    // Test explicit type annotation
    let collectionView: UICollectionView
    
    // Test initializer with constructor
    let tableView = UITableView()
    
    // Test with parameters in constructor
    let imageView = UIImageView(frame: .zero)
    
    // Test property access
    let color = UIColor.red
    
    // Regular variable without UI type
    var counter = 0
    var name = "test"
    
    // Optional type
    var optionalView: UIView?
    
    init() {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
