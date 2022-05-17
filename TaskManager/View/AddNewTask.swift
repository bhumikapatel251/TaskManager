//
//  AddNewTask.swift
//  TaskManager
//
//  Created by Bhumika Patel on 10/05/22.
//

import SwiftUI

struct AddNewTask: View {
    @EnvironmentObject var taskModel: TaskViewModel
    //MARK:All environment values in one variable
    @Environment(\.self) var env
    @Namespace var animarion
    var body: some View {
        VStack(spacing: 12){
            Text("Edit Text")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading){
            Button{
                env.dismiss()
            }label: {
                Image(systemName: "arrow.left")
                    .font(.title3)
                    .foregroundColor(.black)
                    }
                }
                    VStack(alignment: .leading, spacing: 12){
                        Text("Task Color")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        //MARK:simple card colors
                        let colors: [String] = ["Yellow", "Green", "Blue", "Red", "Orange"]
                        HStack(spacing: 15){
                            ForEach(colors,id: \.self){ color in
                                Circle()
                                    .fill(Color(color))
                                    .frame(width: 25, height: 25)
                                    .background{
                                        if taskModel.taskColor == color{
                                            Circle()
                                                .strokeBorder(.gray)
                                                .padding(-3)
                                        }
                                    }
                                    .contentShape(Circle())
                                    .onTapGesture {
                                        taskModel.taskColor = color
                                    }
                                
                            }
                            
                        
                        
                    }
                        .padding(.top,10)
            }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top,30)
            Divider() // vertical line used
                .padding(.vertical,10)
            VStack(alignment: .leading, spacing: 12){
                Text("Task DeadLine")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(taskModel.taskDeadLine.formatted(date: .abbreviated, time: .omitted) + ", " + taskModel.taskDeadLine.formatted(date: .omitted, time: .shortened))
                
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top,8)
    }
            .frame(maxWidth: .infinity,alignment: .leading)
            .overlay(alignment: .bottomTrailing){
                Button{
                    
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }
            }
            Divider()
            VStack(alignment: .leading, spacing: 12){
                Text("Task Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("", text: $taskModel.taskTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.top,8)
    }
            
            .padding(.top,10)
            Divider()
            
            // MARK: sample TaskType
            let taskTypes: [String] = ["Basic", "Urgent", "Important"]
            VStack(alignment: .leading, spacing: 12){
                    Text("TaskType")
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack(spacing: 12){
                        ForEach(taskTypes,id: \.self){type in
                            Text(type)
                                .font(.callout)
                                .padding(.vertical,8)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(taskModel.taskType == type ? .white : .black)
                                .background{
                                    if taskModel.taskType == type{
                                        Capsule()
                                            .fill(.black)
                                            .matchedGeometryEffect(id: "TYPE", in: animarion)
                                    }else{
                                        Capsule()
                                            .strokeBorder(.black)
                                    }
                                }
                            // animation effect
                                .contentShape(Capsule())
                                .onTapGesture {
                                    withAnimation{taskModel.taskType = type}
                                }
                            }
                        }
                    .padding(.top,8)
            }
            .padding(.vertical, 10)
            
            Divider()
            
            //MARK SaveButton
            
            Button{
                //MARK: If success closing view
                if taskModel.addTask(context: env.managedObjectContext){
                    env.dismiss()
                }
            } label: {
                Text("SaveTask")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical,12)
                    .foregroundColor(.white)
                    .background{
                    Capsule()
                            .fill(.black)
                }
            }
            .frame(maxHeight:.infinity, alignment: .bottom)
            .padding(.bottom,10)
            // Color lightway
            .disabled(taskModel.taskTitle == "")
            .opacity(taskModel.taskTitle == "" ? 0.6 : 1)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
       
    }
}

struct AddNewTask_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTask()
            .environmentObject(TaskViewModel())
    }
}
