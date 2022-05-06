//
//  UIImage.swift
//  GongSaeng
//
//  Created by 정동천 on 2022/01/13.
//

import UIKit

extension UIImage {
    func downSize(newWidth: CGFloat) -> UIImage {
        guard newWidth < self.size.width else { return self }
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        print("DEBUG: Data size ->", renderImage)
        return renderImage
    }
    
    func withInsets(_ insets: UIEdgeInsets) -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(
                CGSize(width: size.width + insets.left + insets.right,
                       height: size.height + insets.top + insets.bottom),
                false,
                self.scale)

            let origin = CGPoint(x: insets.left, y: insets.top)
            self.draw(at: origin)
            let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return imageWithInsets
        }
}
