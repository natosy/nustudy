class ActiveStudySession extends StudySession {


    protected ActiveStudySession(Location location, Module module, String date,
                       String time, String title, String description,
                       int capacity, String creatorID){
        this.location = location;
        this.module = module;
        this.date = date;
        this.time = time;
        this.title = title;
        this.description = description;
        this.studySessionID = Math.abs(rngGenerator.nextInt());
        this.capacity = capacity;
        this.creatorID = creatorID;
        this.addParticipant(creatorID);
    }

    public void addParticipant(String participantID) {
        if (noOfParticipants < capacity) {
            participants.add(participantID);
            noOfParticipants++;
        }
    }

    public void removeParticipant(String participantID) {
        if (participantID.equals(creatorID)) {
            System.out.println("Unable to remove user from Study Session as user is the creator.\n");
        } else {
            participants.removeIf(ID -> ID.equals(participantID));
            noOfParticipants--;
        }
    }

    public ArchivedStudySession endStudySession() {
        // prompt all users for rating?? but i dont know how.
        // rateStudySession() method should be triggered and prompt users for rating
        // addSToHistory() method should be executed for all accounts of participants
        return new ArchivedStudySession(location, module,
                date, time, title,description, participants,
                capacity,creatorID);
    }

    public boolean isEditableByAccount(String NUSNETID) {
        return getCreatorID().equals(NUSNETID);
    }

    @Override
    public boolean isActive(){
        return true;
    }

    public void updateLocation(String NUSNETID, Location location){
        if (isEditableByAccount(NUSNETID)) {
            this.location = location;
            System.out.println("Successfully updated location to: " + location + "\n");
        } else {
            System.out.println("Unable to update location as user is not creator of study session.\n");
        }
    }

    public void updateDate(String NUSNETID, String date){
        if (isEditableByAccount(NUSNETID)) {
            this.date = date;
            System.out.println("Successfully updated date to: " + date + "\n");
        } else {
            System.out.println("Unable to update date as user is not creator of study session.\n");
        }
    }

    public void updateTime(String NUSNETID, String time){
        if (isEditableByAccount(NUSNETID)) {
            this.time = time;
            System.out.println("Successfully updated time to: " + time + "\n");
        } else {
            System.out.println("Unable to update time as user is not creator of study session.\n");
        }
    }

    public void updateTitle(String NUSNETID, String title){
        if (isEditableByAccount(NUSNETID)) {
            this.title = title;
            System.out.println("Successfully updated title to: " + title + "\n");
        } else {
            System.out.println("Unable to update title as user is not creator of study session.\n");
        }
    }

    public void updateDescription(String NUSNETID, String description){
        if (isEditableByAccount(NUSNETID)) {
            this.description = description;
            System.out.println("Successfully updated description to: " + description + "\n");
        } else {
            System.out.println("Unable to update description as user is not creator of study session.\n");
        }
    }

    @Override
    public String toString() {
        return "------ STUDY SESSION ------" +
                "\nStudy Session Title: " + title +
                "\nStudy Session ID: " + studySessionID +
                "\nCreator ID: " + creatorID +
//                "\nCreator Nickname: " + creatorNickName +
                "\nCapacity: " + String.format("%d/%d", noOfParticipants, capacity) +
                "\nLocation: " + location +
                "\nDate: " + date +
                "\nTime: " + time +
                "\nModule: " + module +
                "\nDescription: " + description  +
                "\n(Active)\n ------ END ------";
    }
}
