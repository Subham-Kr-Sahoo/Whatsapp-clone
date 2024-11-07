//
//  MessageListController.swift
//  Whatsapp-Clone
//
//  Created by Subham  on 17/09/24.
//

import Foundation
import UIKit
import SwiftUI
import Combine
import Kingfisher

final class MessageListController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        messageCollectionView.backgroundColor = .clear
        view.backgroundColor = .clear
        setUpViews()
        setUpMessageListeners()
    }
    init(_ viewModel:ChatRoomViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    deinit{
        subscriptions.forEach {$0.cancel()}
        subscriptions.removeAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let viewModel:ChatRoomViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let cellIdentifier = "MessageListControllerCells"
    
    private lazy var pullToRefresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector (refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    private let compositionalLayout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        config.showsSeparators = false
        let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        section.contentInsets.leading = 0
        section.contentInsets.trailing = 0
        section.interGroupSpacing = -10
        return section
    }
    
    private lazy var messageCollectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.selfSizingInvalidation = .enabledIncludingConstraints
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.refreshControl = pullToRefresh
        return collectionView
    }()
    
    private let backGroundImage : UIImageView = {
        let backGroundImageView = UIImageView(image: .chatbackground)
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backGroundImageView
    }()
    private func setUpViews(){
        view.addSubview(backGroundImage)
        view.addSubview(messageCollectionView)
        NSLayoutConstraint.activate([
            backGroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backGroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messageCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            messageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpMessageListeners(){
        let delay = 200
        viewModel.$messages
            .debounce(for: .milliseconds(delay), scheduler:DispatchQueue.main)
            .sink {[weak self] _ in
            self?.messageCollectionView.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.$scrollToBottomRequest
            .debounce(for: .milliseconds(delay), scheduler:DispatchQueue.main)
            .sink {[weak self] scrollRequest in
                if scrollRequest.scroll {
                    self?.messageCollectionView.scrollToLastItem(at: .bottom, animated: scrollRequest.isAnimated)
                }
            }.store(in: &subscriptions)
    }
    
    @objc private func refreshData(){
        messageCollectionView.refreshControl?.endRefreshing()
    }
}

extension MessageListController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        let message = viewModel.messages[indexPath.item]
        let isNewDay = viewModel.isNewDay(for: message, at: indexPath.item)
        let showSenderName = viewModel.showSenderName(for: message, at: indexPath.item)
        cell.contentConfiguration = UIHostingConfiguration {
            BubbleView(message: message, chat: viewModel.chat, isNewDay: isNewDay, showSenderName: showSenderName)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIApplication.dismissKeyboard()
        let message = viewModel.messages[indexPath.row]
        switch message.type {
        case .video:
            guard let videoUrl = message.videoUrl, let videoURL = URL(string: videoUrl) else {return}
            viewModel.showMediaPlayer(videoURL)
        case .photo:
            guard let photo = message.thumbNailUrl
            else {return}
            let text = message.text
            viewModel.showImagePreview(photo, text)
            // as i am using custom audio player so no need of the audio
        default:
            break
        }
    }
    
    func loadImageFromUrl(urlString: String,completion: @escaping (UIImage?) -> Void){
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}

private extension UICollectionView {
    func scrollToLastItem(at scrollPosition: UICollectionView.ScrollPosition, animated: Bool){
        guard numberOfItems(inSection: numberOfSections - 1) > 0 else {return}
        let lastSectionIndex = numberOfSections - 1
        let lastRowIndex = numberOfItems(inSection: lastSectionIndex) - 1
        let lastRowIndexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        scrollToItem(at: lastRowIndexPath, at: scrollPosition, animated: animated)
    }
}

#Preview{
    MessageListView(viewModel: ChatRoomViewModel(.placeholder))
        .ignoresSafeArea()
}
