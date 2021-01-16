import java.util.ArrayList;

public class History {
    ArrayList<StudySession> studySessions;

    void addToHistory(StudySession ss) {
        studySessions.add(ss);
    }

    @Override
    public String toString() {
        String string = null;
        for(StudySession s : studySessions) {
            string += "/n" + s;
        }
        return "History:" + string;
    }
}
