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

<T> List<T> listLimit(List<T> list, int n) {
  List<T> result = new ArrayList();
  for (int i = 0; i < min(n, list.size()); i++) {
    result.add(list.get(i));
  }

  return result;
}

<T> List<T> listSkip(List<T> list, int n) {
  List<T> result = new ArrayList();
  for (int i = n; i < list.size(); i++) {
    result.add(list.get(i));
  }

  return result;
}
