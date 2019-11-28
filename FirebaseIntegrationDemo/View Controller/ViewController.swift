//
//  ViewController.swift
//  FirebaseIntegrationDemo
//
//  Created by Dheeraj Arora on 07/10/19.
//  Copyright © 2019 Dheeraj Arora. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ViewController: UIViewController {

    var ref = DatabaseReference.init()
    var arrData = [ChatModel]()
    let imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var txtText: UITextField!
    @IBOutlet weak var myImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()

        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(openGallery(tapGesture:)))
        myImage.isUserInteractionEnabled = true
        myImage.addGestureRecognizer(tapGesture)
        
        self.getAllFirebaseData()
        
    }

    @objc func openGallery(tapGesture: UITapGestureRecognizer){
        setImagePicker()
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        self.saveFIRData()
        self.getAllFirebaseData()
    }
    
    func saveFIRData()   {
        self.uploadImage(self.myImage.image!) { url in
            guard let url = url else { return }
            self.saveImage(name: self.txtText.text!, profileUrl: url) { success in
                if success != nil{
                    print("Yeah Yes Success")
                }
            }
        }
     }
    
    func getAllFirebaseData()   {
        self.ref.child("chat").queryOrderedByKey().observe(.value) { (snapshot) in
            self.arrData.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]
            {
                for snap in snapshot{
                    if let mainDict = snap.value as? [String : Any]{
                        let name = mainDict["name"] as? String
                        let text = mainDict["text"] as? String
                        let profileImage = mainDict["profileUrl"] as? String ?? ""
                        self.arrData.append(ChatModel(name: name!, text: text!, profileImageUrl: profileImage))
                        self.myTableView.reloadData()
                    }
                }
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func setImagePicker()   {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.isEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.myImage.contentMode = .scaleAspectFit
            self.myImage.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController {
        func uploadImage(_ image: UIImage, completion: @escaping (_ url: URL?) -> Void) {
            let storageRef = Storage.storage().reference().child("myImage.png")
            let metaData = StorageMetadata()
            if let uploadData = self.myImage.image!.pngData() {
                storageRef.putData(uploadData, metadata: metaData) { (metadata, error) in
                    if error == nil {
                        storageRef.downloadURL(completion: { (url, error) in
                            completion(url)
                        })
                        
                    } else {
                        print("error")
                        completion(nil)
                        
                    }
                }
            }
    }

   func saveImage(name: String, profileUrl: URL,completion: @escaping((_ url: URL?)->()) ) {
          let dict = ["name":"Naresh Kumar","text":txtText.text!,"profileUrl": profileUrl.absoluteString] as [String: Any]
          self.ref.child("chat").childByAutoId().setValue(dict)
        }
    }

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.chatModel = arrData[indexPath.row]
        return cell
    }
    
    
}
