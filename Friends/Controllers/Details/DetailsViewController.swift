//
//  DetailsViewController.swift
//  Friends
//
//  Created by Emiray Nakip on 4.11.2021.
//

import UIKit
import Kingfisher
enum Types: String, CaseIterable {
    case name
    case gender
    case dob
    case phone
    case cell
    case mail
    case address
    case coordinate
}

class DetailsViewController: UIViewController {

    // MARK: - Variables
    private var collectionViewDetailList : UICollectionView!
    
    let array : [Types] = Types.allCases
    
    let viewmodel: ListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.showNavigationBar()
    }
    
    init(viewmodel:ListViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private func setupUI() {
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        
        collectionViewDetailList = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionViewDetailList.backgroundColor = .myWhite
        
        collectionViewDetailList.dataSource = self
        collectionViewDetailList.delegate = self
        
        collectionViewDetailList.register(DetailCollectionViewCell.self,
                                          forCellWithReuseIdentifier: DetailCollectionViewCell.className)
        
        collectionViewDetailList.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionViewDetailList)
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionViewDetailList.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0.0),
            collectionViewDetailList.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0.0),
            collectionViewDetailList.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0.0),
            collectionViewDetailList.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0.0),
        ])
        
        collectionViewDetailList.reloadData()
    }
    
}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.className, for: indexPath) as? DetailCollectionViewCell {
            
            let cellviewmodel = CellViewModel(types: array[indexPath.row], viewmodel: self.viewmodel, viewcontroller: self)
            
            cell.configure(cellviewmodel)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellviewmodel = CellViewModel(types: array[indexPath.row], viewmodel: self.viewmodel, viewcontroller: self)
        cellviewmodel.selectRelated()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height : CGFloat = 60.0
        
        if array[indexPath.row] == .address {
            height = 100.0
        }
        
        let maxWidth = UIScreen.main.bounds.width
        
        return CGSize(width: maxWidth - 14.0, height: height)
        
    }
    
}

// MARK: - VM
class CellViewModel {
    let types : Types
    let viewmodel: ListViewModel
    let viewcontroller: UIViewController
    
    init(types:Types, viewmodel: ListViewModel, viewcontroller:UIViewController) {
        self.types = types
        self.viewmodel = viewmodel
        self.viewcontroller = viewcontroller
    }
    
}

extension CellViewModel {
    func getRelated() -> String {
        switch types {
        case .name:
            return viewmodel.title+" "+viewmodel.fName+" "+viewmodel.lName
        case .address:
            return viewmodel.address
        case .cell:
            return viewmodel.cell+"\nTap for call."
        case .coordinate:
            return viewmodel.coord
        case .dob:
            return viewmodel.dob_formatted+"\nAge: "+viewmodel.dob_age
        case .mail:
            return viewmodel.email+"\nTap for email."
        case .gender:
            return viewmodel.gender
        case .phone:
            return viewmodel.phone+"\nTap for call."
        }
    }
    
    func selectRelated() {
        switch types {
        case .cell:
            let trimNumber = viewmodel.cell.replacingOccurrences(of: "-", with: "")
            self.callOrMail(type: "tel", text: trimNumber)
        case .phone:
            let trimNumber = viewmodel.phone.replacingOccurrences(of: "-", with: "")
            self.callOrMail(type: "tel", text: trimNumber)
        case .mail:
            self.callOrMail(type: "mailto", text: viewmodel.email)
        case .coordinate:
            let mapVC : MapViewController = MapViewController()
            mapVC.showController(parentVc: viewcontroller, viewmodel: viewmodel)
            break
        default:
            break
        }
    }
    
    var imagename: String {
        if types == .address || types == .coordinate {
            return "location"
        }
        if types == .name {
            return viewmodel.pictureThumbnail
        }
        return types.rawValue
    }
    
    private func callOrMail(type:String, text:String) {
        guard let url = URL(string: type+"://\(text)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}

// MARK: - Detail Collection View Cell
class DetailCollectionViewCell: UICollectionViewCell {
    
    // MARK:  Variables
    private let viewContainer: UIView = {
        let vw = UIView()
        vw.backgroundColor = .myLightBlue
        vw.setBorder(width: 2.0, color: .myDarkBlue)
        vw.setCornerRound(value: 6.0)
        return vw
    }()
    
    private let imageviewIcon: UIImageView = {
        let imgvw = UIImageView()
        imgvw.contentMode = .scaleAspectFit
        imgvw.clipsToBounds = true
        imgvw.translatesAutoresizingMaskIntoConstraints = false
        return imgvw
    }()
    
    private let labelTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.textColor = .myDarkBlue
        lbl.numberOfLines = 0
        lbl.font = .semiBoldFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(viewContainer)
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        viewContainer.addSubview(imageviewIcon)
        viewContainer.addSubview(labelTitle)
        
        NSLayoutConstraint.activate([
            viewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4.0),
            viewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4.0),
            viewContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            viewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4.0),
            imageviewIcon.heightAnchor.constraint(equalToConstant: 35),
            imageviewIcon.widthAnchor.constraint(equalToConstant: 35),
            imageviewIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageviewIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            labelTitle.leadingAnchor.constraint(equalTo: imageviewIcon.trailingAnchor, constant: 4.0),
            labelTitle.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -8.0),
            labelTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            labelTitle.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            labelTitle.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure(_ viewmodel : CellViewModel) {
       
        if viewmodel.imagename.contains("http") {
            imageviewIcon.kf.setImage(with: URL(string: viewmodel.imagename))
        } else {
            imageviewIcon.image = UIImage(named: viewmodel.imagename)?.withColor(.myDarkBlue)
        }
        
        labelTitle.text = viewmodel.getRelated()
    }
    
}
