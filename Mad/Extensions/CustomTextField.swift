//
//  CustomTextField.swift
//  Mad
//
//  Created by MAC on 31/03/2021.
//


import UIKit

@IBDesignable class CustomTextField: UITextField {
    
    // Provides left padding for images
      override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
          var textRect = super.leftViewRect(forBounds: bounds)
          textRect.origin.x += leftPadding
          return textRect
      }
      
      @IBInspectable var leftImage: UIImage? {
          didSet {
              updateView()
          }
      }
      
      @IBInspectable var leftPadding: CGFloat = 0
      
      @IBInspectable var color: UIColor = UIColor.lightGray {
          didSet {
              updateView()
          }
      }
      
      func updateView() {
          if let image = leftImage {
              leftViewMode = UITextField.ViewMode.always
              let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
              imageView.contentMode = .scaleAspectFill
              imageView.image = image
              // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
              imageView.tintColor = color
              leftView = imageView
          } else {
              leftViewMode = UITextField.ViewMode.never
              leftView = nil
          }
          
          // Placeholder text color
          attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
      }
    
    
    @IBInspectable var inset: CGFloat = 10

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    //MARK:- Change Placeholder Color
    @IBInspectable var placeholderColor: UIColor {
        get {
            if let placeHolderColor = attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor {
                return placeHolderColor
            }
            return .clear
        }
        
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }
    //MARK:- Adding MasksToBounds
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    //MARK:- Adding Corner Radius to TextField
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    //MARK:- Border Width of TextField
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    //MARK:- Adding borderColor to TextField
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}


