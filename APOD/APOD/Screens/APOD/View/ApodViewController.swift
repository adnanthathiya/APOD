//
//  ApodViewController.swift
//  APOD
//
//  Created by Adnan Thathiya on 04/04/23.
//

import UIKit

class ApodViewController: UIViewController {

    // MARK: - @IBOutlet
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var viewModel: ApodViewModel = ApodViewModel(repo: CDApodDataRepository())

    override func viewDidLoad() {
        super.viewDidLoad()

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
                self.view.isUserInteractionEnabled = false
            } else {
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
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
