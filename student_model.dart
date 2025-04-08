class StudentRecord {
  String studentname;
  String fathername;
  String progname;
  String shift;
  String rollno;
  String coursecode;
  String coursetitle;
  String credithours;
  String obtainedmarks;
  String mysemester;
  String consider_status;

  StudentRecord({
    required this.studentname,
    required this.fathername,
    required this.progname,
    required this.shift,
    required this.rollno,
    required this.coursecode,
    required this.coursetitle,
    required this.credithours,
    required this.obtainedmarks,
    required this.mysemester,
    required this.consider_status,
  });

  Map<String, dynamic> toJson() => {
        'studentname': studentname,
        'fathername': fathername,
        'progname': progname,
        'shift': shift,
        'rollno': rollno,
        'coursecode': coursecode,
        'coursetitle': coursetitle,
        'credithours': credithours,
        'obtainedmarks': obtainedmarks,
        'mysemester': mysemester,
        'consider_status': consider_status,
      };

  factory StudentRecord.fromJson(Map<String, dynamic> json) => StudentRecord(
        studentname: json['studentname'],
        fathername: json['fathername'],
        progname: json['progname'],
        shift: json['shift'],
        rollno: json['rollno'],
        coursecode: json['coursecode'],
        coursetitle: json['coursetitle'],
        credithours: json['credithours'],
        obtainedmarks: json['obtainedmarks'],
        mysemester: json['mysemester'],
        consider_status: json['consider_status'],
      );
}