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
                ZStack (alignment: .bottom) {
                    /*Color.clear*/ // Simulate camera view with semi-transparent background
//                        .edgesIgnoringSafeArea(.all)
                                                  
                    HStack(alignment: .bottom, spacing: 30) {
                            
                            
                            Button(action: {
                                arLogic.currentMode = .none
                            }) {
                                HStack{
                                    Image(systemName: "chevron.left")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .imageScale(.small)
                                        .frame(width: 20, height: 20)
                                        .padding()
                                }
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            
                            

                            Button(action: {}) {
                                HStack{
                                    Image(systemName: "camera.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .imageScale(.large)
                                        .frame(width: 50, height: 50)
                                        .padding()
                                }.background(.thinMaterial)
                                    .clipShape(Circle())
                                    
                            }
                            .buttonStyle(PlainButtonStyle())
                         
                            Button(action: {
                                // This button will now present the ImageUploadCollectionViewController
                                showingImageUploadView = true
                            }) {
                                HStack{
                                    Image(systemName: "photo")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .imageScale(.small)
                                        .frame(width: 20, height: 20)
                                        .padding()
                                }
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .sheet(isPresented: $showingImageUploadView) {
                                ImageUploadCollectionViewController()
                            }
                       
//                            Button(action: {}) {
//                                Image(systemName: "photo.on.rectangle.angled")
//                                    .font(.largeTitle)
//                                    .foregroundColor(.white)
//                            }
//                            .padding(.trailing, 20) // Add padding to the trailing button
//                            .opacity(0)
                        }
                        
                    
                }
            }
            
    }
}

//
//struct CameraInterfaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraInterfaceView()
//    }
//}
//
