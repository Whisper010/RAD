import SwiftUI

struct CameraSecondView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var pickedImage: UIImage
    let imageHandler = ImageHandler()
    
    @State private var showingSaveConfirmation = false
    @State private var showingSaveResult = false
    @State private var saveResultMessage = ""
    
    var body: some View {
        ZStack {
            
            
            GeometryReader { geo in
                ZStack {
                    // Simulated camera viewfinder
                    //            Color.black.edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        
                        Image(uiImage: pickedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width * 0.8)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        
                    }
                    
                    // Layout for camera UI
                    VStack {
                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                                
                            }
                            Spacer()
                        }.padding()
                        Spacer()
                    }
                    VStack{
                        Spacer().frame(height: 100)
                        
                        // Side bar with camera controls icons
                        HStack {
                            Spacer()
                            VStack(spacing: 30) {
                                Button(action: {
                                    
                                    // Action for the (save image)
                                    showingSaveConfirmation = true
                                    print("action happend")
                                }) {
                                    Image(systemName: "arrow.down.to.line.circle.fill")
                                        .padding()
                                        .background(Color.black.opacity(0.5))
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                }
                                
                                
                                Button(action: {
                                    // Action for the (camera filter/effects)
                                    
                                }) {
                                    Image(systemName: "camera.filters")
                                        .padding()
                                        .background(Color.black.opacity(0.5))
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                }
                                
                                //                            Button(action: {
                                //                                // Action for the (gallery)
                                //                            }) {
                                //                                Image(systemName: "photo.on.rectangle.angled")
                                //                                    .padding()
                                //                                    .background(Color.black.opacity(0.5))
                                //                                    .font(.title)
                                //                                    .foregroundColor(.white)
                                //                                    .clipShape(Circle())
                                //                            }
                                
                                //                            Button(action: {
                                //                                // Action for the (add new item)
                                //                            }) {
                                //                                Image(systemName: "plus.circle.fill")
                                //                                    .padding()
                                //                                    .background(Color.black.opacity(0.5))
                                //                                    .font(.title)
                                //                                    .foregroundColor(.white)
                                //                                    .clipShape(Circle())
                                //                            }
                                
                                Button(action: {
                                    // Action for the (settings)
                                }) {
                                    Image(systemName: "gear.circle.fill")
                                        .padding()
                                        .background(Color.black.opacity(0.5))
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.trailing)
                        }.padding(.top)
                        Spacer()
                    }
                    
                    //                // Bottom capture button with shadow for depth
                    //                Button(action: {
                    //                    // Action to take a picture
                    //                }) {
                    //                    Image(systemName: "circle.fill")
                    //                        .font(.system(size: 72))
                    //                        .foregroundColor(.white)
                    //                        .padding(20)
                    //                        .background(Color.black.opacity(0.5))
                    //                        .clipShape(Circle())
                    //                        .shadow(radius: 10)
                    //                }
                    //                .padding(.bottom, 50)
                    
                }
                .navigationBarHidden(true)
                .alert(isPresented: $showingSaveConfirmation) {
                    Alert(
                        title: Text("Save Image"),
                        message: Text("Are you sure you want to save this image to your photo library?"),
                        primaryButton: .default(Text("Save")) {
                            imageHandler.writeToPhotoAlbum(image: pickedImage) {success, error in
                                if success {
                                    saveResultMessage = "Photo saved successfully!"
                                } else {
                                    if let error = error {
                                        saveResultMessage = "Error saving photo: \(error.localizedDescription)"
                                    }
                                }
                                showingSaveResult = true
                            }
                            
                        },
                        secondaryButton: .cancel()
                    )
                    
                }
                
            }
            
            ZStack {
                
            }.alert(isPresented: $showingSaveResult) {
                Alert(
                    title: Text("Save Result"),
                    message: Text(saveResultMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
        }
    }
}

class ImageHandler: NSObject {
    
    private var completion: ((Bool, Error?) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage, completion: @escaping (Bool, Error?) -> Void) {

        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)) , nil)
       
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            completion?(false, error)
        } else {
            completion?(true, nil)
        }
    }
}



struct CameraSecondView_Previews: PreviewProvider {
    static var previews: some View {
        CameraSecondView(pickedImage:  .constant (UIImage()))
    }
}
