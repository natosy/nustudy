import org.w3c.dom.ls.LSOutput;

import java.util.ArrayList;

public class Account {
    int year;
    ArrayList<Module> modules;
    Profile profile;
    String password;
    String NUSNETID;

    protected Account(ArrayList<Module> modules, String password, String NUSNETID, String nickname, String biography, int year){
        this.modules = modules;
        this.password = password;
        this.NUSNETID = NUSNETID;
        this.profile = new Profile(0, biography, nickname, year);
        this.year = year;
    }

    static Account create(ArrayList<Module> modules,
                          String password, String NUSNETID, String nickname,
                          String biography, int year) {
        return new Account(modules, password, NUSNETID, nickname, biography, year);
    }

//    public int getAccountID() {
//        return accountID;
//    }

    public String getNUSNETID() {
        return NUSNETID;
    }

    public String getNickName() {
        return profile.getNickname();
    }

    public ActiveStudySession createStudySession(Location location, Module module, String date, String time, String title, String description, int capacity) {
        return StudySession.create(location, module, date, time, title, description, capacity, NUSNETID);
    }

    public void addAccountModule(String string) {
        modules.add(Database.findModule(string));
        System.out.println("Successfully added module " + string + " to account: " + getNickName() + "\n");
    }

    public void removeAccountModule(String string) {
        int initialLength = modules.size();
        modules.removeIf(mod -> string.equals(mod.moduleCode));
        int finalLength = modules.size();
        if (finalLength != initialLength) {
            System.out.println("Successfully removed module from account " + getNickName() + ": " + string);
        } else {
            System.out.println("No such module " + string + " is taken by student, and cannot be removed.");
        }
    }

    public void viewAccountModules() {
        System.out.println("---------------\n"
                + getNickName() + "'s Modules: \n---------------");
        for (Module m : modules) System.out.println(m + "\n ---");
    }

    public ActiveStudySession findStudySessionByModuleCode(String string) {
        return Database.findStudySessionByModuleCode(string);
    }

    public ActiveStudySession findStudySessionByLocation(String string) {
        return Database.findStudySessionByLocation(string);
    }

    public void joinStudySession(ActiveStudySession ss) {
        ss.addParticipant(this.NUSNETID);
    }

    public void leaveStudySession(ActiveStudySession ss) {
        ss.removeParticipant(this.NUSNETID);
    }

    public void addStudySessionToHistory(StudySession ss) {
        profile.addToHistory(ss);
    }
    public void editStudySessionLocation(ActiveStudySession ss, Location location) {
        ss.updateLocation(getNUSNETID(), location);
    }

    public void editStudySessionDate(ActiveStudySession ss, String date) {
        ss.updateDate(getNUSNETID(), date);
    }

    public void editStudySessionTime(ActiveStudySession ss, String time) {
        ss.updateTime(getNUSNETID(), time);
    }

    public void editStudySessionTitle(ActiveStudySession ss, String title) {
        ss.updateTitle(getNUSNETID(), title);
    }

    public void editStudySessionDescription(ActiveStudySession ss, String description) {
        ss.updateDescription(getNUSNETID(), description);
    }

    public void editNickname(String nickname) {
        profile.updateNickname(nickname);
    }

    public void editBiography(String biography) {
        profile.updateBiography(biography);
    }

    @Override
    public String toString(){
        String modsTaken = "";
        for (Module m: modules){
            modsTaken += m.toString();
            modsTaken +="\n\n";
        }
        return String.format("------------------------------" +
                        "\n\nNickname: %s" +
                        "\nNUSNET ID: %s" +
                        "\nYear: %d" +
                        "\nRating: %.02f" +
                        "\nBiography: %s" +
                        "\n\nModules taken:" +
                        "\n%s" +
                        "\n------------------------------\n",
                this.getNickName(), this.NUSNETID, this.year,
                this.profile.getRating(), this.profile.getBiography(), modsTaken);
    }
}
