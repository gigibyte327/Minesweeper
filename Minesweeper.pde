import de.bezier.guido.*;
private int NUM_COLS = 20, NUM_ROWS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList < MSButton > bombs = new ArrayList < MSButton > ();
public boolean gameOver = false;
void setup() {
    size(400, 400);
    textAlign(CENTER, CENTER);
    Interactive.make(this);
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int i = 0; i < NUM_ROWS; i++) {
        for (int j = 0; j < NUM_COLS; j++) {
            buttons[i][j] = new MSButton(i, j);
        }
    }

    setBombs();
}

public void setBombs() {
    int nBombs = 40;
    for (int i = 0; i < nBombs; i++) {
        int row = (int)(Math.random() * NUM_ROWS);
        int col = (int)(Math.random() * NUM_COLS);
        if (!bombs.contains(buttons[row][col])) {
            bombs.add(buttons[row][col]);
        }
    }
}

public void draw() {
    background(0);
    if (isWon()) {
        displayWinningMessage();
    }

}
public boolean isWon() {
    int countClicked = 0;
    int countBomb = 0;
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (buttons[r][c].isClicked())
                countClicked++;
            else if (bombs.contains(buttons[r][c]))
                countBomb++;
            if (NUM_ROWS * NUM_COLS == countClicked + countBomb){
                return true;
            }
        }
    }
    return false;
}
public void displayLosingMessage() {
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (bombs.contains(buttons[r][c])) {
                buttons[r][c].clicked=true;
            }
        }
    }
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel(" ");
    buttons[10][10].setLabel("L");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("S");
    buttons[10][13].setLabel("E");
    buttons[10][14].setLabel("!");
}
public void displayWinningMessage() {
    gameOver = true;
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel(" ");
    buttons[10][10].setLabel("W");
    buttons[10][11].setLabel("I");
    buttons[10][12].setLabel("N");
    buttons[10][13].setLabel("!");
}

public class MSButton {
    private int r, c;
    private float x, y, width, height;
    private boolean clicked, marked;
    private String label;

    public MSButton(int rr, int cc) {
        width = 400 / NUM_COLS;
        height = 400 / NUM_ROWS;
        r = rr;
        c = cc;
        x = c * width;
        y = r * height;
        label = "";
        marked = clicked = false;
        Interactive.add(this);
    }
    public boolean isMarked() {
        return marked;
    }
    public boolean isClicked() {
        return clicked;
    }
    public void mousePressed() {
        if (gameOver == false) {
            if (mouseButton == LEFT && isMarked() == false)
                clicked = true;
            if (mouseButton == RIGHT && isClicked() == false) {
                marked = !marked;
            } else if (bombs.contains(this) && isMarked() == false) {
                gameOver = true;
                displayLosingMessage();
            } else if (this.countBombs(r, c) > 0) {
                if (isMarked() == false)
                    label = "" + countBombs(r, c);
                else if (isMarked() == true)
                    clicked = !clicked;
            } else {
                if (isValid(r, c - 1) && buttons[r][c - 1].isClicked() == false) {
                    buttons[r][c - 1].mousePressed();
                }
                if (isValid(r, c + 1) && buttons[r][c + 1].isClicked() == false) {
                    buttons[r][c + 1].mousePressed();
                }
                if (isValid(r - 1, c - 1) && buttons[r - 1][c - 1].isClicked() == false) {
                    buttons[r - 1][c - 1].mousePressed();
                }
                if (isValid(r - 1, c) && buttons[r - 1][c].isClicked() == false) {
                    buttons[r - 1][c].mousePressed();
                }
                if (isValid(r - 1, c + 1) && buttons[r - 1][c + 1].isClicked() == false) {
                    buttons[r - 1][c + 1].mousePressed();
                }
                if (isValid(r + 1, c - 1) && buttons[r + 1][c - 1].isClicked() == false) {
                    buttons[r + 1][c - 1].mousePressed();
                }
                if (isValid(r + 1, c + 1) && buttons[r + 1][c + 1].isClicked() == false) {
                    buttons[r + 1][c + 1].mousePressed();
                }
                if (isValid(r + 1, c) && buttons[r + 1][c].isClicked() == false) {
                    buttons[r + 1][c].mousePressed();
                }
            }
        }
    }

    public void draw() {
        if (marked)
            fill(0);
        else if (clicked && bombs.contains(this))
            fill(255, 0, 0);
        else if (clicked) {
            fill(200);
        } else
            fill(100);
        rect(x, y, width, height);
        fill(0);
        text(label, x + width / 2, y + height / 2);
    }
    public void setLabel(String newLabel) {
        label = newLabel;
    }
    public boolean isValid(int r, int c) {
        if (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0) {
            return true;
        }
        return false;
    }
    public int countBombs(int row, int col) {
        int numBombs = 0;
        if (isValid(row + 1, col) && bombs.contains(buttons[row + 1][col]))
            numBombs++;
        if (isValid(row - 1, col) && bombs.contains(buttons[row - 1][col]))
            numBombs++;
        if (isValid(row, col + 1) && bombs.contains(buttons[row][col + 1]))
            numBombs++;
        if (isValid(row, col - 1) && bombs.contains(buttons[row][col - 1]))
            numBombs++;
        if (isValid(row + 1, col + 1) && bombs.contains(buttons[row + 1][col + 1]))
            numBombs++;
        if (isValid(row - 1, col + 1) && bombs.contains(buttons[row - 1][col + 1]))
            numBombs++;
        if (isValid(row + 1, col - 1) && bombs.contains(buttons[row + 1][col - 1]))
            numBombs++;
        if (isValid(row - 1, col - 1) && bombs.contains(buttons[row - 1][col - 1]))
            numBombs++;
        return numBombs;
    }
}
