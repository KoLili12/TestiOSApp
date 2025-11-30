//
//  ViewModel.swift
//  TestiOSApp
//
//  Created by Николай Жирнов on 28.11.2025.
//

import Foundation

final class ViewModel {
    private let service: NetworkService
    
    var items: [Item] = []
    
    var onDataLoaded: (([Item]) -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingChanged: ((Bool) -> Void)?
    
    init(service: NetworkService) {
        self.service = service
    }
    
    func loadItems() {
        onLoadingChanged?(true)
        service.loadData(url: Endpoint.items.url, type: [Item].self) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoadingChanged?(false)
                switch result {
                case .success(let items):
                    StorageManager.shared.addItemsInCoreData(items: items)
                    self?.items = items
                    self?.onDataLoaded?(items)
                case .failure(let error):
                    self?.onError?("Error: \(error)")
                }
            }
        }
    }
    
    func loadItemsFromCoreData() {
        items = StorageManager.shared.fetchItemsFromCoreData()
        onDataLoaded?(items)
    }
}
