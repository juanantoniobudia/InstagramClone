
import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func chooseImage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    

    @IBAction func actionButtonClicked(_ sender: Any) {
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageReference = storage.reference()
            
        // Create a child reference
        // imagesRef now points to "media" I have to create media directory before at Firebase Storage
        let mediaFolder = storageReference.child("media")
        
        //data contains the image from the imageView
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString //create an identifier for the image to have unique id´s for each image
            
            let imageReference = mediaFolder.child("\(uuid).jpg")//create a reference path into firebase storage
            //save data into imagereference firebase storage
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    
                    imageReference.downloadURL { (url, error) in
                        
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            
                            //DATABASE -> I choose Firebase Cloud Firestore
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            //creating a firestore dictionary key : value
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!,"date" : FieldValue.serverTimestamp(), "likes" : 0 ] as [String : Any]
                            print(firestorePost)
                            self.imageView.image = UIImage(named: "select.png")
                            self.commentText.text = ""
                            self.tabBarController?.selectedIndex = 0
                            //creating a reference or collection if it doesn´t exists and else add to that the collection or dictionary
                            //to the collection "Posts"
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                    
                                } else {
                                    //if is correct i clean the view
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            self.imageView.image = UIImage(named: "select.png")
                            self.commentText.text = ""
                            self.tabBarController?.selectedIndex = 0
                            
                            
                            
                        }
                        
                        
                    }
                    
                }
            }
            
            
        }
        
    }
    
}

