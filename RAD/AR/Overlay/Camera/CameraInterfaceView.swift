import SwiftUI
import AVFoundation

struct CameraInterfaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(ARLogic.self) private var arLogic
    
    @State private var showingImageUploadView = false

    var body: some View {
            VStack {
                ZStack (alignment: .bottom) {
                    /*Color.clear*/ // Simulate camera view with semi-transparent background
//                        .edgesIgnoringSafeArea(.all)
                                                  
                    HStack(alignment: .bottom, spacing: 30) {
                            
                            
                            Button(action: {
                                arLogic.currentSelectedTool = .none
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
                            
                            
                            

                            Button(action: {
                                arLogic.makingPhoto = true
                                playStutterSound()
                            }) {
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
                       
                        }
                        
                    
                }
            }
            
    }
}

func playStutterSound() {

    let soundID: SystemSoundID = 1108
    if #available(iOS 9.0, *) {
            AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(soundID), nil)
        } else {
            AudioServicesPlaySystemSound(soundID)
        }
}

//
//struct CameraInterfaceView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraInterfaceView()
//    }
//}
//
