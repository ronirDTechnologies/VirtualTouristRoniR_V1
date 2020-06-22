//
//  PhotoAlbumViewController.swift
//  VIrtualTourist_RoniR
//
//  Created by Roni Rozenblat on 1/10/20.
//  Copyright © 2020 dinatech. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController:  UICollectionViewController
{
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        return ai
    }()
    @IBOutlet weak var PhotoCollectionView: UICollectionView!
var pinPhotoInfo: [Photo] = []
    
func loadPicsForLatLon(pinLatVal: String, pinLonVal: String)
{
   
    
    DispatchQueue.main.async
    {
        VirtualTouristClient.GetPhotosForLatLon(latVal: pinLatVal, lonVal: pinLonVal)
        {
            (data,error) in guard let data = data else
            {
                return
            }
            
            self.pinPhotoInfo = data.photo
            self.PhotoCollectionView.reloadData()
        }
            
            
    
            print("DATA TEST")
            //print("ERROR 3\(error?.localizedDescription)")
            //print("ERROR 4\(error)")
        }
}
  @IBOutlet weak var PhotoAlbumCv: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.PhotoCollectionView.dataSource = self
        //self.PhotoCollectionView.delegate = self

        // Do any additional setup after loading the view.
        //loadPicsForLatLon(pinLatVal: "40", pinLonVal: "40")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadPicsForLatLon(pinLatVal: "40", pinLonVal: "40")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PhotoAlbumViewController
{
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return pinPhotoInfo.count
}
    /*func set(image: UIImage?) {
        self.cell.image = image
        
        if image == nil {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }*/
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "locationPicCell", for: indexPath) as! locationPicCell
        
        guard let url = URL(string: self.pinPhotoInfo[indexPath.row].urlT) else { return cell }
        
        cell.cellImageVal.image = nil // set(image: nil)
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.cellImageVal.image = image
                    
                    /*if let selectedImage = self.selectedImage, selectedImage.row == indexPath.row {
                        selectedImage.imageView.set(image: image)
                    }*/
                }
            }
        }
        
        
        
        
        if pinPhotoInfo.count > 0
        {
            
               
            // Start background thread so that image loading does not make app unresponsive
            //DispatchQueue.global(qos: .userInitiated).async
            //{
                       
                
                           
                // When from background thread, UI needs to be updated on main_queue
                DispatchQueue.main.async
                {
                    let tempPhoto = self.pinPhotoInfo[indexPath.row]
                    let imageUrl:URL = URL(string:tempPhoto.urlT)!
                    let imageData:NSData = NSData(contentsOf: imageUrl)!
                    cell.cellImageVal.image = UIImage(data: imageData as Data)
                            
                    /* imageView.image = image
                    imageView.contentMode = UIViewContentMode.scaleAspectFit
                    self.view.addSubview(imageView)*/
                }
            //}
        }
        
        return cell
    }
}

/*extension PhotoAlbumViewController{

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item + 1)
    }
}*/
/*extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}*/
