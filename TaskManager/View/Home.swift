//
//  Home.swift
//  TaskManager
//
//  Created by Bhumika Patel on 10/05/22.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel: TaskViewModel = .init()
    //MARK: Matched Geometry Names
    @Namespace var animation
    
//    MARK: Fetching Task
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    
//    MARK: Environment values
    @Environment(\.self) var env
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack {
                VStack(alignment: .leading, spacing: 8){
                    Text("Welcome Back")
                        .font(.callout)
                    Text("Here's Update Today")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity,  alignment: .leading)
            .padding(.vertical)
            
            
            CustomSegmentedBar()
                .padding(.top,5)
            //MARK: Task View
                TaskView()
            //Later will come
            
        }
        .padding()
       }
        .overlay(alignment: .bottom){

            //MARK:Add button
            Button{
                taskModel.openEditTask.toggle()
                
            }label: {
                Label{
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                }icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())
                
            }
            //MARK:Linear GradientBG
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background{
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7),
                    .white
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            }
        }
        .fullScreenCover(isPresented: $taskModel.openEditTask){
            taskModel.resetTaskData()
        } content: {
            AddNewTask()
                .environmentObject(taskModel)
        }
    }
//    MARK: TaskView
    @ViewBuilder
    func TaskView()->some View{
        LazyVStack(spacing: 20){
           //MARK:
            DynamicFilteredView(currentTab: taskModel.currentTab){ (task: Task) in
                TaskRowView(task: task)
            }
        }
        .padding(.top,20)
    }
//    MARK: Task RowView
    func TaskRowView(task: Task)->some View{
        VStack(alignment: .leading, spacing: 10){
            HStack{
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical,5)
                    .padding(.horizontal)
                    .background{
                        	Capsule()
                            .fill(.white.opacity(0.3))
                    }
                Spacer()
                
//                MARK:  Edit button only for noncomleted task
                //&& taskModel.currentTab != "Failed Task" 
                if !task.isCompleted {
                    Button{
                        taskModel.editTask = task
                        taskModel.openEditTask = true
                        taskModel.setupTask()
                    }label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                }
                
            }
            
            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical,10)
            
            HStack(alignment: .bottom, spacing: 0){
                VStack(alignment: .leading, spacing: 10){
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                    
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                //&& taskModel.currentTab != "Failed Task"
                if !task.isCompleted {
                    Button{
//                        MARK: updating Coredata
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    } label: {
                        Circle()
                            .strokeBorder(.black,lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }
                }
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
    }
    //MARK: Custom Segmented Bar
    @ViewBuilder
    func CustomSegmentedBar()->some View{
        let tabs = ["Today", "Upcoming", "Task Done", "Failed Task"]// In case missed card
        HStack(spacing: 20){
            ForEach(tabs,id: \.self){tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskModel.currentTab == tab ? .white: .black)
                    .padding(.vertical,6)
                    .background{
                        if taskModel.currentTab == tab{
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{taskModel.currentTab = tab}
                    }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
