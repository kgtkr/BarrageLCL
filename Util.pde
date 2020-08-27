import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;


String readFileAll(String path) {
  try {
    List<String> lines = Files.readAllLines(Paths.get(dataPath(path)), Charset.forName("UTF-8"));
    return String.join("\n", lines);
  } 
  catch (IOException e) {
    throw new RuntimeException(e);
  }
}
