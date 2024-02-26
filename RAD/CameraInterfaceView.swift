import SwiftUI

struct CameraInterfaceView: View {
    @Environment(\.presentationMode) var presentationMode
    
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
                    Color.black.opacity(0.3) // Simulate camera view with semi-transparent background
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Spacer() // Pushes all content to the bottom
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 20) // Add padding to the leading button

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
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .imageScale(.large)
                },
                trailing: Button(action: {
                    // Action for the back button in the upper navigation bar
                }) {
                    Image(systemName: "arrowshape.turn.up.left")
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
