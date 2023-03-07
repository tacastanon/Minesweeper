import de.bezier.guido.*;
public final static int NUM_ROWS = 25;
public final static int NUM_COLS = 25;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup()
{
  size(500, 500);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS]; //first call to new
  for (int i = 0; i < NUM_ROWS; i++)
    for (int j = 0; j < NUM_COLS; j++)
      buttons[i][j] = new MSButton(i, j);
  mines = new ArrayList <MSButton>(); 
  setMines();
}
public void setMines()
{
  //your code
  for (int i = 0; i < (NUM_ROWS*NUM_COLS)/10; i++) {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    while (mines.contains(buttons[row][col])) {
      row = (int)(Math.random()*(NUM_ROWS));
      col = (int)(Math.random()*(NUM_COLS));
    }
    mines.add(buttons[row][col]);
  }
}

public void draw ()
{
  background(0);
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
  //your code here
  int count  = 0;
  for (int i = 0; i < NUM_ROWS; i++)
    for (int j = 0; j < NUM_COLS; j++)
      if (buttons[i][j].clicked == true && buttons[i][j].flagged == false)
        count++;
  if (count == NUM_ROWS*NUM_COLS-mines.size())
    return true;
  return false;
}

public void displayLosingMessage()
{
  //for(int r = 0; r < NUM_ROWS; r++){
    //for(int c = 0; c < NUM_COLS; c++){
      buttons[5][10].setLabel("N");
      buttons[5][11].setLabel("I");
      buttons[5][12].setLabel("C");
      buttons[5][13].setLabel("E");
      buttons[6][10].setLabel("T");
      buttons[6][11].setLabel("R");
      buttons[6][12].setLabel("Y");
      buttons[6][13].setLabel("!");
//your code here
}

public void displayWinningMessage()
{
  //your code here
  for (int i = 0; i < NUM_ROWS; i++)
    for (int j = 0; j < NUM_COLS; j++)
      buttons[i][j].setLabel(":)");
}
public boolean isValid(int r, int c)
{
  //your code here
  if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
    return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  for (int i = row-1; i <= row+1; i++)
    for (int j = col-1; j <= col+1; j++)
      if (isValid(i, j))
        if (mines.contains(buttons[i][j]))
          numMines++;
  //check if box is mine, return nums of mines
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 500/NUM_COLS;
    height = 500/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  //called by manager
  public void mousePressed() 
  {
    clicked = true;
    if (mouseButton == RIGHT) {
      flagged = !flagged;
      if (flagged == false)
        clicked = false;
    } else if (mines.contains( this ))
      displayLosingMessage();
    else if (countMines(myRow, myCol) > 0)
      setLabel(countMines(myRow, myCol));
    else { 
      for (int i = myRow-1; i <= myRow+1; i++)
        for (int j = myCol-1; j <= myCol+1; j++)
          if (isValid(i, j))
            if (!(mines.contains(buttons[i][j])) && buttons[i][j].clicked == false)
              buttons[i][j].mousePressed();
    }
    //your code here
  }
  public void draw () 
  {    
    if (flagged)
      fill(0,0,255);
    else if (clicked && mines.contains(this)) 
      fill(255, 0, 0);
    else if (clicked)
      fill(200);
    else 
    fill(100);
    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
