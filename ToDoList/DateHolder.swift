//
//  DateHolder.swift
//  ToDoList
//
//  Created by Kerem Demir on 18.07.2023.
//

import SwiftUI
import CoreData

class DateHolder: ObservableObject {
    
    @Published var date = Date()
    @Published var taskItems: [TaskItem] = []
    
    let calendar: Calendar = Calendar.current
    
    func moveDate(_ days: Int, _ context: NSManagedObjectContext){
        
        date = calendar.date(byAdding: .day, value: days, to: date)!
        refreshTaskItems(context)
    }
    
    func refreshTaskItems(_ context: NSManagedObjectContext) {
        taskItems = fetchTaskItems(context)
    }
    
    init(_ context: NSManagedObjectContext){
        refreshTaskItems(context)
    }
    
    func fetchTaskItems(_ context: NSManagedObjectContext) -> [TaskItem]{
        do
        {
            return try context.fetch(dailyTaskFetch()) as [TaskItem]
        }
        catch let error {
            fatalError("Unsolved error \(error)")
        }
    }
    
    func dailyTaskFetch() -> NSFetchRequest<TaskItem> {
        let request = TaskItem.fetchRequest()
        
        request.sortDescriptors = sortOrder()
        request.predicate = predicate()
        return request
    }
    
    private func sortOrder() -> [NSSortDescriptor] {
        let completedDateSort = NSSortDescriptor(keyPath: \TaskItem.completedDate, ascending: true)
        let timeSort = NSSortDescriptor(keyPath: \TaskItem.scheduleTime, ascending: true)
        let dueDateSort = NSSortDescriptor(keyPath: \TaskItem.dueDate, ascending: true)
        return [completedDateSort, timeSort, dueDateSort]
    }
    
    private func predicate() -> NSPredicate {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start)
        return NSPredicate(format: "dueDate >= %@ AND dueDate < %@", start as NSDate, end! as NSDate)
    }
    
    func saveContext(_ context: NSManagedObjectContext){
        do {
            try context.save()
            refreshTaskItems(context)
        } catch {
            let nsError = error as NSError
            fatalError("Unsolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

