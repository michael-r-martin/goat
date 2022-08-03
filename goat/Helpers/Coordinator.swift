//
//  Coordinator.swift
//  goat
//
//  Created by Michael Martin on 02/08/2022.
//

import Foundation
import UIKit

extension UIViewController {
    func goToCreatePost() {
        guard let vc = UIStoryboard(name: SBIds.create, bundle: nil).instantiateViewController(withIdentifier: VCIds.createPost) as? CreatePostViewController else { return }
        
        present(vc, animated: true)
    }
}
