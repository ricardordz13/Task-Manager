//
//  TaskBlockView.swift
//  TaskManager
//
//  Created by Ricardo Jorge Rodriguez Trevino on 01/04/24.
//

import SwiftUI
import CloudKit

struct ShareSheet: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Nothing to do here
    }
}

struct TaskRowView: View {
    @ObservedObject var event: Assignment
    @Environment(\.managedObjectContext) private var managedObjectContext
    @State private var isShareSheetPresented = false
    @State private var shareableURL: URL?
    
    var body: some View {
        if let startDate = event.startDate, let endDate = event.endDate, let title = event.title {
            let duration = endDate.timeIntervalSince(startDate) / 3600
            let height = duration * 80.0
            
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: startDate)
            let minute = calendar.component(.minute, from: startDate)
            let offset = (Double(hour-7) + Double(minute)/60) * 80.0
            
            HStack {
                VStack(alignment: .leading) {
                    Group {
                        Text("\(startDate.formatted(.dateTime.hour().minute())) - \(endDate.formatted(.dateTime.hour().minute()))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Text(title)
                        .font(.footnote)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Button(action: {
                    fetchShareableURL()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.secondary)
                }
                .sheet(isPresented: $isShareSheetPresented) {
                    if let shareableURL = shareableURL {
                        Text("Sharing is possible")
                            .foregroundColor(.red)

                        ShareSheet(url: shareableURL) // Present ShareSheet with URL
                    }
                    else {
                        Text("Sharing is not possible")
                            .foregroundColor(.red)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 8)
            .frame(height: height)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.yellow.opacity(0.3))
            )
            .padding(.leading, 10)
            .padding(.trailing, 30)
            .contextMenu {
                Button("Delete Task", role: .destructive) {
                    managedObjectContext.delete(event)
                    try? managedObjectContext.save()
                }
            }
            .offset(x: 30, y: offset + 24)
        }
    }
    
    private func fetchShareableURL() {
        print(event.recordID)
        guard let recordID = event.recordID else { return }
        let cloudKitDB = CKContainer.default().privateCloudDatabase

        print("1")
        
        cloudKitDB.fetch(withRecordID: recordID as! CKRecord.ID) { record, error in
            if let error = error {
                print("Error fetching record: \(error.localizedDescription)")
                return
            }
            print("2")

            guard let record = record,
                  let share = record.share else {
                print("Shareable URL not found")
                return
            }
            print("3")

            let referencedRecordID = share.recordID

            cloudKitDB.fetch(withRecordID: referencedRecordID) { referencedRecord, error in
                if let error = error {
                    print("Error fetching referenced record: \(error.localizedDescription)")
                    return
                }
                print("4")

                guard let referencedRecord = referencedRecord,
                      let urlString = referencedRecord["Name"] as? String,
                      let url = URL(string: urlString) else {
                    print("URL not found or invalid in referenced record")
                    return
                }
                print("5")

                DispatchQueue.main.async {
                    self.shareableURL = url
                    self.isShareSheetPresented.toggle()
                }
                print("6")

            }
        }
    }

}
