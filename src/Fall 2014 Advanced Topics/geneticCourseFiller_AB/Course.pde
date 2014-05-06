class Course
{
  String group;
  String courseName;
  String courseInstructor;
  int minNumber;
  int maxNumber;
  ArrayList studentsInCourse;
  int index;
  String fullMatchString; // raw data from CSV file used for string matching
  
  Course( String _group, String _courseName, String _courseInstructor, int _minNumber, int _maxNumber, int _index ){
    group             = _group;
    courseName        = _courseName;
    courseInstructor  = _courseInstructor;
    minNumber         = _minNumber;
    maxNumber         = _maxNumber;
    index             = _index;
    
    studentsInCourse  = new ArrayList();
    
    //println( "Created course: " + courseName + ", Instructor: " + courseInstructor + ", min: " + minNumber + ", max: " + maxNumber );
  }
  
  void addStudent( Student s ){
    studentsInCourse.add( s );
    //println( "Course: " + courseName + " added: " + s.lastName + ", " + s.firstName );
  }
  
  void removeStudent(Student s){
    //println("Removing student: " + s.IDnumber + " from Course " + courseName);

    if(studentsInCourse.contains(s)){
      studentsInCourse.remove(s);
    } 
    else {
      //println(s + " is not in this course. Error.");
    }
  }
  
  void clearCourse(){
    studentsInCourse.clear();
  }
  
  int numStudentsInCourse(){
    return studentsInCourse.size();
  }
  
  void printRoster(){
    println( courseName + " roster: " );
    for ( int i=0; i<studentsInCourse.size(); i++ ){
      Student si = (Student) studentsInCourse.get( i );
      println( "    " + (i+1) + ": " + si.lastName + ", " + si.firstName );
    }
  }
  
  void render(){
    color grpCol = #ffffff;
    color choiceCol = #ffffff;
    for ( int i=0; i<studentsInCourse.size(); i++ ){
      Student si = (Student) studentsInCourse.get( i );
      if ( si.groupPreference.equals( "A" ) ){
        //grpCol = color( 200, 0, 0 );
        grpCol = choiceColorsBLUE[ 0 ];
      }
      else if ( si.groupPreference.equals( "B" ) ){
        //grpCol = color( 0, 0, 200 );
        grpCol = choiceColorsRED[ 0 ];
      }
      else {
        grpCol = color( 255 );
      }
      
      if ( group.equals( "A" ) ){
        for ( int j=0; j<si.groupAChoices.size(); j++ ){
          String sichj = (String) si.groupAChoices.get( j );
          if ( sichj.equals( courseName ) ){
            //choiceCol = color( 200, map( j, 0, si.groupAChoices.size(), 0, 200 ), map( j, 0, si.groupAChoices.size(), 0, 200 ) );
            //choiceCol = choiceColorsBLUE[ j ];
            choiceCol = choiceColorsGREEN[ j ];
          }
        }
      }
      else if ( group.equals( "B" ) ){
        for ( int j=0; j<si.groupBChoices.size(); j++ ){
          String sichj = (String) si.groupBChoices.get( j );
          if ( sichj.equals( courseName ) ){
            //choiceCol = color( map( j, 0, si.groupBChoices.size(), 0, 200 ), map( j, 0, si.groupBChoices.size(), 0, 200 ), 200 );
            //choiceCol = choiceColorsRED[ j ];
            choiceCol = choiceColorsGREEN[ j ];
          }
        }
      }
      /*
      fill( choiceCol );
      rect( (index * colW) + margin, i*rowH + margin + marginTop, colW-(margin*2), rowH - margin );
      
      fill( grpCol );
      ellipse( (index * colW) + (colW - margin*2) - 10, i*rowH + margin*2 + 10 + marginTop, 20, 20 );
      
      fill( 0 );
      text( si.lastName + ", " + si.firstName, (index * colW) + margin*2, i*rowH + margin + marginTop + 20 );
      */
    }
    
    
    
    //fill( 0 );
    //text( courseName, (index * colW) + margin, 20 );
  }
}
