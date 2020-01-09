//
//  DragAndDropCollectionViewsViewController.swift
//  Drag&DropCollectionView
//
//  Created by Vishwanath Kota on 08/01/2020.
//  Copyright © 2020 Vishwanath Kota. All rights reserved.
//

import UIKit

class DragAndDropCollectionViewsViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var queueOfImagesCollectionView: UICollectionView!
    @IBOutlet weak var carsLapInfoCollectionView: UICollectionView!
    
    //Data Source for queueOfImagesCollectionView-1
    private var items1 = ["none", "chrome", "fade", "falseColor", "instant", "mono", "noir", "process", "sepia", "tonal", "transfer"]
    
    //Data Source for carsLapInfoCollectionView-2
    private var items2 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // queueOfImagesCollectionView-1 drag and drop configuration
        self.queueOfImagesCollectionView.dragInteractionEnabled = true
        self.queueOfImagesCollectionView.dragDelegate = self
        self.queueOfImagesCollectionView.dropDelegate = self
        
        // carsLapInfoCollectionView-2 drag and drop configuration
        self.carsLapInfoCollectionView.dragInteractionEnabled = true
        self.carsLapInfoCollectionView.dragDelegate = self
        self.carsLapInfoCollectionView.dropDelegate = self
        self.carsLapInfoCollectionView.reorderingCadence = .fast
    }
    
    //MARK: Private Methods
    
    /// This method moves a cell from source indexPath to destination indexPath within the same collection view. It works for only 1 item. If multiple items selected, no reordering happens.
    ///
    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: collectionView in which reordering needs to be done.
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView){
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0){
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                if collectionView === self.carsLapInfoCollectionView {
                    self.items2.remove(at: sourceIndexPath.row)
                    self.items2.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                }else {
                    self.items1.remove(at: sourceIndexPath.row)
                    self.items1.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
    
    /// This method copies a cell from source indexPath in 1st collection view to destination indexPath in 2nd collection view. It works for multiple items.
    ///
    /// - Parameters:
    ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
    ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
    ///   - collectionView: collectionView in which reordering needs to be done.
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView){
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                if collectionView == self.carsLapInfoCollectionView{
                    self.items2.insert(item.dragItem.localObject as! String, at: indexPath.row)
                } else {
                    self.items1.insert(item.dragItem.localObject as! String, at: indexPath.row)
                }
                indexPaths.append(indexPath)
            }
        })
    }
    
    @IBAction func customCameraBtn(_ sender: Any) {
        let vc1 = self.storyboard?.instantiateViewController(identifier: "FetchImagesViewController") as! FetchImagesViewController
//        self.navigationController?.pushViewController(vc1, animated: true)
        self.present(vc1, animated: true, completion: nil)
    }
}

// MARK: - UIcollectionViewDataSource Methods
extension DragAndDropCollectionViewsViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.queueOfImagesCollectionView ? self.items1.count : self.items2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.queueOfImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageQueueCollectionViewCell", for: indexPath) as! ImageQueueCollectionViewCell
            cell.carImg.image = UIImage(named: self.items1[indexPath.row])
            cell.carCountLbl.text = String(indexPath.row + 1)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarsLapInfoCollectionViewCell", for: indexPath) as! CarsLapInfoCollectionViewCell
            cell.carImageview.image = UIImage(named: items2[indexPath.row])
            cell.carName.text = self.items2[indexPath.row].capitalized
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate Methods
extension DragAndDropCollectionViewsViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let frameSize = collectionView.frame.size
        return CGSize(width: frameSize.width - 10, height: frameSize.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

// MARK: - UICollectionViewDragDelegate Methods
extension DragAndDropCollectionViewsViewController: UICollectionViewDragDelegate
{
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = collectionView == queueOfImagesCollectionView ? self.items1[indexPath.row] : self.items2[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let item = collectionView == queueOfImagesCollectionView ? self.items1[indexPath.row] : self.items2[indexPath.row]
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        if collectionView == queueOfImagesCollectionView {
            let previewParameters = UIDragPreviewParameters()
            previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 25, y: 25, width: 120, height: 120))
            return previewParameters
        }
        return nil
    }
}


// MARK: - UICollectionViewDropDelegate Methods
extension DragAndDropCollectionViewsViewController: UICollectionViewDropDelegate
{
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView === self.queueOfImagesCollectionView {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: .forbidden)
            }
        } else {
            if collectionView.hasActiveDrag {
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            } else {
                return UICollectionViewDropProposal(operation: UIDropOperation.copy, intent: .insertAtDestinationIndexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last indexpath of collectionview
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation
        {
        case .move:
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            break
        case .copy:
            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        default:
            return
        }
    }
}


