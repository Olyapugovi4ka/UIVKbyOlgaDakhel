//
//  ChatViewController.swift
//  VKDakhelOlga
//
//  Created by MacBook on 27/08/2019.
//  Copyright © 2019 MacBook. All rights reserved.
//

import UIKit
import MessageKit
import MessageInputBar
import RealmSwift
import Kingfisher

class ChatViewController: MessagesViewController {
    
    public var chatId: Int!
    
    private var messages = [Message]()
    
    let networkingService = NetworkingService(token: Account.shared.token ?? "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(chatId != nil, "Before instantiating chat view controller chat id param should be set.")
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        
       // Account.shared.longPoll.ts = 2
        
           networkingService.receiveUpdates(for: self.chatId) { result in
                switch result {
                case .failure(let error):
                    self.show(error)
                case .success(let message):
                    if let lastMessage = self.messages.last {
                        guard  message.id != lastMessage.id else { return }
                        self.messages.append(message)
                        let section = IndexSet(integer: self.messages.count - 1)
                        DispatchQueue.main.async {
                            self.messagesCollectionView.insertSections(section)
                            self.messagesCollectionView.scrollToBottom(animated: true)
                        }
                    }



                }
            }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        networkingService.getMessages(chatId: chatId) { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .success(let messages):
                self.messages = messages.reversed()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToBottom()
            case.failure(let error):
                self.show(error)
            }
        }
    }
    
}
extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if isMy(message ) {
            return UIColor.vkBlue
        } else {
            return UIColor.vkGray
        }
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isMy(message) ? .bottomRight : .bottomLeft
        return MessageStyle.bubbleTail(corner, .curved)
    }
    
    private func isMy( _ message: MessageType) -> Bool{
        if message.sender.senderId == Account.shared.stringUserId {
            return true
        }
        return false
    }
}

extension ChatViewController: MessagesLayoutDelegate{
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func configureAvatarView(_ avatarView: MessageKit.AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        guard  let message = message as? Message,
            let author = try? Realm().object(ofType: User.self, forPrimaryKey: message.authorId),
            let url = URL(string: author.avatarName) else { return }
        
        let initials = String(describing: author.userName.first)
        
        ImageDownloader.default.downloadImage(with: url) { result in
            switch result {
            case .success(let value):
                let avatar = Avatar(image: value.image, initials: initials)
                avatarView.set(avatar: avatar)
            case .failure:
                break
                
            }
        }
    }
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
}
extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        return Sender(id: Account.shared.stringUserId, displayName: "Olga Dakhel")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [
            .font: UIFont.preferredFont(forTextStyle: .caption1),
            .foregroundColor: UIColor(white: 0.3, alpha: 1)])
    }
    
}

extension ChatViewController: MessageKit.MessageInputBarDelegate {
    func messageInputBar(_ inputBar: MessageKit.MessageInputBar, didPressedSndButtonWith text: String) {
        networkingService.send(text: text, to: chatId) { [weak self] error in
            if let error = error {
                self?.show(error)
            }
        }
        inputBar.inputTextView.text = ""
    }
}
