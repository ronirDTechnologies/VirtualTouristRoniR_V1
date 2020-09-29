//
//  PhotoAlMapViewController.swift
//  VIrtualTourist_RoniR
//
//  Created by Roni Rozenblat on 3/2/20.
//  Copyright © 2020 dinatech. All rights reserved.
//

import UIKit
import MapKit
import CoreData
private let reuseIdentifier = "PhotoCell"


class PhotoAlMapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,MKMapViewDelegate
{
    @IBOutlet weak var MapSelectedLocationMKView: MKMapView!
    
    
    @IBOutlet weak var RequestNewCollectionBtn: UIButton!
    @IBOutlet weak var PhotoCollectionView: UICollectionView!
    @IBOutlet weak var NoPhotoLabel: UILabel!
    
    var photoAddedCnt = 0
    var totalPhotoCnt = 0
    var pinPhotoInfo: [Photo] = []
    var dataController: DataController!
    var pin:Pin!
    
    public var latVal:String = "0.0"
    public var lonVal:String = "0.0"
    
    override func viewWillAppear(_ animated: Bool) {
            //loadPicsForLatLon(pinLatVal: "40", pinLonVal: "40")
    }
    // TODO: 09-11-2020
    /*  Will search for photos attached to pin.  If none return false
     */
    func doPicsExistInDataStoreForPin() -> Bool
    {
        
        var picsExist = false
        
        return picsExist
    }
    func loadPicsForLatLon(pinLatVal: String, pinLonVal: String)
    {
        RequestNewCollectionBtn.isEnabled = false
        let pinLatValCLLC = Double(pinLatVal)! as Double
        let pinLongValCCLC = Double(pinLonVal)! as Double
        let centerPt = CLLocationCoordinate2D.init(latitude: pinLatValCLLC, longitude: pinLongValCCLC)
        let region = MKCoordinateRegion.init(center: centerPt, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
            
        
        // TODO 09-05-2020: CHECK TO SEE IF EXISTING PIN HAS PHOTOS STORED.  IF NOT THE FETCH PICS
        

                  
        self.MapSelectedLocationMKView.setRegion(region, animated: true)
        DispatchQueue.global(qos: .userInitiated).async
        {
                VirtualTouristClient.GetPhotosForLatLon(latVal: pinLatVal, lonVal: pinLonVal)
                {
                    (data,error) in guard let data = data else
                    {
                        return
                    }
                    
                    if data.photo.count > 0
                    {
                        self.totalPhotoCnt = data.photo.count
                        self.pinPhotoInfo = data.photo
                        self.PhotoCollectionView.reloadData()
                    }
                    else
                    {
                        self.NoPhotoLabel.isHidden = false
                    }
                }
                    
                    
            
                    print("DATA TEST")
                    //print("ERROR 3\(error?.localizedDescription)")
                    //print("ERROR 4\(error)")
        }
       
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        loadPicsForLatLon(pinLatVal: latVal, pinLonVal: lonVal)
        
        // Do any additional setup after loading the view.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return pinPhotoInfo.count
    }
      
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! locationPicCell
        
        let activityView = UIActivityIndicatorView(style: .medium)
        

        //cell.cellImageVal.addSubview(fadeView)

        cell.addSubview(activityView)
        activityView.hidesWhenStopped = true
        activityView.frame = cell.bounds
        //activityView.center = cell.view.center
        
        //guard let url = URL(string: self.pinPhotoInfo[indexPath.row].urlT) else { return cell }
        
        
        //cell.cellImage.image = nil // set(image: nil)
                 
        /*DispatchQueue.global().async
        {
            let data = try? Data(contentsOf: url)
                     
            if let data = data, let image = UIImage(data: data)
            {
                
                DispatchQueue.main.async
                {
                    
                    //cell.cellImage.image = image
                    cell.cellImageVal.image = image
                    activityView.stopAnimating()
                }
            }
        }*/
                 
                 
                 
                 
                 if pinPhotoInfo.count > 0
                 {
                     
                      activityView.startAnimating()
                     // Start background thread so that image loading does not make app unresponsive
                     DispatchQueue.global(qos: .userInitiated).async
                     {
                        let tempPhoto = self.pinPhotoInfo[indexPath.row]
                        let imageUrl:URL = URL(string: tempPhoto.urlT)!
                        guard let imageData:NSData = NSData(contentsOf: imageUrl) else{
                            return
                        }
                        
                        guard let cellImageVal = UIImage(data: imageData as Data) else {
                                    
                                    return
                                    }
                        // TODO 09-05-2020 ADD PHOTOS TO PIN IN COREDATA
                        let photoInfo = PhotoInfo(context:self.dataController.viewContext)
                        
                        photoInfo.url_t = imageUrl
                        photoInfo.image = imageData as Data
                        
                        // When from background thread, UI needs to be updated on main_queue
                        DispatchQueue.main.async
                        {
                            self.photoAddedCnt = self.photoAddedCnt + 1
                            if self.totalPhotoCnt == self.photoAddedCnt {
                                self.RequestNewCollectionBtn.isEnabled = true
                            }
                            
                            
                            activityView.stopAnimating()
                            activityView.isHidden = true
                            cell.cellImageVal.image = cellImageVal
                             /* imageView.image = image
                             imageView.contentMode = UIViewContentMode.scaleAspectFit
                             self.view.addSubview(imageView)*/
                         }
                     }
                 }
        
        
                 return cell
             
      }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
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
