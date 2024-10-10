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
        tableView.backgroundColor = .clear
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
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    private let backGroundImage : UIImageView = {
        let backGroundImageView = UIImageView(image: .chatbackground)
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        return backGroundImageView
    }()
    private func setUpViews(){
        view.addSubview(backGroundImage)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            backGroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backGroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backGroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backGroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setUpMessageListeners(){
        let delay = 200
        viewModel.$messages
            .debounce(for: .milliseconds(delay), scheduler:DispatchQueue.main)
            .sink {[weak self] _ in
            self?.tableView.reloadData()
            }.store(in: &subscriptions)
        
        viewModel.$scrollToBottomRequest
            .debounce(for: .milliseconds(delay), scheduler:DispatchQueue.main)
            .sink {[weak self] scrollRequest in
                if scrollRequest.scroll {
                    self?.tableView.scrollToLastRow(at: .bottom, animated: scrollRequest.isAnimated)
                }
            }.store(in: &subscriptions)
    }
}

extension MessageListController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let message = viewModel.messages[indexPath.row]
        cell.contentConfiguration = UIHostingConfiguration {
            switch message.type {
            case .text :
                BubbleTextView(item: message)
            case .photo,.video :
                BubbleImageView(item: message)
            case .audio :
                BubbleAudioView(item : message)
            case .admin(let type):
                switch type {
                case .channelCreation:
                    ChannelCreationTextView()
                    if viewModel.chat.groupChannel{
                        AdminMessageTextView(chat: viewModel.chat)
                    }
                default:
                    Text("")
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

private extension UITableView {
    func scrollToLastRow(at scrollPosition: UITableView.ScrollPosition, animated: Bool){
        guard numberOfRows(inSection: numberOfSections - 1) > 0 else {return}
        let lastSectionIndex = numberOfSections - 1
        let lastRowIndex = numberOfRows(inSection: lastSectionIndex) - 1
        let lastRowIndexPath = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        scrollToRow(at: lastRowIndexPath, at: scrollPosition, animated: animated)
    }
}

#Preview{
    MessageListView(viewModel: ChatRoomViewModel(.placeholder))
        .ignoresSafeArea()
}
