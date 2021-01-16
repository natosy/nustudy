import java.util.ArrayList;
import java.util.Random;

abstract class StudySession {

    static Random rngGenerator = new Random(4);
    protected Location location;
    protected Module module;
    protected String date;
    protected String time;
    protected String title;
    protected String description;
    protected ArrayList<String> participants = new ArrayList<>();
    protected int studySessionID;
    protected String creatorID;
    protected String creatorNickName;
    protected int capacity;
    protected int noOfParticipants;

    static ActiveStudySession create(Location location, Module module, String date,
                                     String time, String title, String description,
                                     int capacity, String creatorID) {
        return new ActiveStudySession(location, module, date, time, title, description, capacity, creatorID);
    }

    public boolean isActive(){
        return false;
    }

    public String getCreatorID() {
        return creatorID;
    }

    public Location getLocation() {
        return location;
    }

    public int getStudySessionID() {
        return studySessionID;
    }

    public String getDescription() {
        return description;
    }

    public String getTitle() {
        return title;
    }

    public String getTime() {
        return time;
    }

    public Module getModule() {
        return module;
    }

    public String getDate() {
        return date;
    }

    public ArrayList<String> getParticipants(){
        return participants;
    }

}
