//
//  ContentView.swift
//  Project13_learn
//
//  Created by Ильдар Нигметзянов on 31.03.2020.
//  Copyright © 2020 Ildar. All rights reserved.
//

import SwiftUI

class ImageSaver: NSObject{
    func writeToPhotoAlbum(image:UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    @objc func saveError(_ image:UIImage,didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        print("Save finished!")
    }
}

struct ContentView: View {
    
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack{
            image?
                .resizable()
                .scaledToFit()
            
            Button("Select Image"){
                self.showingImagePicker = true
            }
        }
        .sheet(isPresented:$showingImagePicker,onDismiss: loadImage){
            ImagePicker(image:self.$inputImage)
        }
    }
    
    func loadImage(){
        guard let inputImage = inputImage else {return}
        image = Image(uiImage: inputImage)
        
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image:inputImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
