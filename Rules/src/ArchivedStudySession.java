import java.util.ArrayList;

class ArchivedStudySession extends StudySession {

    protected double rating;

    protected ArchivedStudySession(Location location, Module module, String date,
                         String time, String title, String description,
                         ArrayList<String> participants, int capacity, String creatorID){
        this.location = location;
        this.module = module;
        this.date = date;
        this.time = time;
        this.title = title;
        this.description = description;
        this.participants = participants;
        this.studySessionID = Math.abs(rngGenerator.nextInt());
        this.capacity = capacity;
        this.creatorID = creatorID;
    }

    @Override
    public boolean isActive() {
        return false;
    }

    @Override
    public String toString() {
        return "------ STUDY SESSION ------" +
                "\nStudy Session Title: " + title +
                "\nStudy Session ID: " + studySessionID +
                "\nCreator ID: " + creatorID +
                "\nCreator Nickname: " + creatorNickName +
                "\nCapacity: " + String.format("%d/%d", noOfParticipants, capacity) +
                "\nLocation: " + location +
                "\nDate: " + date +
                "\nTime: " + time +
                "\nModule: " + module +
                "\nDescription: " + description  +
                " (Ended)";
    }
}
