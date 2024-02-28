import SwiftUI

struct CameraInterfaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(ARLogic.self) private var arLogic
    @State private var showingImageUploadView = false // State to manage presentation
    
//    init() {
//        // Make navigation bar transparent
//           UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
//           UINavigationBar.appearance().shadowImage = UIImage()
//           UINavigationBar.appearance().isTranslucent = true
//           UINavigationBar.appearance().backgroundColor = .clear
//    }

    var body: some View {
            VStack {
                ZStack {
                    /*Color.clear*/ // Simulate camera view with semi-transparent background
//                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        
                        
                        HStack {
                            Button(action: {
                                // This button will now present the ImageUploadCollectionViewController
                                showingImageUploadView = true
                            }) {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 20) // Add padding to the leading button
                            .sheet(isPresented: $showingImageUploadView) {
                                ImageUploadCollectionViewController()
                            }

                            Spacer()

                            Button(action: {}) {
                                Image(systemName: "camera.circle")
                                    .font(.system(size: 70))
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            Button(action: {
                                arLogic.currentMode = .none
                            }) {
                                
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                                    .imageScale(.large)
                            }
                            .padding()
                            
//                            Button(action: {}) {
//                                Image(systemName: "photo.on.rectangle.angled")
//                                    .font(.largeTitle)
//                                    .foregroundColor(.white)
//                            }
//                            .padding(.trailing, 20) // Add padding to the trailing button
//                            .opacity(0)
                        }
                        .frame(height: 100)
                        .background(Color.clear) // Simulated bottom bar
                    }
                }
            }
            
    }
}

struct CameraInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        CameraInterfaceView()
    }
}
