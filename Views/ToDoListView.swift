//
//  ToDoListView.swift
//  EduChat
//
//  Created by Љубомир Мићић on 14.6.22..
//

import SwiftUI

struct ToDoListView: View {
    @State var tasks: [TaskModel] = []
    @StateObject var taskManager: TaskManager = TaskManager()
    @State var addTask: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    @ViewBuilder
    func Naslov() -> some View {
        Title(titleVar: "Planer")
            .padding(.bottom, 8)
        
        Divider()
            .padding(.leading)
    }
    
    @ViewBuilder
    func Switch(isToggled: Bool) -> some View {
        if isToggled {
            ZStack {
                Circle().stroke()
                    .foregroundColor(Color.accentColor)
                    .frame(width: 22, height: 22)
                
                Circle()
                    .foregroundColor(Color.accentColor)
                    .frame(width: 19, height: 19)
            }
        } else {
            Circle().stroke()
                .foregroundColor(Color.gray.opacity(0.2))
                .frame(width: 22, height: 22)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(isShowingShadow: false)
            
            Naslov()
            
            ZStack {
                List {
                    ForEach(self.$tasks, id: \.self) { $task in
                        HStack {
                            Button(action: {
                                task.ToggleisDone()
                            }) {
                                Switch(isToggled: (task.status == 1))
                            }
                            
                            VStack(alignment: .leading) {
                                Text(task.task)
                                    .multilineTextAlignment(.leading)
                                
                                if(task.due != nil) {
                                    Text(task.due!)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color(uiColor: UIColor.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: (self.colorScheme == .light ? Color.gray.opacity(0.2) : Color.white.opacity(0.2)), radius: 3, x: 0, y: 0)
                        .contextMenu {
                            Button(action: {
                                addTask = true
                            }) {
                                Label("Izmeni", systemImage: "pencil")
                            }
                        }
                    }
                    .onChange(of: self.tasks, perform: { tasks in
                        taskManager.updateTask(tasks: tasks)
                    })
                    .onChange(of: self.taskManager.tasks, perform: { tasks in
                        self.tasks = tasks
                    })
//                    .onDelete { numb in
//                        //tasks.remove(atOffsets: numb)
//                        addTask = false
//                    }
                }
                .listStyle(SidebarListStyle())
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    if (addTask) {
                        AddNewTaskView(addTask: $addTask)
                    } else {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                impactMed.impactOccurred() // haptic feedback
                                addTask = true
                            }) {
                                ZStack {
                                    Circle()
                                        .frame(width: 50, height: 50)
                                        .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
                                    Image(systemName: "pencil")
                                        .font(.system(size: 25).bold())
                                        .foregroundColor(Color.white)
                                }
                            }
                        }
                        .padding(20)
                    }
                }
            }
        }
        .onAppear() {
            self.tasks = taskManager.tasks
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
