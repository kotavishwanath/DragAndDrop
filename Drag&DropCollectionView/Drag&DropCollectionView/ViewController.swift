//
//  ViewController.swift
//  Drag&DropCollectionView
//
//  Created by Vishwanath Kota on 07/01/2020.
//  Copyright © 2020 Vishwanath Kota. All rights reserved.
//  https://www.youtube.com/watch?v=GyKYiHrXeBk

import UIKit

class ViewController: UIViewController {

    fileprivate var longpressGesture: UILongPressGestureRecognizer!
    @IBOutlet weak var carsListCollectionView: UICollectionView!
    var carsArray = ["1","2","3","4","5","6","7","8","9","10","11"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(self.view.frame.size.width)
        print(self.view.frame.size.height)
//        carsListCollectionView.backgroundColor = UIColor.red
        longpressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        carsListCollectionView.addGestureRecognizer(longpressGesture)
    }
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer){
        switch (gesture.state) {
        case .began:
            guard let selectedIndexPath = carsListCollectionView.indexPathForItem(at: gesture.location(in: carsListCollectionView)) else {
                break
            }
            carsListCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            carsListCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            carsListCollectionView.endInteractiveMovement()

        default:
            carsListCollectionView.cancelInteractiveMovement()
        }
    }
}

extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarsListCollectionViewCell", for: indexPath) as! CarsListCollectionViewCell
        cell.carName.text = carsArray[indexPath.row]
        cell.carImg.image = UIImage(named: "car1")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 122)
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = carsArray.remove(at: sourceIndexPath.item)
        carsArray.insert(item, at: destinationIndexPath.item)
        print(carsArray)
        carsListCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc1 = self.storyboard?.instantiateViewController(identifier: "DragAndDropCollectionViewsViewController") as! DragAndDropCollectionViewsViewController
        self.navigationController?.pushViewController(vc1, animated: true)
        
    }
}
