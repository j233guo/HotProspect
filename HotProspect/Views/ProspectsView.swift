//
//  ProspectsView.swift
//  HotProspect
//
//  Created by Jiaming Guo on 2022-11-06.
//

import CodeScanner
import SwiftUI

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    let filter: FilterType
    
    var title: String {
        switch filter {
            case .none:
                return "Everyone"
            case .contacted:
                return "Contacted people"
            case .uncontacted:
                return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
            case .none:
                return prospects.people
            case .contacted:
                return prospects.people.filter { $0.isContacted }
            case .uncontacted:
                return prospects.people.filter { !$0.isContacted }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
            case .success(let result):
                let details = result.string.components(separatedBy: "\n")
                guard details.count == 2 else { return }
                let person = Prospect()
                person.name = details[0]
                person.emailAddress = details[1]
                prospects.add(person)
            case .failure(let error):
                print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if filteredProspects.count == 0 {
                    switch filter {
                        case .none:
                            VStack {
                                Text("Contact list is empty")
                                    .font(.title)
                                Text("Scan a QR code to add a contact")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.secondary)
                        case .contacted:
                            VStack {
                                Text("Contacted list is empty")
                                    .font(.title)
                                Text("Contacted people will be listed here")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.secondary)
                        case .uncontacted:
                            VStack {
                                Text("Uncontacted list is empty")
                                    .font(.title)
                                Text("Uncontacted people will be listed here")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.secondary)
                    }
                }
                List {
                    ForEach(filteredProspects) { prospect in
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        .swipeActions {
                            if prospect.isContacted {
                                Button {
                                    prospects.toggleContacted(prospect)
                                } label: {
                                    Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                                }
                                .tint(.blue)
                            } else {
                                Button {
                                    prospects.toggleContacted(prospect)
                                } label: {
                                    Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                                }
                                .tint(.green)
                            }
                        }
                    }
                }
                .navigationTitle(title)
                .toolbar {
                    if filter == .none {
                        Button {
                            isShowingScanner = true
                        } label: {
                            Label("Scan", systemImage: "qrcode.viewfinder")
                        }
                    }
                }
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "jg", completion: handleScan)
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var prospects = Prospects()
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(prospects)
    }
}
