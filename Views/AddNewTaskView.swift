//
//  AddNewTaskView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 23.6.22..
//

import SwiftUI
import AuthenticationServices

struct AddNewTaskView: View {
    @State var tekst: String = ""
    @State var date: Date = Date()
    @Binding var addTask: Bool
    @State var chooseDate: Bool = false
    let dateFormat = DateFormatter()
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            VStack {
                VStack(spacing: 0) {
                    TextField("Unesite zadatak", text: $tekst)
                        .padding([.horizontal, .bottom], 3)
                        .submitLabel(.done)
                    
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.accentColor)
                }
                
                HStack {
                    Button(action: {
                        dateFormat.dateFormat = "dd. MM. yyyy"
                        chooseDate = true
                    }) {
                        let d = dateFormat.string(from: date)
                        
                        if (d.isEmpty) {
                            Label("Unesite datum", systemImage: "calendar")
                                .padding(6)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .clipShape(Capsule(style: .continuous))
                        } else {
                            Label("\(dateFormat.string(from: date))", systemImage: "calendar")
                                .padding(6)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .clipShape(Capsule(style: .continuous))
                        }
                    }
                    .sheet(isPresented: $chooseDate) {
                        ZStack {
                            ChooseDate(date: $date)
                            
                            VStack {
                                Spacer()
                                Button(action: {
                                    chooseDate = false
                                }) {
                                    Text("Izaberi")
                                        .font(.system(size: 15, weight: .black))
                                        .foregroundColor(Color.white)
                                        .frame(width: 270, height: 50)
                                        .background(Color.accentColor)
                                        .clipShape(RoundedRectangle(cornerRadius: .infinity, style: .continuous))
                                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                                        .padding()
                                }
                            }
                        }
                        .background(BackgroundClearView())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        let d = dateFormat.string(from: date)
                        TaskManager().uploadTasks(task: TaskModel(due: d == "" ? nil : d, status: 0, task: tekst))
                        tekst = ""
                        addTask = false
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.accentColor)
                            
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                        }
                    }
                    .disabled(tekst.isEmpty)
                }
                .padding(.top, 2)
            }
            .padding(15)
        }
        .background(Color(UIColor.systemBackground))
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct AddNewTaskView_Previews: PreviewProvider {
    @State static var tasks: [TaskModel] = []
    @State static var add = true

    static var previews: some View {
        AddNewTaskView(addTask: self.$add)
    }
}
