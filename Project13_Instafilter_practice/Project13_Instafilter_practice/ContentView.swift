//
//  ContentView.swift
//  Project13_Instafilter_practice
//
//  Created by Ильдар Нигметзянов on 02.04.2020.
//  Copyright © 2020 Ildar. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.0
    @State private var showingImagePicker = false
    
    @State private var inputImage: UIImage?
    
    //@State private var currentFilter = CIFilter.sepiaTone()
    
    @State private var showingFilterSheet = false
    @State private var proceddedImage: UIImage?
    let context = CIContext()
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var alertMessage: Bool = false
    
    var body: some View {
        let intensity = Binding<Double>(get:{
            self.filterIntensity
        },set:{
            self.filterIntensity = $0
            self.applyProcessing()
        })
        let radius = Binding<Double>(get:{
            self.filterRadius
        },set:{
            self.filterRadius = $0
            self.applyProcessing()
        })
        return NavigationView{
            VStack{
                ZStack{
                    Rectangle()
                        .fill(Color.secondary)
                    if image != nil{
                        image?
                        .resizable()
                        .scaledToFit()
                    }else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                HStack{
                    Text("Intensity")
                    Slider(value:intensity)
                }.padding(.vertical)
                HStack{
                    Text("Radius")
                    Slider(value:radius)
                }
                HStack{
                    Button(currentFilter.name.dropFirst().dropFirst()){
                        self.showingFilterSheet = true
                    }
                    Spacer()
                    Button("Save"){
                        
                        guard let processedImage = self.proceddedImage else {
                            self.alertMessage = true
                            return
                        }
                        
                        let imageSaver = ImageSaver()
                        imageSaver.successHandler = {
                            print("Success!")
                        }
                        imageSaver.errorHandler = {
                            print("Oops \($0.localizedDescription)")
                        }
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
                }
                
            }
        }
        .padding([.horizontal,.bottom])
        .navigationBarTitle("Instafilter")
        .sheet(isPresented:$showingImagePicker,onDismiss: loadImage){
            ImagePicker(image:self.$inputImage)
        }
        .actionSheet(isPresented:$showingFilterSheet){
            ActionSheet(title: Text("Select a filter"), buttons: [
               
                .default(Text("Edges")) { self.setFilter(CIFilter.edges())},
                .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur()) },
                .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate()) },
                .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone()) },
                .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask()) },
                .default(Text("Vignette")) { self.setFilter(CIFilter.vignette()) },
                .cancel()
            ])
        }
        .alert(isPresented:$alertMessage){
            Alert(title: Text("Error"), message: Text("No photo to save"), dismissButton: .cancel())
        }
    }
    
    func loadImage(){
        guard let inputImage = inputImage else {return}
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing(){
        let inputKeys = currentFilter.inputKeys
        //currentFilter.setValue(filterIntensity,forKey: kCIInputImageKey)
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKeyPath: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius*100, forKeyPath: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(filterIntensity*10, forKeyPath: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else {return}
        
        if let cgimg = context.createCGImage(outputImage,from:outputImage.extent){
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            proceddedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
