import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;
import java.util.Set;
import java.util.HashSet;
import java.util.Collections;
import javafx.util.Pair;

class SuggestionItem implements Comparable<SuggestionItem> {
  final String value;
  final String description;

  SuggestionItem(String value, String description) {
    this.value = value;
    this.description = description;
  }

  boolean isMatch(String s) {
    return this.value.startsWith(s);
  }

  @Override
    int compareTo(SuggestionItem other) {
    int a = new Integer(this.value.length()).compareTo(new Integer(other.value.length()));
    if (a != 0) {
      return a;
    }

    int b = this.value.compareTo(other.value);

    if (b != 0) {
      return b;
    }

    return this.description.compareTo(other.description);
  }

  @Override
    boolean equals(Object b) {
    if (!(b instanceof SuggestionItem)) {
      return false;
    }

    SuggestionItem other = (SuggestionItem)b;

    return Objects.equals(this.value, other.value) &&  Objects.equals(this.description, other.description);
  }

  @Override
    int hashCode() {
    return Objects.hash(this.value, this.description);
  }
}

class Suggestion {
  // not empty
  final List<SuggestionItem> items;

  final int matchLen;

  Suggestion(List<SuggestionItem> items, int matchLen) {
    this.items = items;
    this.matchLen = matchLen;
  }

  @Override
    boolean equals(Object b) {
    if (!(b instanceof Suggestion)) {
      return false;
    }

    Suggestion other = (Suggestion)b;

    return Objects.equals(this.items, other.items) &&  Objects.equals(this.matchLen, other.matchLen);
  }

  @Override
    int hashCode() {
    return Objects.hash(this.items, this.matchLen);
  }
}

class CodeAnalyzerResult {
  // nullable
  String errorMsg;

  Map<Integer, Color> highlights;

  Set<Integer> errors;

  CodeAnalyzerResult(String errorMsg, Map<Integer, Color> highlights, Set<Integer> errors) {
    this.errorMsg = errorMsg;
    this.highlights = highlights;
    this.errors = errors;
  }

  CodeAnalyzerResult() {
    this(null, new HashMap(), new HashSet());
  }
}

class CodeAnalyzer {
  CodeAnalyzerResult analize(String code) {
    return new CodeAnalyzerResult();
  }

  Suggestion suggest(String code, int pos) {
    return null;
  }

  String applySuggest(String code, int pos, String item) {
    return null;
  }
}

class EditorListener {
  void cursorMove() {
  }
  void cursorMoveFail() {
  }
  void inputChar() {
  }
  void removeChar() {
  }
  void insertIndent() {
  }
  void insertLine() {
  }
}

boolean isOpenParent(char c) {
  return c == '(' || c == '{' || c == '[';
}

boolean isCloseParent(char c) {
  return c == ')' || c == '}' || c == ']';
}

// 対応する閉じ括弧を返す
char openToCloseParent(char c) {
  switch (c) {
    case '(':
      return ')';
    case '{':
      return '}';
    case '[':
      return ']';
    default:
      throw new RuntimeException();
  }
}

// 対応する開き括弧を返す
char closeToOpenParent(char c) {
  switch (c) {
    case ')':
      return '(';
    case '}':
      return '{';
    case ']':
      return '[';
    default:
      throw new RuntimeException();
  }
}

// 行のインデントの数を返す
int indentCount(List<Character> line) {
  int i = 0;
  for (char c : line) {
    if (c != ' ') {
      break;
    }
    i++;
  }
  return i;
}


void addIndent(List<Character> line, int n) {
    for (int i = 0; i < n; i++) {
      line.add(0, ' ');
    }
}

/*
対応する閉じ括弧の位置を探す、なければnull
*/
Pair<Integer, Integer> findCloseParent(List<List<Character>> lines, int rowPos, int colPos) {
  char open = lines.get(rowPos).get(colPos);
  char close = openToCloseParent(open);

  int level = 1;

  for (int i = rowPos; i < lines.size(); i++) {
    for (int j = (i == rowPos ? colPos + 1 : 0); j < lines.get(i).size(); j++) {
      char c = lines.get(i).get(j);
      if (c == open) {
        level++;
      }
      if (c == close) {
        level--;
      }
      if (level == 0) {
        return new Pair(i, j);
      }
    }
  }

  return null;
}

/*
対応する開き括弧の位置を探す、なければnull
*/
Pair<Integer, Integer> findOpenParent(List<List<Character>> lines, int rowPos, int colPos) {
  char close = lines.get(rowPos).get(colPos);
  char open = closeToOpenParent(close);

  int level = 1;

  for (int i = rowPos; i >= 0; i--) {
    for (int j = (i == rowPos ? colPos - 1 : lines.get(i).size() - 1); j >= 0; j--) {
      char c = lines.get(i).get(j);
      if (c == close) {
        level++;
      }
      if (c == open) {
        level--;
      }
      if (level == 0) {
        return new Pair(i, j);
      }
    }
  }

  return null;
}

class TextField {
  PFont font;
  EditorListener editorListener;
  String msg;

  String resultMsg;
  boolean resultError;

  List<Character> line;
  int pos;
  boolean enter = false;
  boolean quit = false;

  TextField (PFont font, EditorListener editorListener, String msg, String value) {
    this.font = font;
    this.editorListener = editorListener;
    this.msg = msg;
    this.line = new ArrayList();
    for (char c : value.toCharArray()) {
      this.line.add(c);
      this.pos++;
    }
  }

  String getValue() {
    StringBuffer s = new StringBuffer();
    for (char c : this.line) {
      s.append(c);
    }

    return s.toString();
  }

  void keyPressed() {
    if (this.quit) {
      return;
    }

    if (!this.enter) {
      if (keyCode == ENTER) {
        this.enter = true;
      } else if (keyCode == BACKSPACE) {
        if (this.pos > 0) {
          this.line.remove(this.pos - 1);
          this.pos--;
          this.editorListener.removeChar();
        } else {
          this.editorListener.cursorMoveFail();
        }
      } else if (keyCode == LEFT) {
        if (this.pos > 0) {
          this.pos--;
          this.editorListener.cursorMove();
        } else {
          this.editorListener.cursorMoveFail();
        }
      } else if (keyCode == RIGHT) {
        if (this.pos < this.line.size()) {
          this.pos++;
          this.editorListener.cursorMove();
        } else {
          this.editorListener.cursorMoveFail();
        }
      } else if (key == ESC) {
        this.quit = true;
        this.editorListener.cursorMoveFail();
      }
    }
  }

  void keyTyped() {
    if (!this.enter && !this.quit && isValidChar(key)) {
      this.line.add(this.pos, key);
      this.pos++;
      this.editorListener.inputChar();
    }
  }

  void draw() {
    if (this.quit) {
      return;
    }

    final int WIDTH = 1200;
    final int FONT_SIZE = 14;
    final int FONT_WIDTH = 8;
    final int FONT_HEIGHT = FONT_SIZE;
    textFont(this.font, FONT_SIZE);
    textLeading(FONT_HEIGHT);
    textAlign(LEFT, TOP);

    if (this.enter && this.resultError) {
      fill(255, 0, 0);
      rect(0, 0, WIDTH, FONT_HEIGHT);
    }

    String text;
    if (this.enter) {
      text = this.resultMsg;
    } else {
      text = this.msg + this.getValue();
    }

    fill(255, 255, 255);
    text(text, 0, 0);
  
    if (!this.enter) {
      fill(255, 255, 255, 100);
      rect((this.msg.length() + this.pos) * FONT_WIDTH, 0, FONT_WIDTH, FONT_HEIGHT);
    }
  }
}


class CodeEditor {
  TextField textField = null;
  String filename = null;
  // 保存モードがロードモードか
  boolean isSave; 

  Suggestion suggestion = null;
  // suggestion == nullの時意味なし
  int suggestionIndex = 0;

  final int MAX_SUGGESTION = 10;

  EditorListener editorListener = new EditorListener();

  CodeAnalyzer codeAnalyzer = new CodeAnalyzer();

  // 行の位置
  int rowPos;

  // 列の位置。行移動時にインデックスを超える可能性がある
  int colPos;

  // not empty
  List<List<Character>> lines;

  PFont font;

  CodeAnalyzerResult analyzerResult = new CodeAnalyzerResult();

  final int INDENT_SIZE = 2;

  // 描画できる最大の行数
  final int MAX_VIEW_LINE = 51;

  // 描画している一番上
  int drawTopLine = 0;

  CodeEditor() {
    this.lines = new ArrayList();
    this.lines.add(new ArrayList());
    this.font = loadFont("NotoMono-14.vlw");
  }

  // カーソルの前後に括弧のペアがあるかチェック
  // カーソル前後に文字がなければfalse
  boolean isCursorParent() {
    List<Character> line = this.lines.get(this.rowPos);
    if (0 < this.colPos && this.colPos < line.size()) {
      char leftC = line.get(this.colPos - 1);
      char rightC = line.get(this.colPos);
      return  (leftC == '(' && rightC == ')') ||
        (leftC == '[' && rightC == ']') ||
        (leftC == '{' && rightC == '}');
    } else {
      return false;
    }
  }

  // カーソルの左が全てスペースか
  boolean isCursorLeftAllSpace() {
    List<Character> line = this.lines.get(this.rowPos);
    int colPos = this.getWithinColPos();
    for (int i = 0; i < colPos; i++) {
      if (line.get(i) != ' ') {
        return false;
      }
    }

    return true;
  }

  void setText(String s) {
    this.lines = new ArrayList();

    if (!s.endsWith("\n")) {
      s += "\n";
    }

    for (String line : s.split("\n")) {
      ArrayList<Character> lineList = new ArrayList();
      for (char c : line.toCharArray()) {
        if (isValidChar(c)) {
          lineList.add(c);
        }
      }
      this.lines.add(lineList);
    }

    this.rowPos = 0;
    this.colPos = 0;
    this.drawTopLine = 0;
    this.codeAnalize();
    this.resetSuggestion();
  }

  void resetSuggestion() {
    this.suggestion = null;
  }

  void upSuggestion() {
    if (this.suggestionIndex == 0) {
      this.suggestionIndex = this.suggestion.items.size() - 1;
    } else {
      this.suggestionIndex--;
    }
  }

  void downSuggestion() {
    if (this.suggestionIndex == this.suggestion.items.size() - 1) {
      this.suggestionIndex = 0;
    } else {
      this.suggestionIndex++;
    }
  }

  void applySuggestion() {
    this.withinlizeColPos();

    int pos = 0;
    for (int i = 0; i < this.rowPos; i++) {
      pos += this.lines.get(i).size() + 1;
    }
    pos += this.colPos;

    String addString = this.codeAnalyzer.applySuggest(this.getText(), pos, this.suggestion.items.get(this.suggestionIndex).value);

    this.resetSuggestion();
    if (addString == null) {
      return;
    }

    List<Character> line = this.lines.get(this.rowPos);
    for (char c : addString.toCharArray()) {
      line.add(this.colPos, c);
      this.colPos++;
    }
  }

  void findSuggestion() {
    this.withinlizeColPos();

    int pos = 0;
    for (int i = 0; i < this.rowPos; i++) {
      pos += this.lines.get(i).size() + 1;
    }
    pos += this.colPos;

    Suggestion suggestion = this.codeAnalyzer.suggest(this.getText(), pos);

    if (suggestion == null) {
      this.resetSuggestion();
      return;
    }

    while (suggestion.items.size() > this.MAX_SUGGESTION) {
      suggestion.items.remove(suggestion.items.size() - 1);
    }

    this.suggestion = suggestion;
    this.suggestionIndex = 0;
  }

  String getText() {
    StringBuffer s = new StringBuffer();
    for (List<Character> line : this.lines) {
      for (char c : line) {
        s.append(c);
      }
      s.append('\n');
    }

    return s.toString();
  }

  void draw(int w, int h) {
    // 背景
    fill(0, 0, 0, 200);
    rect(0, 0, w, h);

    final int LEFT_PAD = 32;
    final int TOP_PAD = 32;

    clip(LEFT_PAD, TOP_PAD, w - 2 * LEFT_PAD, h - 2 * TOP_PAD);

    pushMatrix();
    translate(LEFT_PAD, TOP_PAD);

    final int FONT_SIZE = 14;
    final int FONT_WIDTH = 8;
    final int FONT_HEIGHT = FONT_SIZE;

    pushMatrix();
    translate(0, -this.drawTopLine * FONT_HEIGHT);

    textFont(this.font, FONT_SIZE);
    textLeading(FONT_HEIGHT);
    textAlign(LEFT, TOP);

    // 行番号の桁数
    int maxLineNumDigit = max(2, Integer.toString(this.lines.size() + 1).length());
    for (int i = this.drawTopLine; i < min(this.lines.size(), this.drawTopLine + this.MAX_VIEW_LINE); i++) {
      // 行番号
      fill(255, 255, 0);
      text(leftPad(Integer.toString(i + 1), maxLineNumDigit), 0, i * FONT_HEIGHT);
    }

    pushMatrix();
    translate((maxLineNumDigit + 1) * FONT_WIDTH, 0);

    /*
    カーソルの括弧描画
    */
    boolean drawParent = false;
    int drawParentOpenRow = 0;
    int drawParentOpenCol = 0;
    int drawParentCloseRow = 0;
    int drawParentCloseCol = 0;
    {
        List<Character> line = this.lines.get(this.rowPos);
        int withInColPos = this.getWithinColPos();
        if (withInColPos < line.size() && isOpenParent(line.get(withInColPos))) {
          Pair<Integer, Integer> closePos = findCloseParent(this.lines, this.rowPos, withInColPos);
          if (closePos != null) {
            drawParent = true;
            drawParentOpenRow = this.rowPos;
            drawParentOpenCol = withInColPos;
            drawParentCloseRow = closePos.getKey();
            drawParentCloseCol = closePos.getValue();
          }
        } else if (withInColPos < line.size() && isCloseParent(line.get(withInColPos))) {
          Pair<Integer, Integer> openPos = findOpenParent(this.lines, this.rowPos, withInColPos);
          if (openPos != null) {
            drawParent = true;
            drawParentOpenRow = openPos.getKey();
            drawParentOpenCol = openPos.getValue();
            drawParentCloseRow = this.rowPos;
            drawParentCloseCol = withInColPos;
          }
        } else if (withInColPos > 0 && isOpenParent(line.get(withInColPos - 1))) {
          Pair<Integer, Integer> closePos = findCloseParent(this.lines, this.rowPos, withInColPos - 1);
          if (closePos != null) {
            drawParent = true;
            drawParentOpenRow = this.rowPos;
            drawParentOpenCol = withInColPos - 1;
            drawParentCloseRow = closePos.getKey();
            drawParentCloseCol = closePos.getValue();
          }
        } else if (withInColPos > 0 && isCloseParent(line.get(withInColPos - 1))) {
          Pair<Integer, Integer> openPos = findOpenParent(this.lines, this.rowPos, withInColPos - 1);
          if (openPos != null) {
            drawParent = true;
            drawParentOpenRow = openPos.getKey();
            drawParentOpenCol = openPos.getValue();
            drawParentCloseRow = this.rowPos;
            drawParentCloseCol = withInColPos - 1;
          }
        }
    }

    int pos = 0;
    for (int i = 0; i < this.drawTopLine; i++) {
      pos += this.lines.get(i).size() + 1;
    }

    for (int i = this.drawTopLine; i < min(this.lines.size() + 1, this.drawTopLine + this.MAX_VIEW_LINE); i++) {
      boolean isEof = i == this.lines.size();

      List<Character> line = isEof ? new ArrayList() : this.lines.get(i);
      for (int j = 0; j < line.size() + 1; j++) {
        int x = j * FONT_WIDTH;
        int y = i * FONT_HEIGHT;

        boolean isEol = j == line.size();
        boolean isCursor = this.getWithinColPos() == j && this.rowPos == i;

        if (isEof) {
          fill(0, 255, 255, 100);
          text("[EOF]", x, y);
        } else if (isEol) {
          fill(0, 255, 255, 100);
          text('↲', x, y);
        } else {
          if (this.analyzerResult.highlights.containsKey(pos)) {
            Color cc = this.analyzerResult.highlights.get(pos);
            fill((int)(cc.r * 255), (int)(cc.g * 255), (int)(cc.b * 255));
          } else {
            fill(255, 255, 255);
          }
          char c = line.get(j);

          text(c, x, y);
        }

        if (isCursor) {
          fill(255, 255, 255, 100);
          rect(x, y, FONT_WIDTH, FONT_HEIGHT);
        }

        if (drawParent && i == drawParentOpenRow && j == drawParentOpenCol) {
          fill(255, 255, 0, 100);
          rect(x, y, FONT_WIDTH, FONT_HEIGHT);
        }

        if (drawParent && i == drawParentCloseRow && j == drawParentCloseCol) {
          fill(255, 255, 0, 100);
          rect(x, y, FONT_WIDTH, FONT_HEIGHT);
        }

        if (this.analyzerResult.errors.contains(pos)) {
          fill(255, 0, 0, 50);
          rect(x, y, FONT_WIDTH, FONT_HEIGHT);
        }

        pos++;
      }
    }

    popMatrix();
    popMatrix();
    
    pushMatrix();
    translate(0, this.MAX_VIEW_LINE * FONT_HEIGHT);
    if (this.textField != null) {
      this.textField.draw();
    } else if (this.analyzerResult.errorMsg != null) {
      fill(255, 0, 0);
      rect(0, 0, w, FONT_HEIGHT);

      fill(255, 255, 255);
      text(this.analyzerResult.errorMsg, 0, 0);
    }
    
    popMatrix();

    noClip();
    if (this.suggestion != null) {
      pushMatrix();
      translate((maxLineNumDigit + 1) * FONT_WIDTH, -this.drawTopLine * FONT_HEIGHT);
      translate((this.getWithinColPos() + 1) * FONT_WIDTH, (this.rowPos + 1) * FONT_HEIGHT);

      final int SUGGESTION_WIDTH_CHAR = 50;
      final int SUGGESTION_MAX_VALUE_LEN = 10;
      final int SUGGESTION_PAD_LEN = 5;
      final int SUGGESTION_MAX_DESC_LEN = 35;

      for (int i = 0; i < this.suggestion.items.size(); i++) {
        if (i == this.suggestionIndex) {
          fill(0, 0, 80);
        } else {
          fill(30, 30, 30);
        }
        rect(0, i * FONT_HEIGHT, SUGGESTION_WIDTH_CHAR * FONT_WIDTH, FONT_HEIGHT);

        SuggestionItem item = this.suggestion.items.get(i);
        String value = item.value;
        String description = item.description;
        int matchLen = min(SUGGESTION_MAX_VALUE_LEN, this.suggestion.matchLen);

        if (value.length() > SUGGESTION_MAX_VALUE_LEN) {
          value = value.substring(0, SUGGESTION_MAX_VALUE_LEN - 1) + "…";
        }

        if (description.length() > SUGGESTION_MAX_DESC_LEN) {
          description = description.substring(0, SUGGESTION_MAX_DESC_LEN - 1) + "…";
        }

        String valueLeft = value.substring(0, matchLen);
        String valueRight = value.substring(matchLen);

        fill(255, 255, 180);
        text(valueLeft, 0, i * FONT_HEIGHT);

        fill(255, 255, 255);
        text(valueRight, valueLeft.length() * FONT_WIDTH, i * FONT_HEIGHT);

        fill(180, 180, 180);
        text(description, (SUGGESTION_MAX_VALUE_LEN + SUGGESTION_PAD_LEN) * FONT_WIDTH, i * FONT_HEIGHT);
      }

      popMatrix();
    }

    popMatrix();
  }

  int getWithinColPos() {
    return Math.min(this.lines.get(this.rowPos).size(), this.colPos);
  }

  void setWithinColPos(int x) {
    this.colPos = Math.max(0, Math.min(this.lines.get(this.rowPos).size(), x));
  }

  void withinlizeColPos() {
    setWithinColPos(this.colPos);
  }

  void setRowPos(int x) {
    this.rowPos = Math.max(0, Math.min(this.lines.size() - 1, x));

    if (this.rowPos < this.drawTopLine) {
      this.drawTopLine = this.rowPos;
    } else if (this.rowPos >= this.drawTopLine + this.MAX_VIEW_LINE - 1) {
      this.drawTopLine = this.rowPos - this.MAX_VIEW_LINE + 2;
    }
  }

  boolean keyPressed() {
    if (this.textField != null && this.textField.enter) {
      this.textField = null;
    }

    if (this.textField != null) {
      this.textField.keyPressed();
      if (this.textField.quit) {
        this.textField = null;
      } else if (this.textField.enter && this.textField.resultMsg == null) {
        String filename = this.textField.getValue();
        if (!filename.matches("[a-z0-9_\\-]{1,24}")) {
          this.textField.resultMsg = "Invalid filename.";
          this.textField.resultError = true;
          return false;
        }

        if (this.isSave) {
          try {
            writeFileAll("code/" + filename, this.getText());
            this.filename = filename;

            this.textField.resultMsg = "Saved.";
            this.textField.resultError = false;
            this.editorListener.insertLine();
          } catch (RuntimeException e) {
            this.textField.resultMsg = "Save Error.";
            this.textField.resultError = true;
            this.editorListener.cursorMoveFail();
          }
        } else {
          try {
            this.setText(readFileAll("code/" + filename));
            this.filename = filename;

            this.textField.resultMsg = "Loaded.";
            this.textField.resultError = false;
            this.editorListener.insertLine();
          } catch (RuntimeException e) {
            this.textField.resultMsg = "Load Error.";
            this.textField.resultError = true;
            this.editorListener.cursorMoveFail();
          }
        }
      }
      return false;
    }

    boolean isQuit = false;

    int startRowPos = this.rowPos;
    int startColPos = this.getWithinColPos();
    boolean move = false;

    if (keyCode == ENTER) {
      if (this.suggestion == null) {
        this.insertLine();
      } else {
        this.applySuggestion();
      }
      this.editorListener.insertLine();
    } else if (keyCode == BACKSPACE) {
      boolean isRemove =  this.deleteChar();
      if (this.suggestion != null) {
        this.findSuggestion();
      }
      if (isRemove) {
        this.editorListener.removeChar();
      } else {
        this.editorListener.cursorMoveFail();
      }
    } else if (keyCode == LEFT) {
      this.toLeft();
      move = true;
      if (this.suggestion != null) {
        this.resetSuggestion();
      }
    } else if (keyCode == RIGHT) {
      this.toRight();
      move = true;
      if (this.suggestion != null) {
        this.resetSuggestion();
      }
    } else if (keyCode == UP) {
      if (this.suggestion == null) {
        this.toUp();
        move = true;
      } else {
        this.upSuggestion();
        this.editorListener.cursorMove();
      }
    } else if (keyCode == DOWN) {
      if (this.suggestion == null) {
        this.toDown();
        move = true;
      } else {
        this.downSuggestion();
        this.editorListener.cursorMove();
      }
    } else if (keyCode == TAB) {
      this.insertIndent();
      if (this.suggestion != null) {
        this.resetSuggestion();
      }
      this.editorListener.insertIndent();
    } else if (key == ESC) {
      if (this.suggestion != null) {
        this.resetSuggestion();
      } else {
        isQuit = true;
      }
    }

    if (move) {
      if (startRowPos != this.rowPos || startColPos != this.getWithinColPos()) {
        this.editorListener.cursorMove();
      } else {
        this.editorListener.cursorMoveFail();
      }
    }

    this.codeAnalize();

    return isQuit;
  }

  void keyTyped() {
    if (this.textField != null) {
      this.textField.keyTyped();
      return;
    }

    if (isCtrl || isCmd) {
      if (key == 'k') {
        removeLine();
        this.resetSuggestion();
        this.editorListener.removeChar();
      } else if (key == 'l') {
        this.isSave = false;
        this.textField = new TextField(this.font, this.editorListener, "filename: ", "");
      } else if (key == 's' || key == 'S') {
        this.isSave = true;
        this.textField = new TextField(this.font, this.editorListener, "filename: ", this.filename != null ?  this.filename : "");
        if (!isShift && this.filename != null) {
          try {
            writeFileAll("code/" + filename, this.getText());
            this.textField.enter = true;

            this.filename = filename;
            this.textField.resultMsg = "Saved.";
            this.textField.resultError = false;
          } catch (RuntimeException e) {
            this.textField.resultMsg = "Save Error.";
            this.textField.resultError = true;
          }
        }
      }
    } else {
      if (isValidChar(key)) {
        this.insertChar(key);
        this.findSuggestion();
        this.editorListener.inputChar();
      }
    }

    this.codeAnalize();
  }

  boolean deleteChar() {
    this.withinlizeColPos();

    if (this.colPos > 0) {
      List<Character> line = this.lines.get(this.rowPos);
      if (this.isCursorParent()) {
        line.remove(this.colPos);
        this.colPos--;
        line.remove(this.colPos);

        return true;
      } else if (this.isCursorLeftAllSpace()) {
        int removeLen = this.colPos % INDENT_SIZE == 0 ? INDENT_SIZE : this.colPos % INDENT_SIZE ;
        for (int i = 0; i < removeLen; i++) {
          line.remove(0);
        }
        this.colPos -= removeLen;

        return true;
      } else {
        line.remove(this.colPos - 1);
        this.colPos--;

        return true;
      }
    } else if (this.rowPos > 0) {
      List<Character> removeLine = this.lines.remove(this.rowPos);
      this.setRowPos(this.rowPos - 1);
      this.colPos = this.lines.get(this.rowPos).size();
      this.lines.get(this.rowPos).addAll(removeLine);
      return true;
    } else {
      return false;
    }
  }

  void insertIndent() {
    this.withinlizeColPos();

    List<Character> line = this.lines.get(this.rowPos);
    int insertSize = this.colPos % this.INDENT_SIZE == 0 ? this.INDENT_SIZE : this.INDENT_SIZE - this.colPos % this.INDENT_SIZE;

    for (int i = 0; i < insertSize; i++) {
      line.add(this.colPos, ' ');
      this.colPos++;
    }
  }

  void insertChar(char c) {
    this.withinlizeColPos();

    List<Character> line = this.lines.get(this.rowPos);

    if (this.isCursorParent() && line.get(this.colPos) == c) {
      this.colPos++;
    } else {
      boolean isCursorLeftAllSpace = this.isCursorLeftAllSpace();

      line.add(this.colPos, c);
      this.colPos++;

      if (isOpenParent(c) && (this.colPos >= line.size() || line.get(this.colPos) == ' ')) {
        line.add(this.colPos, openToCloseParent(c));
      }

      if (isCloseParent(c) && isCursorLeftAllSpace) {
        Pair<Integer, Integer> openPos = findOpenParent(this.lines, this.rowPos, this.colPos - 1);
        if (openPos != null) {
          int indentCount = indentCount(line);
          for (int i = 0; i < indentCount; i++) {
            line.remove(0);
            this.colPos--;
          }

          int newIndent = indentCount(this.lines.get(openPos.getKey()));
          for (int i = 0; i < newIndent; i++) {
            line.add(0, ' ');
            this.colPos++;
          }
        }
      }
    }
  }

  void removeLine() {
    this.lines.remove(this.rowPos);
    if (this.lines.size() == 0) {
      this.lines.add(new ArrayList());
    }
    this.setRowPos(this.rowPos - 1);
  }

  void insertLine() {
    this.withinlizeColPos();

    List<Character> line = this.lines.get(this.rowPos);

    boolean isCursorLeftOpenParent = 0 < this.colPos && this.colPos <= line.size() && isOpenParent(line.get(this.colPos - 1));
    boolean isCursorParent = this.isCursorParent();

    List<Character> lineLeft = listLimit(line, this.colPos);
    List<Character> lineRight = listSkip(line, this.colPos);

    int leftIndent = indentCount(lineLeft);
    addIndent(lineRight, leftIndent);

    this.lines.set(this.rowPos, lineLeft);
    this.colPos = leftIndent;

    this.lines.add(this.rowPos + 1, lineRight);
    this.setRowPos(this.rowPos + 1);

    if (isCursorLeftOpenParent) {
      addIndent(lineRight, this.INDENT_SIZE);
      this.colPos += this.INDENT_SIZE;
    }

    if (isCursorParent) {
      List<Character> lineRightLeft = listLimit(lineRight, this.colPos);
      List<Character> lineRightRight = listSkip(lineRight, this.colPos);

      this.lines.set(this.rowPos, lineRightLeft);
      addIndent(lineRightRight, leftIndent);
      this.lines.add(this.rowPos + 1, lineRightRight);
    }
  }

  void codeAnalize() {
    this.analyzerResult = this.codeAnalyzer.analize(this.getText());
  }

  void toLeft() {
    int colPos = this.getWithinColPos();

    if (colPos != 0) {
      this.setWithinColPos(colPos - 1);
    } else if (this.rowPos != 0) {
      this.setRowPos(this.rowPos - 1);
      this.setWithinColPos(this.lines.get(this.rowPos).size());
    }
  }

  void toRight() {
    int colPos = this.getWithinColPos();

    if (colPos != this.lines.get(this.rowPos).size()) {
      this.setWithinColPos(colPos+ 1);
    } else if (this.rowPos != this.lines.size() - 1) {
      this.setRowPos(this.rowPos + 1);
      this.setWithinColPos(0);
    }
  }

  void toUp() {
    if (this.rowPos == 0) {
      this.colPos = 0;
    } else {
      this.setRowPos(this.rowPos - 1);
    }
  }

  void toDown() {
    if (this.rowPos == this.lines.size() - 1) {
      this.colPos = this.lines.get(this.rowPos).size();
    } else {
      this.setRowPos(this.rowPos + 1);
    }
  }
}

boolean isValidChar(char c) {
  return 0x20 <= c && c <= 0x7e;
}

String leftPad(String s, int n) {
  while (s.length() < n) {
    s = " " + s;
  }
  return s;
}
