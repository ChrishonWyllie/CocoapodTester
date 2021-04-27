//
//  ViewController.swift
//  CocoapodTester
//
//  Created by Chrishon Wyllie on 7/17/20.
//  Copyright © 2020 Chrishon Wyllie. All rights reserved.
//

import UIKit
import ComposableDataSource
import Celestial

class ViewController: UIViewController {
    
    // MARK: - Variables
    
    private var dataSource: ComposableCollectionDataSource?
    
    private let imagesURLString: String = "https://picsum.photos/v2/list?limit=25"
    
    private var imageCellModels: [BaseCollectionCellModel]  = []
    
    private var videoCellModels: [BaseCollectionCellModel] {
        let urlStrings: [String] = [
            "https://d21m91m763fb64.cloudfront.net/videos/8acab1c0-7cb0-11eb-821a-9b4798e5df00-8secondz-video.mp4",
           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
//           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
//           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
//           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
//           "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"
       ]
       
       return urlStrings.map { VideoCellModel(urlString: $0) }
    }
    
    
    
    
    
    // MARK: - UI Elements
    
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = UIColor.systemGray3
        } else {
            // Fallback on earlier versions
            collectionView.backgroundColor = .gray
        }
        collectionView.allowsSelection = true
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    private lazy var addItemsButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItems))
        return btn
    }()
    
    private lazy var updateItemsButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(updateItems))
        return btn
    }()
    
    private lazy var deleteItemsButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteItems))
        return btn
    }()
    
    
    
    
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.rightBarButtonItems = [deleteItemsButton, updateItemsButton, addItemsButton]
        
        setupCollectionView()
        dataSource = setupDataSource()
        
//        fetchImagesData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Setup functions

extension ViewController {
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setupDataSource() -> ComposableCollectionDataSource {
            
//        let models: [[BaseCollectionCellModel]] = [[]]
//        let supplementaryModels: [GenericSupplementarySectionModel] = []
        let models: [[BaseCollectionCellModel]] = [videoCellModels]
        let supplementaryModels: [BaseSupplementarySectionModel] = [BaseSupplementarySectionModel(header: HeaderItemModel(title: "Videos"), footer: nil)]
        
        let dataSource = CustomComposableDataSource(collectionView: collectionView,
                                                        cellItems: models,
                                                        supplementarySectionItems: supplementaryModels)
        .didSelectItem { (indexPath: IndexPath, model: BaseCollectionCellModel) in
            print("selected model: \(model) at indexPath: \(indexPath)")
        }.referenceSizeForHeader{ (section: Int, supplementaryViewModel: BaseCollectionSupplementaryViewModel) -> CGSize in
            return CGSize.init(width: self.collectionView.frame.size.width, height: 60.0)
        }.prefetchItems { (indexPaths: [IndexPath], models: [BaseCollectionCellModel]) in
            let models = models as! [URLCellModel]
            Celestial.shared.prefetchResources(at: models.map { $0.urlString} )
        }.cancelPrefetchingForItems { (indexPaths: [IndexPath], models: [BaseCollectionCellModel]) in
            let models = models as! [URLCellModel]
            Celestial.shared.pausePrefetchingForResources(at: models.map { $0.urlString}, cancelCompletely: false)
        }
        
        let emptyView = UILabel()
        emptyView.text = "Still loading data... :)"
        emptyView.font = UIFont.boldSystemFont(ofSize: 25)
        emptyView.numberOfLines = 0
        emptyView.textAlignment = .center
        
        dataSource.emptyDataSourceView = emptyView
        return dataSource
    }
}

// MARK: - CRUD functions

extension ViewController {
    
    @objc private func addItems() {
//        let headerModel = HeaderItemModel(title: "Videos")
//        let supplementarySectionItem = GenericSupplementarySectionModel(header: headerModel, footer: nil)
//
//        dataSource?.insertNewSection(withCellItems: videoCellModels, supplementarySectionItem: supplementarySectionItem, atSection: 0, completion: nil)
        
    }
    
    @objc private func updateItems() {
        let randomNumber = Int.random(in: 0...1)
        let section: Int = 0
        let headerTitle: String = randomNumber == 0 ? imagesURLString : "Videos"
        let headerModel = HeaderItemModel(title: headerTitle)
        let supplementarySectionItem = BaseSupplementarySectionModel(header: headerModel, footer: nil)
        let models: [BaseCollectionCellModel] = randomNumber == 0 ? imageCellModels : videoCellModels

        dataSource?.updateSections(atItemSectionIndices: [section],
                                   newCellItems: [models],
                                   supplementarySectionIndices: [section],
                                   supplementarySectionItems: [supplementarySectionItem],
                                   completion: nil)
    }
    
    @objc private func deleteItems() {
        dataSource?.deleteSections(atSectionIndices: [0], completion: nil)
    }
    
    private func fetchImagesData() {
        
        guard let url = URL(string: imagesURLString) else {
            return
        }
        
        var supplementaryModels: [BaseSupplementarySectionModel] = []
        
        let group = DispatchGroup()
        
        group.enter()
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            let headerModel = HeaderItemModel(title: self?.imagesURLString ?? "Images")
            let containerModel = BaseSupplementarySectionModel(header: headerModel, footer: nil)
            supplementaryModels.append(containerModel)
            
            guard let data = data else { return }
            do {
                guard let jsonDataArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [[String: AnyObject]] else {
                    return
                }
                
                jsonDataArray.forEach { (jsonObject) in
                    let urlSessionObject = URLSessionObject(object: jsonObject)
                    self?.imageCellModels.append(ImageCellModel(urlString: urlSessionObject.downloadURL))
                }
                
                group.leave()
                
            } catch let error {
                print("error converting data to json: \(error)")
            }
            
        }.resume()
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.dataSource?.replaceDataSource(withCellItems: [strongSelf.imageCellModels],
                                                     supplementarySectionItems: supplementaryModels,
                                                     completion: nil)
        }
    }
}

fileprivate struct URLSessionObject {
    let author: String
    let downloadURL: String
    let height: NSNumber
    let id: NSNumber
    let url: String
    let width: NSNumber
    
    init(object: [String: AnyObject]) {
        author = object["author"] as? String ?? ""
        downloadURL = object["download_url"] as? String ?? ""
        height = object["height"] as? NSNumber ?? 0
        id = object["id"] as? NSNumber ?? 0
        url = object["url"] as? String ?? ""
        width = object["width"] as? NSNumber ?? 0
    }
}


class CustomComposableDataSource: ComposableCollectionDataSource, VideoCellDelegate {
    
    private var cellSizes:  [IndexPath: CGSize] = [:]
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        (cell as? VideoCell)?.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let calculatedSize = cellSizes[indexPath] {
            return calculatedSize
        }
        // Otherwise, use a default size
        return CGSize(width: getNonDynamicCellWidth(), height: 400.0)
    }
    
    func videoCell(_ cell: VideoCell, requestsContainerSizeChanges requiredSize: CGSize) {
        let indexPath: IndexPath
        
        if let indexPathForCell = collectionView.indexPath(for: cell) {
            indexPath = indexPathForCell
        } else {
            // The UICollectionView cannot reach this cell, as it may not have been dequeued yet (or it has been recycled)
            let urlString = cell.playerView.sourceURL?.absoluteString
            let section: Int = 0
            guard let cellModels = self.cellModels(inSection: section) as? [VideoCellModel] else {
                print("Cell models: \(self.cellModels(inSection: section))")
                return
            }
            guard let arrayElementIndex = cellModels.firstIndex(where: { $0.urlString == urlString }) else {
                // This is virtually guaranteed since there must exist a cellModel where its urlString
                // is the same as the one that this VideoCell's playerView is using.
                return
            }
            let index = Int(arrayElementIndex)
            indexPath = IndexPath(item: index, section: section)
        }
        
        updateSize(forCell: cell, withVideoSize: requiredSize, atIndexPath: indexPath)
    }
    
    private func updateSize(forCell cell: VideoCell, withVideoSize videoSize: CGSize, atIndexPath indexPath: IndexPath) {
        let cellModels = self.cellModels(inSection: 0) as! [VideoCellModel]
        let cellModel = cellModels[indexPath.item]
        
        // NOTE
        
        let totalWidthOfTitleLabel: CGFloat = getNonDynamicCellWidth() - (Constants.horizontalPadding * 4)
        let urlStringTextFrame: CGRect = cellModel.urlString.estimateFrameForText(with: UIFont.systemFont(ofSize: 17),
                                                                                  desiredTextWidth: totalWidthOfTitleLabel)
        let titleLabelHeight: CGFloat = urlStringTextFrame.height
        
        let progressLabelHeight: CGFloat = Constants.progressLabelHeight
        let progressBarHeight: CGFloat = 4 // this is the default height for a UIProgressBar
        let totalVerticalPadding: CGFloat = cell.getTotalVerticalPadding()
        
        let calculatedHeight =  videoSize.height    +
                                titleLabelHeight    +
                                progressLabelHeight +
                                progressBarHeight   +
                                totalVerticalPadding
        
        let calculatedSize = CGSize(width: getNonDynamicCellWidth(), height: calculatedHeight)
        
        if cellSizes[indexPath] != nil {
            return
        }
        
        cellSizes[indexPath] = calculatedSize
        
        // Animate the cell size change
        collectionView.performBatchUpdates({
            collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    
    private func getNonDynamicCellWidth() -> CGFloat {
        return collectionView.frame.size.width
    }
}


extension String {
    func estimateFrameForText(with font: UIFont, desiredTextWidth: CGFloat? = nil) -> CGRect {
        let someArbitraryWidthValue: CGFloat = 200
        let size = CGSize(width: desiredTextWidth ?? someArbitraryWidthValue, height: 1000)
        let options = NSStringDrawingOptions
            .usesFontLeading
            .union(.usesLineFragmentOrigin)
        return NSString(string: self)
            .boundingRect(with: size,
                          options: options,
                          attributes: [NSAttributedString.Key.font: font],
                          context: nil)
    }
}
