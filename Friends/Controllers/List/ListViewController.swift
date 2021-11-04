//
//  ListViewController.swift
//  Friends
//
//  Created by Emiray Nakip on 4.11.2021.
//

import UIKit
import Alamofire
import RealmSwift

class ListViewController: UIViewController {

    // MARK: - Variables
    private var collectionViewList : UICollectionView!
    private let delegate = ListCollectionViewDelegate(numberOfItemPerRow: 2, interItemSpacing: 7, itemHeight: 180)
    
    private var resultsViewModel : ResultsViewModel!
    
    private var page : Int = 1
    
    // MARK: - Life Cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .myWhite
        self.showNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(signOutTap))
        
        self.getAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.configureNavigationBar(largeTitleColor: .myDarkBlue, backgoundColor: .myAqua, tintColor: .myDarkBlue, title: "List", preferredLargeTitle: false)
    }
    
    
    // MARK: - UI
    private func setupUI() {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        
        collectionViewList = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionViewList.backgroundColor = .myWhite
        
        collectionViewList.dataSource = self
        collectionViewList.delegate = delegate
        
        
        collectionViewList.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.className)
        
        collectionViewList.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionViewList)
        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionViewList.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0.0),
            collectionViewList.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0.0),
            collectionViewList.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0.0),
            collectionViewList.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0.0),
        ])
    }

    // MARK: - Api Call
    private func getAll() {
        
        self.startActivityIndicator(mainView: self.view)
        
        let groupCollectionViews = DispatchGroup()
        groupCollectionViews.enter()
        
        self.getAllList(page: page) { [weak self] (model) in
            guard let self = self else { return
            }
            if let results = model?.results {
                self.resultsViewModel = ResultsViewModel(results: results)
                self.delegate.loadMoreDelegate = self
                self.delegate.resultsViewModel = self.resultsViewModel
            }
            
            groupCollectionViews.leave()
        }
        
        groupCollectionViews.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                
                self.stopActivityIndicator()
                
                self.setupUI()
                
                
                self.collectionViewList.reloadData()
            }
        }
        
        self.storeModels()

    }
    
    private func getAllList(page:Int, completion: @escaping (ListModel?) -> Void) {
        
        let params : Parameters = ["results":20, "page":page]
        
        NetworkLayer.request(Router.list(params)).responseDecodable(of: ListModel.self) { (response) in
            self.stopActivityIndicator()
            
            switch response.result {
            case .failure(let error):
                Logger.shared.debugPrint("Error while fetching tags: \(String(describing: error))")
                completion(nil)
                return
            case .success(let response):
                completion(response)
            }
        }
    }
    
    // MARK: - Realm Call
    private func storeModels() {
        let params : Parameters = ["results":20, "page":1]
        NetworkLayer.request(Router.list(params)).responseDecodable(of: StoredListModel.self) { (response) in
            self.stopActivityIndicator()
            
            switch response.result {
            case .failure(let error):
                Logger.shared.debugPrint("Error while fetching tags: \(String(describing: error))")
               
                return
            case .success(let response):
                RealmManager.sharedInstance.save(object: response)
                break
                
            }
        }
    }
    
    // MARK: - Actions
    @objc private func signOutTap(_ sender : Any) {
        UserDefaultsManager.shared.signOutUser()
        self.navigationController?.popToRootViewController(animated: false)
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsViewModel.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.className, for: indexPath) as? ListCollectionViewCell {
            
            let viewmodel = resultsViewModel.modelAt(indexPath.row)
            
            cell.configure(viewmodel)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}

// MARK: Load More
extension ListViewController: ListCollectionLoadMoreDelegate {
    func laodMore(value: Bool) {
        if value {
            
            page = page + 1
            
            self.getAllList(page: page) { [weak self] (model) in
                
                if let results = model?.results {
                    
                    self?.delegate.resultsViewModel = ResultsViewModel(results: (self?.resultsViewModel.append(appendResults: results))!)
                }
                
                self?.collectionViewList.reloadData()
            }
        }
    }
    
    func didSelect(selectedIndex: Int) {
        print("\(selectedIndex)")
        let selectedVM : ListViewModel = resultsViewModel.modelAt(selectedIndex)
        let detailVC : DetailsViewController = DetailsViewController(viewmodel: selectedVM)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

// MARK: - List Collection View Cell
import Kingfisher

class ListCollectionViewCell: UICollectionViewCell {
    
    // MARK:  Variables
    private let stackviewContent: UIStackView = {
        let stackvw = UIStackView()
        stackvw.spacing = 1
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        return stackvw
    }()
    
    private let imageviewProfile: UIImageView = {
        let imgvw = UIImageView()
        imgvw.contentMode = .scaleAspectFill
        imgvw.layer.cornerRadius = 10
        imgvw.clipsToBounds = true
        return imgvw
    }()
    
    private let labelFnmae: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .myDarkBlue
        lbl.font = .regularFont(ofSize: 16)
        return lbl
    }()
    
    private let labelLname: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .myDarkBlue
        lbl.font = .regularFont(ofSize: 16)
        return lbl
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.backgroundColor = .myLightBlue
        contentView.setBorder(width: 2.0, color: .myDarkBlue)
        contentView.setCornerRound(value: 6.0)
        
        addSubview(stackviewContent)
        stackviewContent.translatesAutoresizingMaskIntoConstraints = false
        
        stackviewContent.addArrangedSubview(imageviewProfile)
        stackviewContent.addArrangedSubview(labelFnmae)
        stackviewContent.addArrangedSubview(labelLname)
        
        NSLayoutConstraint.activate([
            stackviewContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 7.0),
            stackviewContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7.0),
            stackviewContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7.0),
            stackviewContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7.0),
            imageviewProfile.heightAnchor.constraint(equalToConstant: 80),
            labelFnmae.heightAnchor.constraint(equalToConstant: 20),
            labelLname.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configure(_ viewmodel : ListViewModel) {
        self.labelFnmae.text = viewmodel.fName
        self.labelLname.text = viewmodel.lName
        self.imageviewProfile.kf.setImage(with: URL(string: viewmodel.pictureLarge))
    }
}
