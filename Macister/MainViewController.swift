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
    static var current:Active = .vandaag
    static var vandaagView:TodayViewController = TodayViewController.freshController()
    static var agendaView:CalendarViewController = CalendarViewController.freshController()
    
    @IBOutlet weak var userName: NSTextField!
    @IBOutlet weak var profileImage: NSImageView!
    
    var loaded = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        if !loaded {
            userName.stringValue = Magister.magister!.getPerson()!.getName()
            profileImage.image = Magister.magister!.getPerson()!.profielFoto!
            profileImage.wantsLayer = true
            profileImage.image?.size=profileImage.frame.size
            profileImage.layer?.cornerRadius = profileImage.frame.size.width/2
            profileImage.layer?.masksToBounds = true
            loaded = true
        }
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
                    AppDelegate.changeView(controller: MainViewController.agendaView)
                    MainViewController.current = .agenda
                }
            } else if view == vandaag {
                if MainViewController.current != .vandaag {
                    AppDelegate.changeView(controller: MainViewController.vandaagView)
                    MainViewController.current = .vandaag
                }
            }
        }
    }
    
    func update() {}
}

enum Active {
    case berichten, cijfers, agenda, vandaag, other
}
