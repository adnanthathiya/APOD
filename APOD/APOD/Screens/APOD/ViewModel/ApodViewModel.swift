//
//  ApodViewModel.swift
//  APOD
//
//  Created by Adnan Thathiya on 04/04/23.
//

import Foundation

public protocol ApodViewModelProtocol: AnyObject {
    var isLoading: Bindable<Bool> { get }
    var isLoadingDataError: Bindable<Bool> { get }
    var apodData: Bindable<ApodData?> { get }

    func viewDidLoad()
    func downloadApodImage(with url: String, completion: @escaping (_ imageData: Data?) -> Void)
}

class ApodViewModel: ApodViewModelProtocol {

    let isLoading = Bindable<Bool>(false)
    var isLoadingDataError = Bindable<Bool>(false)
    var apodData = Bindable<ApodData?>(nil)

    var repo: CDApodDataRepository

    init(repo: CDApodDataRepository) {
        self.repo = repo
    }

    //MARK: - View Methods
    func viewDidLoad() {
        getApodData()
    }

    func getApodData() {
        switch NetworkReachability.isInternet() {
        case true:
            getApodDataFromAPI()
        case false:
            guard let cdApodData = fetchTodayApodDataFromDB()
            else {
                self.isLoadingDataError.update(true)
                return
            }
                
            self.apodData.update(.init(title: cdApodData.title,
                                        explanation: cdApodData.explanation,
                                        url: "",
                                        mediaType: cdApodData.mediaType,
                                        date: cdApodData.date,
                                        imagePath: cdApodData.imagePath))
        }
    }
}

// MARK: - Store Data Methods
extension ApodViewModel {
    func fetchTodayApodDataFromDB() -> CDApodData? {
        return repo.getCDApodData(by: Date.today())
    }

    func saveApodDataToDB(apodData: ApodData) {
        _ = repo.save(with: apodData)
    }

    func saveImageToDocumentFolder(with imageData: Data, and url: URL) {
        do {
            let saveImageUrl = try FileManager.saveImage(with: imageData,
                                                         in: Folder.ApodImages,
                                                         with: url.lastPathComponent)

            // update to db
            update(imagePath: saveImageUrl?.path)
            guard let apodData = self.apodData.value else { return }
            _ = repo.update(with: apodData)

        } catch let error {
            debugPrint(error)
        }
    }

    func update(imagePath: String?) {
        self.apodData.update {
            $0?.imagePath = imagePath
        }
    }
}

//MARK: - API
extension ApodViewModel {
    private func getApodDataFromAPI() {
        isLoading.update(true)
        NetworkManager.shared.requestData(ApodData.getApodDataRequest()) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let apodData):
                    self.isLoading.update(false)
                    self.apodData.update(apodData)
                    self.saveApodDataToDB(apodData: apodData)
                case .failure(let error):
                    print(error.localizedDescription)
                    self.isLoading.update(false)
                }
            }
        }
    }

    func downloadApodImage(with url: String, completion: @escaping (_ imageData: Data?) -> Void) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global(qos: .utility).async {
            let data = try? Data(contentsOf: imageURL)
            DispatchQueue.main.async { [weak self] in
                guard let self = self,
                      let data = data
                else {
                    completion(nil)
                    return
                }
                completion(data)
                self.saveImageToDocumentFolder(with: data, and: imageURL)
            }
        }
    }
}
