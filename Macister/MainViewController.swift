//
//  MainViewController.swift
//  Macister
//
//  Created by Koen van Staveren on 13/01/2018.
//  Copyright © 2018 Koen van Staveren. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var berichten: NSView!
    @IBOutlet weak var cijfers: NSView!
    @IBOutlet weak var agenda: NSView!
    @IBOutlet weak var vandaag: NSView!
    //Currently hardcoded TODO
    static var current:Active = .vandaag
    
    @IBOutlet weak var userName: NSTextField!
    @IBOutlet weak var profileImage: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.stringValue = Magister.magister!.getPerson()!.getName()
        profileImage.image = Magister.magister!.getPerson()!.profielFoto!
        profileImage.wantsLayer = true
        profileImage.image?.size=profileImage.frame.size
        profileImage.layer?.cornerRadius = profileImage.frame.size.width/2
        profileImage.layer?.masksToBounds = true
    }
    
    @IBAction func logout(_ sender: Any) {
        Magister.magister!.logout()
        AppDelegate.changeView(controller: FindSchoolViewController.freshController())
        Magister.magister = nil
    }
    
    @IBAction func switchTo(_ sender: Any) {
        if let tab = sender as? NSClickGestureRecognizer {
            let view = tab.view
            if view == berichten {
                if MainViewController.current != .berichten {
                }
            } else if view == cijfers {
                if MainViewController.current != .cijfers {
                }
            } else if view == agenda {
                if MainViewController.current != .agenda {
                    AppDelegate.changeView(controller: CalendarViewController.freshController())
                    MainViewController.current = .agenda
                }
            } else if view == vandaag {
                if MainViewController.current != .vandaag {
                    AppDelegate.changeView(controller: TodayViewController.freshController())
                    MainViewController.current = .vandaag
                }
            }
        }
    }
    
    func update() {}
}

enum Active {
    case berichten, cijfers, agenda, vandaag
}
