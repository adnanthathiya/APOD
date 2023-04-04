//
//  ApodViewController.swift
//  APOD
//
//  Created by Adnan Thathiya on 04/04/23.
//

import UIKit

class ApodViewController: UIViewController {

    private enum Constants {
        static let title = "APOD"
        static let loadingDataErrorTitle = "Error while loading"
        static let loadingDataErrorDescription = "We are not connected to the internet, showing you the last image we have."
        static let alertActionOk = "Ok"
    }

    // MARK: - @IBOutlet
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var viewModel: ApodViewModel = ApodViewModel(repo: CDApodDataRepository())

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeView()
        bind()
        viewModel.viewDidLoad()
    }
    
    func bind() {
        viewModel.apodData.bindAndApply { [weak self] apodData in
            guard let self = self,
                  let apodData = apodData
            else { return }
            self.updateView(with: apodData)
        }

        viewModel.isLoading.bind { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }

        viewModel.isLoadingDataError.bind { [weak self] isLoadingDataError in
            guard let self = self else { return }
            if isLoadingDataError {
                self.showLoadDataError()
            }
        }
    }
}

// MARK: - Layout
private extension ApodViewController {
    func initializeView() {
        setupTitle()
    }

    func setupTitle() {
        self.title = Constants.title
    }
}

// MARK: - Update View
private extension ApodViewController {
    func updateView(with apodData: ApodData) {
        self.titleLabel.text = apodData.title
        self.descriptionLabel.text = apodData.explanation

        if let copyrightText = apodData.copyright {
            self.copyrightLabel.text = "©\(copyrightText)"
        }

        if let imagePath = apodData.imagePath {
            self.photoImageView.image = UIImage(contentsOfFile: imagePath)
        } else {
            self.viewModel.downloadApodImage(with: apodData.url) { [weak self] imageData in
                guard let self = self,
                      let imageData = imageData,
                      let image = UIImage(data: imageData)
                else { return }

                self.photoImageView.image = image
            }
        }
    }
}

// MARK: - Show Error
private extension ApodViewController {
    func showLoadDataError() {
        let alertController = UIAlertController(title: Constants.loadingDataErrorTitle,
                                                message: Constants.loadingDataErrorDescription,
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: Constants.alertActionOk, style: .cancel) { [weak self] action in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }

        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}
