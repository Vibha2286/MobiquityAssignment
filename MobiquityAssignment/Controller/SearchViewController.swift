//
//  SearchViewController.swift
//  MobiquityAssignment
//
//  Created by Vibha Mangrulkar (ZA) on 2021/09/17.
//

import UIKit
import ProgressHUD

class SearchViewController: UICollectionViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    private lazy var viewModel = SearchViewModel(delegate: self,
                                                 searchImageInteractor: SearchFlickrImageInteractor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    /// configure ui by retriving images from server
    private func configureUI() {
        fetchImages(tag: viewModel.tag)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "history.Button.title".localized(),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(historyButtonTapped))
    }
    
    fileprivate func configureList(title: String) {
        viewModel.resetImagesData
        viewModel.tag = title
        searchTextField.resignFirstResponder()
        searchTextField.text = title
        collectionView?.reloadData()
    }
    
    /// present history controller by tapping on history button
    @objc private func historyButtonTapped() {
        searchTextField.resignFirstResponder()
        performSegue(withIdentifier: "HistorySegue", sender: nil)
    }
    
    /// prepare segue to navigate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "HistorySegue" {
            guard let historyViewController = segue.destination as? HistoryViewController else { return }
            historyViewController.setData(delegate: self)
        }
    }
}

// MARK: - Data Source

extension SearchViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! FlickrImageCell
        
        guard viewModel.imageData.count != 0 else { return cell }
                
        let urlString = viewModel.imageData[indexPath.row].imagePath() ?? ""
        viewModel.retriveImageFromString(urlString) { (image) in
            cell.imageView.image = image
        } failure: {_ in
            DispatchQueue.main.async {
                cell.imageView.image = UIImage(named: "placeholder")
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.imageData.count - Constants.reloadCount {
            fetchImages(tag: viewModel.tag)
        }
    }
}

// MARK: - Flow Layout Delegate

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  30
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
}

// Mark:- Fetch image data from API

extension SearchViewController {
    
    func fetchImages(tag: String) {
        viewModel.pageCount += 1
        ProgressHUD.show("loading.Image".localized())
        viewModel.fetchImageWithString(tag) {
            DispatchQueue.main.async { [weak self] in
                ProgressHUD.dismiss()
                self?.collectionView?.reloadData()
            }
        } failure: {_ in
            ProgressHUD.dismiss()
        }
    }
}

// Mark:- UITextFieldDelegate

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        configureList(title: textField.text ?? "kitten")
        guard let text = textField.text, !text.isEmpty else { return true }
        fetchImages(tag: viewModel.tag)
        return true
    }
}

// Mark:- SearchViewModelDelegate

extension SearchViewController: SearchViewModelDelegate {
    
    func reloadWithHistoryTag(_ title: String) {
        configureList(title: title)
        fetchImages(tag: viewModel.tag)
    }

    func showErrorMessage(_ errorMessage: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "error.alert.title".localized(), message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok.Button.title".localized(), style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
