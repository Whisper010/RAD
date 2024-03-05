import SwiftUI

struct CameraSecondView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var pickedImage: UIImage
    
    var body: some View {
        ZStack {
            // Simulated camera viewfinder
//            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack{
                
                Image(uiImage: pickedImage)
                    .resizable()
                    .frame(width: 500, height: 400)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    
            }
            
            // Layout for camera UI
            VStack {
                // Top left back button with semi-transparent background
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
                            // Action for the first icon (camera filter/effects)
                        }) {
                            Image(systemName: "camera.filters")
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .font(.title)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        Button(action: {
                            // Action for the second icon (gallery)
                        }) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .font(.title)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        Button(action: {
                            // Action for the third icon (add new item)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .font(.title)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        Button(action: {
                            // Action for the fourth icon (settings)
                        }) {
                            Image(systemName: "gear.circle.fill")
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .font(.title)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.trailing, 20)
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
        .navigationBarHidden(true) // Ensures the navigation bar does not show
    }
}

struct CameraSecondView_Previews: PreviewProvider {
    static var previews: some View {
        CameraSecondView(pickedImage:  .constant (UIImage()))
    }
}
