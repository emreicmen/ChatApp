//
//  UICollectionViewCell.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 23.12.2024.
//


import UIKit


protocol ChatCellDelegate: AnyObject {
    func cell(wantToPlayVideo cell: ChatCell, videoURL: URL?)
    func cell(wantToPlayAudio cell: ChatCell, audioURL: URL?, isPlay: Bool)
    func cell(wantToShowImage cell: ChatCell, imageURL: URL?)
    func cell(wantToOpenGoogleMap cell: ChatCell, locationURL: URL?)
    
}

class ChatCell: UICollectionViewCell {
    
    //MARK: - Properties
    private let profileImageView = CustomImageView(image: #imageLiteral(resourceName: "Google_Contacts_logo copy"), width: 30, height: 30, backgroundColor: .lightGray, cornerRadius: 15)
    private let dateLabel = CustomLabel(text: "20/10/2024", labelFont: .systemFont(ofSize: 9), labelColor: .lightGray)
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    var bubbleRightAnchor: NSLayoutConstraint!
    var bubbleLeftAnchor: NSLayoutConstraint!
    var dateRightAnchor: NSLayoutConstraint!
    var dateLeftAnchor: NSLayoutConstraint!
    var messageViewModel: MessageViewModel? {
        didSet{
            configure()
        }
    }
    private let textView: UITextView = {
        let textField = UITextView()
        textField.backgroundColor = .clear
        textField.isEditable = false
        textField.isScrollEnabled = false // Sadece boyutlandırma, kaydırma yapma
        textField.font = .systemFont(ofSize: 15)
        textField.text = "sample text message"
        return textField
    }()
    private lazy var postImage: CustomImageView = {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showRecordedImage))
        let imageView = CustomImageView()
        imageView.isHidden = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    private lazy var postVideoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.setTitle(" Play video", for: .normal)
        button.addTarget(self, action: #selector(uploadVideo), for: .touchUpInside)
        return button
    }()
    private lazy var postAudioButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.setTitle(" Play audio", for: .normal)
        button.addTarget(self, action: #selector(uploadAudio), for: .touchUpInside)
        return button
    }()
    private lazy var postGoogleMapLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.circle"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.setTitle(" Google Map", for: .normal)
        button.addTarget(self, action: #selector(postGoogleMapLocation), for: .touchUpInside)
        return button
    }()
    weak var chatCellDelegate: ChatCellDelegate?
    var isVoicePlaying: Bool = true
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: contentView.leftAnchor, bottom: contentView.bottomAnchor, paddingLeft: 10)
        
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.layer.masksToBounds = true
        bubbleContainer.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: contentView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 12, paddingBottom: 5)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 5, paddingRight: 12)
        
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = true
        
        addSubview(dateLabel)
        dateLeftAnchor = dateLabel.leftAnchor.constraint(equalTo: bubbleContainer.rightAnchor, constant: 12)
        dateLeftAnchor.isActive = false
        dateRightAnchor = dateLabel.rightAnchor.constraint(equalTo: bubbleContainer.leftAnchor, constant: -12)
        dateRightAnchor.isActive = false
        
        dateLabel.anchor(bottom: contentView.bottomAnchor)
        
        addSubview(postImage)
        postImage.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 5, paddingRight: 12)
        
        addSubview(postVideoButton)
        postVideoButton.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 5, paddingRight: 12)

        addSubview(postAudioButton)
        postAudioButton.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 5, paddingRight: 12)

        addSubview(postGoogleMapLocationButton)
        postGoogleMapLocationButton.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 5, paddingLeft: 12, paddingBottom: 5, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     
    //MARK: - Helpers and Functions
    func configure() {

        guard let messageViewModel = messageViewModel else { return }
        bubbleContainer.backgroundColor = messageViewModel.messageBackgorunColor
        textView.text = messageViewModel.messageText
        textView.textColor = messageViewModel.messageColor
        
        bubbleRightAnchor.isActive = messageViewModel.rightAnchorActive
        dateRightAnchor.isActive = messageViewModel.rightAnchorActive
        
        bubbleLeftAnchor.isActive = messageViewModel.leftAnchorActive
        dateLeftAnchor.isActive = messageViewModel.leftAnchorActive
        
        profileImageView.sd_setImage(with: messageViewModel.profileImageURL)
        profileImageView.isHidden = messageViewModel.shouldHideProfileImage
        
        guard let timestampString = messageViewModel.timestampString else {return}
        dateLabel.text = timestampString
        
        postImage.sd_setImage(with: messageViewModel.imageURL)
        textView.isHidden = messageViewModel.isTextHide
        postImage.isHidden = messageViewModel.isImageHide
        
        if !messageViewModel.isImageHide {
            postImage.setHeight(200)
        }
        
        postVideoButton.isHidden = messageViewModel.isVideoHide
        postAudioButton.isHidden = messageViewModel.isAudioHide
        postGoogleMapLocationButton.isHidden = messageViewModel.isLocationHide
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        let size = textView.sizeThatFits(CGSize(width: targetSize.width - 24, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: targetSize.width, height: size.height + 20)
    }
    
    @objc func uploadVideo() {
        guard let messageViewModel = messageViewModel else { return }
        chatCellDelegate?.cell(wantToPlayVideo: self, videoURL: messageViewModel.videoURL)
    }
    
    @objc func uploadAudio() {
        guard let messageViewModel = messageViewModel else { return }
        chatCellDelegate?.cell(wantToPlayAudio: self, audioURL: messageViewModel.audioURL, isPlay: isVoicePlaying)
        isVoicePlaying.toggle()
        let title = isVoicePlaying ? " Play Audio" : " Stop Audio"
        let imageName = isVoicePlaying ? "play.circle" : "stop.circle"
        postAudioButton.setTitle(title, for: .normal)
        postAudioButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc func showRecordedImage() {
        guard let messageViewModel = messageViewModel else { return }
        chatCellDelegate?.cell(wantToShowImage: self, imageURL: messageViewModel.imageURL)
    }
    @objc func postGoogleMapLocation() {
        guard let messageViewModel = messageViewModel else { return }
        chatCellDelegate?.cell(wantToOpenGoogleMap: self, locationURL: messageViewModel.locationURL)
    }
    
    func resetAudioSettings() {
        postAudioButton.setTitle(" Play Audio", for: .normal)
        postAudioButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        isVoicePlaying = true
    }
}
