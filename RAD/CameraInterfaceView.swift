import SwiftUI

struct CameraInterfaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(ARLogic.self) private var arLogic
    @State private var showingImageUploadView = false // State to manage presentation
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundImage = UIImage(named: "NavigationBarBackground")
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
    }

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    /*Color.clear*/ // Simulate camera view with semi-transparent background
//                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Spacer() // Pushes all content to the bottom
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

                            Button(action: {}) {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                            .padding(.trailing, 20) // Add padding to the trailing button
                        }
                        .frame(height: 100)
                        .background(Color.black.opacity(0.5)) // Simulated bottom bar
                    }
                }
            }
            .navigationBarTitle("Camera", displayMode: .inline) // Title with white text color
            .navigationBarItems(
                leading: Button(action: {
                    arLogic.currentMode = .none
                }) {
                
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                }
            
            )
            .navigationBarBackButtonHidden(true) // Hides the default back button
        }
    }
}

struct CameraInterfaceView_Previews: PreviewProvider {
    static var previews: some View {
        CameraInterfaceView()
    }
}
