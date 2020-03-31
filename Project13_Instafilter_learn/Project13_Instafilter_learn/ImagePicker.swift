//
//  ImagePicker.swift
//  Project13_Instafilter_learn
//
//  Created by Ильдар Нигметзянов on 31.03.2020.
//  Copyright © 2020 Ildar. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        <#code#>
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        return picker
    }
    
    typealias UIViewControllerType = UIImagePickerController
}
