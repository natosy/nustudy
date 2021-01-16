import java.util.ArrayList;
import java.util.Scanner;

public class Database {
    private static Scanner sc = new Scanner(System.in);

//    public static ArrayList<Account> accounts = new ArrayList<>();
    public static ArrayList<Module> modules = new ArrayList<>();
    public static ArrayList<StudySession> studySessions = new ArrayList<>();

    static Module findModule(String string) {
        for (Module mod : modules) {
            if (string.equals(mod.moduleCode)) {
                System.out.println("Successfully retrieved module from database: " + string + ", " + mod.moduleTitle);
                return mod;
            }
        }
        System.out.println("Unable to find module " + string + " in database. Try again.");
        return null;
    }

    // dirty method for testing
    static ActiveStudySession findStudySessionByModuleCode(String string) {
        ArrayList<ActiveStudySession> list = new ArrayList<>();
        int count = 0;
        for (StudySession ss : studySessions) {
            if (ss.isActive() && ss.getModule().moduleCode.equals(string)) {
                list.add((ActiveStudySession) ss);
                count++;
            }
        }
        if (count == 0) {
            System.out.println("Unable to find Study Session for module: " + string +
                    ". \n Create a new Study Session or search for another module.");
        } else {
            return selectStudySession(list, count);
        }
        return null;
    }

    static ActiveStudySession findStudySessionByLocation(String string) {
        ArrayList<ActiveStudySession> list = new ArrayList<>();
        int count = 0;
        for (StudySession ss : studySessions) {
            if (ss.isActive() && ss.getLocation().getName().contains(string)) {
                list.add((ActiveStudySession) ss);
                count++;
            }
        }
        if (count == 0) {
            System.out.println("Unable to find Study Session at location: " + string +
                    ". \n Create a new Study Session or search for another location.");
        } else {
            return selectStudySession(list, count);
        }
        return null;
    }

    static ActiveStudySession selectStudySession(ArrayList<ActiveStudySession> list, int count) {
        int selection = 1;
        System.out.println("There are " + count + "Study Sessions available. Enter a number from 1 to "
                + count + "to select the Study Sessions below: \n");
        for (ActiveStudySession ss : list) {
            System.out.println("(" + selection + ")\n" + ss);
            selection++;
        }
        int choice = sc.nextInt();
        return list.get(choice - 1);
    }

//    static void addAccount(Account account) {
//        accounts.add(account);
//    }

    // admin method
    static void addModule(Module module) {
        modules.add(module);
    }

    // admin method
    static void removeModule(Module module) {
        modules.removeIf(module::equals);
    }

    static void addStudySession(StudySession ss) {
        studySessions.add(ss);
    }

}
