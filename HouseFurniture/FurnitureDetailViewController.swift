
import UIKit

// adopt UINavigationControllerDelegate and UIImagePickerControllerDelegate for image picker in choosePhotoButtonTapped
class FurnitureDetailViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var furniture: Furniture?
    
    @IBOutlet var choosePhotoButton: UIButton!
    @IBOutlet var furnitureTitleLabel: UILabel!
    @IBOutlet var furnitureDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    func updateView() {
        guard let furniture = furniture else {return}
        if let imageData = furniture.imageData,
            let image = UIImage(data: imageData) {
            choosePhotoButton.setTitle("", for: .normal)
            choosePhotoButton.setImage(image, for: .normal)
        } else {
            choosePhotoButton.setTitle("Choose Image", for: .normal)
            choosePhotoButton.setImage(nil, for: .normal)
        }
        
        furnitureTitleLabel.text = furniture.name
        furnitureDescriptionLabel.text = furniture.description
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: Any) {
        // create an instance of UIImagePickerController and set its delegate to self
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // create an instance of UIAlertController
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an alert action to cancel the alert controller and add the action to the alert controller
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // create an alert action to choose an image from the photo library and add the action to the alert controller
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        // create an alert action to use the camera to take a new image and add the action to the alert controller
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        // present the alert controller
        present(alertController, animated: true, completion: nil)
        
    }
    
    // after picked image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // retrieve the selected image, unwrap the result and cast it as a UIImage
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
        // set the imagedata of furniture to the data of the selected image
        furniture?.imageData = selectedImage.pngData()
        
        // dismiss the image picker
        dismiss(animated: true, completion: nil)
        
        // update view to complete
        updateView()
    }
    
    // dismiss the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func actionButtonTapped(_ sender: Any) {
        // unwarp furniture
        guard let furniture = furniture, let image = furniture.imageData else { return }
        
        // add the ability to share the image and description
        let activityController = UIActivityViewController(activityItems: [image, furniture.description], applicationActivities: nil)
        
        // present the activity controller
        activityController.popoverPresentationController?.sourceView = sender as! UIView
        present(activityController, animated: true, completion: nil)
    }
    
}
