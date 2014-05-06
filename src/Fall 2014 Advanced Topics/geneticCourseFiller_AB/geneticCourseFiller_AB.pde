// For filling courses at RISD
// students are given a certain number of class choices
// they rate those choices
// they have GPAs and years of graduation
// we want to find the optimum solution for people and classes

import java.util.*;

ArrayList genesAboveThreshold;
ArrayList phenomesAboveThreshold;
PGraphics gATimg;

int numChoices = 4;
int populationSize = 100;
int numRandomGenes = 10;

int gridX = 10;
int gridY = 10;
int row = 0;

color [] choiceColors;
color [] choiceColorsBLUE;
color [] choiceColorsRED;
color [] choiceColorsGREEN;

float thresholdFitness = 0.83;
float targetFitness;
float mutationRate = 0.02;
float currentBestFitness = 0.0;
int currentBestIndex = 0;
Gene currentBestGene;
Phenome currentBestPhenome;

ArrayList courses;
ArrayList students;
Gene[]     population;
Phenome[]  phenomes;
ArrayList  matingPool;
ArrayList  prematingPool;

String CSVstudentFileName = "Special Topic Studio Fall 2014 Lottery Form (Responses) - Form Responses.csv";
String CSVcourseFileName = "specialTopics_Fall_2014.csv";

Table studentTable;
Table courseTable;

int numberOfCourses;
int numberOfStudents;
int numChoicesPerGroup = 4;

float regMult = 2.0;
float prefMult = 4.0;
float tooFewPenalty = 15.0;
float tooManyPenalty = 10.0;

float maxRunFitness = 0;
float minRunFitness = 0;

String RENDERSAVEFOLDER = "/Users/Tellart/Desktop/geneticCourseFiller/";
String imgDate;

int [] chs;

void setup() {
  size( 1400, 800 );
  
  // create the courses
  initCourses();
  // create all the students
  initStudents();
  // set the color arrays
  initColors();
  
  targetFitness = ( ( numberOfStudents*( numChoicesPerGroup-1 ) * regMult ) + ( numberOfStudents*prefMult*( numChoicesPerGroup-1 ) ) );
  println( targetFitness );
  
  // make some genes
  //genes = new ArrayList<Gene>();
  //population = new ArrayList<Gene>();
  population = new Gene[ populationSize ];
  phenomes = new Phenome[ populationSize ];
  matingPool = new ArrayList<Gene>();
  prematingPool = new ArrayList<Gene>();
  genesAboveThreshold = new ArrayList<Gene>();
  phenomesAboveThreshold = new ArrayList<Phenome>();
  
  for ( int i=0; i<populationSize; i++ ){
    population[i] = new Gene();
    phenomes[i] = new Phenome( population[i] );
  }
  
  imgDate = year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second();
  //frameRate( 4 );
}

void draw() {
  background( 200 );
  println( "" );
  println( "* * * * * * * * * * * * * * *" );
  println( "GENERATION " + frameCount );
  
  evaluatePopulationFitness();
  
  setMatingPool();
  
  // draw the best gene big
  currentBestPhenome.render( 10, 50, 1.8 );
  
  crossGenes();
  
  saveFrame( RENDERSAVEFOLDER + "/" + imgDate + "/####" + ".png" );
}


void crossGenes(){
  for ( int i=0; i<population.length; i++ ){
    int parentAindex = int( random( matingPool.size() ) );
    int parentBindex = int( random( matingPool.size() ) );
    
    Gene parentA = ( Gene ) matingPool.get( parentAindex );
    Gene parentB = ( Gene ) matingPool.get( parentBindex );
    
    Gene child = parentA.crossover( parentB );
    
    child.mutate();
    //child.evaluateFitness();
    population[i] = child;
    //phenomes[i] = new Phenome( population[i] );
  }
}

void setMatingPool(){
  matingPool.clear();
  prematingPool.clear();
  
  for ( int i=0; i<population.length; i++ ){
    Gene g1 = population[ i ];
    // if gene is in the top 'half' of fitness
    if ( g1.fitness > (maxRunFitness+minRunFitness)/2 ){
      // add a number of genes to the mating pool proportional to the fitness
      // the more fit a gene is, the more it is added to the gene pool
      int n = round( g1.fitness * 100 );
      for ( int j=0; j<n; j++ ){
        matingPool.add( g1 );
      }
    }
  }
  
  for ( int i=0; i<numRandomGenes; i++ ){
    matingPool.add( new Gene() );
  }
}

void evaluatePopulationFitness(){
  row = 0;
  maxRunFitness = 0;
  minRunFitness = 1;
  for ( int i=0; i<population.length; i++ ){
    Gene g1 = population[ i ];
    g1.evaluateFitness();
    
    phenomes[i] = new Phenome( g1 );
    //if ( row > gridY ) row = 0;
    
    phenomes[i].render( 650 + i%gridX*75, 10 + row*80, 0.19 );
    if ( i%gridX == gridX-1 ){
      row++;
    }
    
    if ( g1.fitness > maxRunFitness ){
      maxRunFitness = g1.fitness;
    }
    if ( g1.fitness < minRunFitness ){
      minRunFitness = g1.fitness;
    }
    
    
    if ( g1.fitness > thresholdFitness ){
      boolean alreadyThere = false;
      println( "pre: " + genesAboveThreshold.size() );
      for ( int j=0; j<genesAboveThreshold.size(); j++ ){
        Gene gj = (Gene) genesAboveThreshold.get( j );
        if ( Arrays.equals( g1.geneStudentsAChoices, gj.geneStudentsAChoices ) && Arrays.equals( g1.geneStudentsBChoices, gj.geneStudentsBChoices ) ){
        //if ( round(g1.fitness*1000) == round(gj.fitness*1000) ){
          //println( "stuff was the same!" );
          alreadyThere = true;
          break;
        }
        else {
          //println( "IT'S DIFFERENT: " + g1.fitness + ", " + gj.fitness );
          //genesAboveThreshold.add( g1 );
          //break;
        }
      }
      
      if ( genesAboveThreshold.size() == 0 ){
        genesAboveThreshold.add( g1 );
      }
      else if ( alreadyThere == false ){
        genesAboveThreshold.add( g1 );
      }
      
      println( "post: " + genesAboveThreshold.size() );
    }
    
    
    if ( g1.fitness >= currentBestFitness ){
      currentBestFitness = g1.fitness;
      currentBestGene = g1;
      currentBestPhenome = new Phenome( currentBestGene );
    }
  }
}





////////////////////////////////////////
// 
//   INIT
//
////////////////////////////////////////

void initCourses(){
  int index = 0;
  courses = new ArrayList();
  courseTable = loadTable( CSVcourseFileName, "header" );
  numberOfCourses = courseTable.getRowCount();
  println( numberOfCourses );
  for ( TableRow row: courseTable.rows() ){
    String grp = row.getString( "Group" );
    String cnm = row.getString( "Full RISD Course String" );
    String ins = row.getString( "Instructor" );
    int min    = row.getInt( "Minimum Number" );
    int max    = row.getInt( "Maximum Number" );
    courses.add( new Course( grp, cnm, ins, min, max, index ) );
    index++;
  }
  numberOfCourses = courses.size();
}

ArrayList initCourses( int uselessInt ){ // uselessInt is just a signal for the ArrayList return
  int index = 0;
  ArrayList _courses = new ArrayList();
  for ( TableRow row: courseTable.rows() ){
    String grp = row.getString( "Group" );
    String cnm = row.getString( "Full RISD Course String" );
    String ins = row.getString( "Instructor" );
    int min    = row.getInt( "Minimum Number" );
    int max    = row.getInt( "Maximum Number" );
    _courses.add( new Course( grp, cnm, ins, min, max, index ) );
    index++;
  }
  return _courses;
}

void initStudents(){
  students = new ArrayList();
  studentTable = loadTable( CSVstudentFileName, "header" );
  //numberOfStudents = studentTable.getRowCount(); // might be false if we're checking duplicates
  println( numberOfStudents );
  for ( TableRow row: studentTable.rows() ){
    String tstmp       = row.getString( "Timestamp" );
    String eml         = row.getString( "Username" );
    String lsnm        = row.getString( "Last Name" );
    String fsnm        = row.getString( "First Name" );
    String clnmbr      = row.getString( "Mobile Contact Number" );
    int idnmbr         = row.getInt   ( "Student ID Number" );
    float gpa          = row.getFloat ( "Your Current GPA" );
    int gradyr         = row.getInt   ( "Student Graduating Year" );
    String gppref      = row.getString( "Select Your Category Priority" );
    
    ArrayList gpAch    = new ArrayList();
    ArrayList gpBch    = new ArrayList();
    gpAch.add( row.getString( "First Choice Category A" ) );
    gpAch.add( row.getString( "Second Choice Category A" ) );
    gpAch.add( row.getString( "Third Choice Category A" ) );
    gpAch.add( row.getString( "Fourth Choice Category A" ) );
    gpBch.add( row.getString( "First Choice Category B" ) );
    gpBch.add( row.getString( "Second Choice Category B" ) );
    gpBch.add( row.getString( "Third Choice Category B" ) );
    gpBch.add( row.getString( "Fourth Choice Category B" ) );
    
    for ( int i=0; i<students.size(); i++ ){
      Student si = (Student) students.get( i );
      if ( eml.equals( si.email ) || idnmbr == si.IDnumber ){
        println( "XXXX  Duplicate student! Removing.  XXXX" );
        students.remove( si );
      }
    }
    students.add( new Student( tstmp, eml, lsnm, fsnm, clnmbr, idnmbr, gpa, gradyr, gppref, gpAch, gpBch ) );
  }
  for ( int i=0; i<students.size(); i++ ){
    Student si = (Student) students.get( i );
    si.printChoices();
  }
  numberOfStudents = students.size();
  println( numberOfStudents );
}

void initColors(){
  choiceColors = new color[numberOfCourses];
  // blues
  choiceColors[0] = color(239, 243, 255);
  choiceColors[1] = color(189, 215, 231);
  choiceColors[2] = color(107, 174, 214);
  choiceColors[3] = color(49, 130, 189);
  choiceColors[4] = color(8, 81, 156);
  
  // Group A is blue
  choiceColorsBLUE = new color [] {
    #2171b5,
    #6baed6,
    #bdd7e7,
    #eff3ff
  };
  
  // Group B is red
  choiceColorsRED = new color [] {
    #cb181d,
    #fb6a4a,
    #fcae91,
    #fee5d9
  };
  
  choiceColorsGREEN = new color [] {
    #238b45,
    #74c476,
    #bae4b3,
    #edf8e9
  };
}



////////////////////////////////////////
// 
//   EVENTS
//
////////////////////////////////////////

void keyPressed(){
  if ( key == 's' || key == 'S' ){
    drawGenesAboveThreshold();
    save( year() + "-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".png" );
  }
}

void drawGenesAboveThreshold(){
  gATimg = createGraphics( 650, 600*genesAboveThreshold.size() );
  gATimg.beginDraw();
  for ( int i=0; i<genesAboveThreshold.size(); i++ ){
    Gene gi = (Gene) genesAboveThreshold.get( i );
    Phenome pi = new Phenome( gi );
    pi.render( 10, i*600 + 50, 1.8, gATimg );
  }
  gATimg.endDraw();
  gATimg.save( RENDERSAVEFOLDER + imgDate + "_aboveThreshold" + ".png" );
}

