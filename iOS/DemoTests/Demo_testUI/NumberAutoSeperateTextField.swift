//
//  NumberAutoSeperateTextField.swift
//  Demo_testUI
//
//  Created by L on 2020/3/16.
//  Copyright © 2020 LyTsai. All rights reserved.
//

import Foundation

class NumberAutoSeperateTextField: UITextField {
    // default: xxx-xxx-xxxx
    var seperator = "-"
    var seperateFormat = [3, 3, 4]
    // result
    var inputedNumberString: String? {
        var inputed: String?
        if let input = self.text {
            inputed = ""
            for char in input {
                if char.isNumber {
                    inputed?.append(char)
                }
            }
        }
        
        return inputed
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicSetup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        basicSetup()
    }
    
    fileprivate func basicSetup() {
        self.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    fileprivate var _previousText:String!
    fileprivate var _previousRange:UITextRange!
    @objc func textFieldEditingChanged() {
        if let input = self.text {
            var displayText = ""
            var sectionInputed = 0
            var sectionIndex = 0
            for char in input {
                // valid data
                if char.isNumber {
                    if sectionInputed == seperateFormat[sectionIndex] {
                        // input is enough
                        if sectionIndex == seperateFormat.count - 1 {
                            break
                        }

                        displayText.append(seperator)

                        // next section
                        sectionIndex += 1
                        sectionInputed = 0
                    }

                    displayText.append(char)
                    sectionInputed += 1
                }
            }

            self.text = displayText
        }
    }
}


