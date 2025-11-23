import UIKit

class CustomCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {
    // Test custom class with initializez
    let customCV = CustomCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // Test explicit type annotation with custom class
    let anotherCV: CustomCollectionView
    
    // Test standard UICollectionView for comparison
    let standardCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init() {
        self.anotherCV = CustomCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
