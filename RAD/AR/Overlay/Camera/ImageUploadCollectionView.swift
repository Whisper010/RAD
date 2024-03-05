import SwiftUI

struct ImageUploadCollectionViewController: View {
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingEditingView = false
    @State var pickedImage = UIImage()
    
    @Environment(ARLogic.self) private var arLogic

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(arLogic.images, id: \.self) { image in
                        Button(action:{
                            pickedImage = image
                            showingEditingView = true
                        }){
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                    Button(action: {
                        self.showingImagePicker = true
                    }) {
                        Image(systemName: "plus")
                            .frame(width: 100, height: 100)
                            .foregroundColor(.black)
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
                    }
                }
                .padding()
            }
            .background(Color.white) // Set the background color to white
            .navigationBarTitle("Upload Images")
            .navigationBarItems(trailing: Button(action: {
                // Add any actions you want to perform when the back button is pressed
            }) {
                Text("Back")
            })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
        .sheet(isPresented: $showingEditingView) {
            CameraSecondView(pickedImage: $pickedImage)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use StackNavigationViewStyle to support day mode
        .colorScheme(.light) // Set color scheme to light for day mode
    }
    

    func loadImage() {
        guard let inputImage = inputImage else { return }
        arLogic.images.append(inputImage)
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
