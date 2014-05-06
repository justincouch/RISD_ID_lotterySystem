class Student
{
  String    timeStamp;
  String    email;
  String    lastName;
  String    firstName;
  String    cellNumber;
  int       IDnumber;
  float     GPA;
  int       graduatingYear;
  String    groupPreference;
  ArrayList groupAChoices;
  ArrayList groupBChoices;
  ArrayList enrolledCourses;
  
  Student( String _timeStamp, String _email, String _lastName, String _firstName, String _cellNumber, int _IDnumber, float _GPA, int _graduatingYear, String _groupPreference, ArrayList _groupAChoices, ArrayList _groupBChoices ){
    timeStamp       = _timeStamp;
    email           = _email;
    lastName        = _lastName;
    firstName       = _firstName;
    cellNumber      = _cellNumber;
    IDnumber        = _IDnumber;
    GPA             = _GPA;
    graduatingYear  = _graduatingYear;
    groupPreference = _groupPreference.substring( 9, 10 );
    groupAChoices   = _groupAChoices;
    groupBChoices   = _groupBChoices;
    enrolledCourses = new ArrayList();
    
    println( "" );
    println( "Created student: " + lastName + ", " + firstName + " || Group Preference: " + groupPreference );
    printChoices();
  }
  
  void printChoices(){
    println( "" );
    println( lastName + ", " + firstName + ": " );
    print( "    " );
    println( groupAChoices );
    print( "    " );
    println( groupBChoices );
  }
  
  void enrollInCourse( Course c ){
    enrolledCourses.add( c );
    println( "Student: " + lastName + ", " + firstName + " enrolled in " + c.courseName );
  }
  
  void disenrollInCourse( Course c ){
    enrolledCourses.remove( c );
  }
  
  void printEnrolledCourses() {
    println( lastName + ", " + firstName + " is enrolled in: " );
    for ( int i=0; i<enrolledCourses.size(); i++ ){
      Course ci = (Course) enrolledCourses.get( i );
      println( "    " + ci.courseName );
    }
  }
  
}
