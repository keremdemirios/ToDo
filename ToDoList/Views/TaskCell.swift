//
//  TaskCell.swift
//  ToDoList
//
//  Created by Kerem Demir on 18.07.2023.
//

import SwiftUI

struct TaskCell: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    @ObservedObject var passedTaskItem: TaskItem
    
    var body: some View {
        HStack{
            CheckBoxView(passedTaskItem: passedTaskItem)
                .environmentObject(dateHolder)
            
            Text(passedTaskItem.name ?? "")
                .padding(.leading) // .horizontal normalde ama sigmiyor.
            
            if !passedTaskItem.isCompleted() && passedTaskItem.scheduleTime {
                Spacer()
                Text(passedTaskItem.dueDateTimeOnly())
                    .font(.footnote)
                    .foregroundColor(passedTaskItem.overDueColor())
                    .padding(.trailing)
            }
        }
    }
}

struct TaskCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskCell(passedTaskItem: TaskItem())
    }
}
