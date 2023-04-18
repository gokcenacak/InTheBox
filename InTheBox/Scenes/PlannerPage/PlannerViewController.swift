//
//  ViewController.swift
//  InTheBox
//
//  Created by G on 2023-04-03.
//

import UIKit

final class PlannerViewController: UIViewController {
    
    @IBOutlet private weak var greetingTitle: UILabel!
    @IBOutlet private weak var editAppereanceButton: UIButton!
    @IBOutlet private weak var settingsButton: UIButton!
    @IBOutlet private weak var previousDayButton: UIButton!
    @IBOutlet private weak var nextDayButton: UIButton!
    @IBOutlet private weak var addToDoItemButton: UIButton!
    @IBOutlet private weak var addReminderButton: UIButton!
    @IBOutlet private weak var editJournalEntryButton: UIButton!
    @IBOutlet private weak var journalEntryTextView: UITextView!
    @IBOutlet private weak var greetingImage: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var toDoListStackView: UIStackView!
    
    @IBOutlet weak var reminderStackView: UIStackView!
    private var isJournalEditing:Bool = false
    private var currentDate: Date = Date.now
    private var viewModel: PlannerViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PlannerViewModel()
        setupButtonActions()
        setupGreetingTitle()
        setupDateText()
        journalEntryTextView.layer.cornerRadius = 10.0
        journalEntryTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        journalEntryTextView.font = UIFont(name: "SFProRounded-Regular", size: 17)
    }
    
    func setupButtonActions() {
        editAppereanceButton.addTarget(self, action: #selector(editAppereanceButtonTapped), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        previousDayButton.addTarget(self, action: #selector(previousDayButtonTapped), for: .touchUpInside)
        nextDayButton.addTarget(self, action: #selector(nextDayButtonTapped), for: .touchUpInside)
        addToDoItemButton.addTarget(self, action: #selector(addToDoItemButtonTapped), for: .touchUpInside)
        addReminderButton.addTarget(self, action: #selector(addReminderButtonTapped), for: .touchUpInside)
        editJournalEntryButton.addTarget(self, action: #selector(editJournalEntryButtonTapped), for: .touchUpInside)
    }
    
    func setupGreetingTitle() {
        viewModel.setupGreetingTitle()
    }
    
    func setupDateText() {
        viewModel.setCurrentDate(with: Date.now)
    }
    
    func createToDo(with text: String) {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.addTarget(self, action: #selector(checkToDo), for: .touchUpInside)

        let textLabel = UILabel()
        textLabel.text  = text
        textLabel.textAlignment = .left
        textLabel.font = UIFont(name: "SFProRounded-Regular", size: 17)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 5
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.toDoListStackView.addArrangedSubview(stackView)
    }
    
    func createReminder(with image: UIImage, with text: String) {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(image, for: .normal)
        button.isUserInteractionEnabled = false
        
        let textLabel = UILabel()
        textLabel.text  = text
        textLabel.textAlignment = .left
        textLabel.font = UIFont(name: "SFProRounded-Regular", size: 17)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 10
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(textLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.reminderStackView.addArrangedSubview(stackView)
    }
    
    @objc func checkToDo(button: UIButton) {
        let imgSquare = UIImage(systemName: "square")
        let imgCheckedSquare = UIImage(systemName: "checkmark.square.fill")
        let buttonImage = button.currentImage == imgSquare ? imgCheckedSquare : imgSquare
        button.setImage(buttonImage, for: .normal)
    }
    
    @objc func editAppereanceButtonTapped() {
        
    }
    
    @objc func settingsButtonTapped() {
        
    }
    
    @objc func previousDayButtonTapped() {
        let currentDate = viewModel.currentDate
        viewModel.setCurrentDate(with: currentDate.dayBefore)
        //Retrieve yesterday's data
    }
    
    @objc func nextDayButtonTapped() {
        let currentDate = viewModel.currentDate
        viewModel.setCurrentDate(with: currentDate.dayAfter)
        //Retrieve next day's data
    }
    
    @objc func addToDoItemButtonTapped() {
        let popUpWindow: PopUpWithTextFieldVC!
        popUpWindow = PopUpWithTextFieldVC(title: "What do you want to do today?", buttonText: "Add To-Do", buttonAction: { [weak self] text in
            guard let self = self else { return }
            self.createToDo(with: text)
        })
        self.present(popUpWindow, animated: true, completion: nil)
    }
    
    @objc func addReminderButtonTapped() {
        let popUpWindow = PopUpWithIconSelectionAndTextField(buttonAction: { [weak self] icon, text in
            guard let self = self else { return }
            self.createReminder(with: icon, with: text)
        })
        self.present(popUpWindow, animated: true, completion: nil)
    }
    
    @objc func editJournalEntryButtonTapped() {
        if journalEntryTextView.isFirstResponder {
            editJournalEntryButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            journalEntryTextView.isEditable = false
            journalEntryTextView.layer.borderWidth = 0.0
            journalEntryTextView.resignFirstResponder()

        } else {
            editJournalEntryButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
            journalEntryTextView.isEditable = true
            journalEntryTextView.layer.borderWidth = 2.0
            journalEntryTextView.layer.borderColor = UIColor.gray.cgColor

            journalEntryTextView.becomeFirstResponder()
        }
        
    }
}

extension PlannerViewController: PlannerViewModelDelegate {
    func handleViewModelOutput(_ output: PlannerViewModelOutput) {
        switch output {
        case .setupGreetingTitle(let title, let image):
            greetingTitle.text = title
            greetingImage.image = image
        case .setupDateLabel(let date):
            dateLabel.text = date
        }
    }
}
