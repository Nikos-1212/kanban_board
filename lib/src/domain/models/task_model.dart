import 'dart:convert';

import 'package:task_tracker/src/customr_resources/kanban_board.dart';

enum TaskModelStatus { initial, loading, loaded, error }
class TaskModel {
    final int totalcards;
    final List<DataList> dataList;
    final List<DataList> dataList2;  
    final List<DataList> dataList3;  
    final TaskModelStatus? taskModelStatus;  
    final String? title;
    final String? description;
    final String? comments;    
    final int? numOfDay;
    
    TaskModel({
        required this.totalcards,
        required this.dataList,
        required this.dataList2, 
        required this.dataList3, 
        this.taskModelStatus,
        this.title,
        this.description,
        this.comments,
        this.numOfDay,        
    });
    TaskModel.initial()
      : this(dataList: [],totalcards: 0,taskModelStatus: TaskModelStatus.initial,comments: '',description: '',numOfDay: 0,title: '',dataList2: [],dataList3: []);
    TaskModel copyWith({
        int? totalcards,
        TaskModelStatus? taskModelStatus,
        List<DataList>? dataList,
        String? title,
        String? description,
        String? comments, 
        int? numOfDay,
        List<AppFlowyGroupData>? appFlowyGroupData,
        List<DataList>? dataList2,
        List<DataList>? dataList3, 

    }) => 
        TaskModel(
            totalcards: totalcards ?? this.totalcards,
            dataList: dataList ?? this.dataList,
            taskModelStatus: taskModelStatus??this.taskModelStatus,
            title: title?? this.title,
            description: description??this.description,
            comments: comments??this.comments,
            numOfDay: numOfDay??this.numOfDay,            
            dataList2: dataList2??this.dataList2,
            dataList3: dataList3??this.dataList3
        );

    factory TaskModel.fromJson(String str) => TaskModel.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
        totalcards: json["totalcards"],
        dataList: List<DataList>.from(json["dataList"].map((x) => DataList.fromMap(x))),
        dataList2: List<DataList>.from(json["dataList2"].map((x) => DataList.fromMap(x))),
        dataList3: List<DataList>.from(json["dataList3"].map((x) => DataList.fromMap(x))),        
    );

    Map<String, dynamic> toMap() => {
        "totalcards": totalcards,
        "dataList": List<dynamic>.from(dataList.map((x) => x.toMap())),        
        "dataList2": List<dynamic>.from(dataList2.map((x) => x.toMap())),
        "dataList3": List<dynamic>.from(dataList3.map((x) => x.toMap())),
    };
}

class DataList extends AppFlowyGroupItem {
    final String? s;
    final String cat;
    final String titile;
    final int createdDate;
    final String description;
    final List<dynamic> images;
    final List<Comment> comments;
    final DurationOfTask durationOfTask;
    final int lastDate;
    final int totalDays;

    DataList({
         this.s,
        required this.cat,
        required this.titile,
        required this.createdDate,
        required this.description,
        required this.images,
        required this.comments,
        required this.durationOfTask,
        required this.lastDate,
        required this.totalDays,
    });

    DataList copyWith({
        String? cat,
        String? titile,
        int? createdDate,
        String? description,
        List<dynamic>? images,
        List<Comment>? comments,
        DurationOfTask? durationOfTask,
        int? lastDate,
        int? totalDays,
    }) => 
        DataList(
            cat: cat ?? this.cat,
            titile: titile ?? this.titile,
            createdDate: createdDate ?? this.createdDate,
            description: description ?? this.description,
            images: images ?? this.images,
            comments: comments ?? this.comments,
            durationOfTask: durationOfTask ?? this.durationOfTask,
            lastDate: lastDate ?? this.lastDate,
            totalDays: totalDays ?? this.totalDays,
        );

    factory DataList.fromJson(String str) => DataList.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DataList.fromMap(Map<String, dynamic> json) => DataList(
        s: json["s"],
        cat: json["cat"],
        titile: json["titile"],
        createdDate: json["created_date"],
        description: json["description"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromMap(x))),
        durationOfTask: DurationOfTask.fromMap(json["duration_of_task"]),
        lastDate: json["last_date"],
        totalDays: json["total_days"],
    );

    Map<String, dynamic> toMap() => {
        "s": s,
        "cat": cat,
        "titile": titile,
        "created_date": createdDate,
        "description": description,
        "images": List<dynamic>.from(images.map((x) => x)),
        "comments": List<dynamic>.from(comments.map((x) => x.toMap())),
        "duration_of_task": durationOfTask.toMap(),
        "last_date": lastDate,
        "total_days": totalDays,
    };
    
      @override
      String get id => s??'';

      @override
      DataList get dataList => this;
      
        @override        
        DataList get datalist => throw UnimplementedError();
      // String get getCat => cat;
      // String get getTitile => titile;
      // int get getCreatedDate => createdDate;
      // String get getDescription => description;
      // List<dynamic> get getImages => images;
      // List<Comment> get getComments => comments;
      // DurationOfTask get getDurationOfTask => durationOfTask;
      // int get getLastDate => lastDate;
      // int get getTotalDays => totalDays;
}

class Comment {
    final String text;
    final int dt;

    Comment({
        required this.text,
        required this.dt,
    });

    Comment copyWith({
        String? text,
        int? dt,
    }) => 
        Comment(
            text: text ?? this.text,
            dt: dt ?? this.dt,
        );

    factory Comment.fromJson(String str) => Comment.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        text: json["text"],
        dt: json["dt"],
    );

    Map<String, dynamic> toMap() => {
        "text": text,
        "dt": dt,
    };
}

class DurationOfTask {
    final int inProgress;
    final int completed;

    DurationOfTask({
        required this.inProgress,
        required this.completed,
    });

    DurationOfTask copyWith({
        int? inProgress,
        int? completed,
    }) => 
        DurationOfTask(
            inProgress: inProgress ?? this.inProgress,
            completed: completed ?? this.completed,
        );

    factory DurationOfTask.fromJson(String str) => DurationOfTask.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory DurationOfTask.fromMap(Map<String, dynamic> json) => DurationOfTask(
        inProgress: json["in_progress"],
        completed: json["completed"],
    );

    Map<String, dynamic> toMap() => {
        "in_progress": inProgress,
        "completed": completed,
    };
}
