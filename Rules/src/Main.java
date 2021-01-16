import java.util.ArrayList;

public class Main {
    public static void main(String[] args){

        Module CS3243 = Module.create("CS3243", "Introduction to Artificial Intelligence");
        Module CS2040S = Module.create("CS2040S", "Data Structures and Algorithm Analysis");
        Module CS2030 = Module.create("CS2030", "Programming Methodology II");
        Module CS1101S = Module.create("CS1101S", "Programming Methodology I");

        Database.addModule(CS3243);
        Database.addModule(CS2030);
        Database.addModule(CS2040S);
        Database.addModule(CS1101S);


//        for (Module module : Database.modules) {
//            System.out.println(module + "\n");
//        }

        ArrayList<Module> neilModules = new ArrayList<>();
        ArrayList<Module> natModules = new ArrayList<>();

        Account neilAccount = Account.create(neilModules, "12345678", "EXXXXXXX", "Jargonx",
                "just a regular cs student",2);
        Account natAccount = Account.create(natModules, "27272727", "E0439238", "natosy",
                "just another student", 2);

//        Database.addAccount(neilAccount);
//        Database.addAccount(natAccount);

        neilAccount.addAccountModule("CS2030");
        neilAccount.addAccountModule("CS2040S");

        natAccount.addAccountModule("CS2030");
        natAccount.addAccountModule("CS1101S");

        //System.out.println(neilAccount);

        Location home = Location.create("Neil's House");
        ActiveStudySession neilStudySession = neilAccount.createStudySession(home, CS2040S, "Today", "Now", "House Party", "BYOB", 30);

        natAccount.joinStudySession(neilStudySession);
        neilAccount.leaveStudySession(neilStudySession);

        neilAccount.editStudySessionDescription(neilStudySession, "just come come come come");
//        System.out.println(neilStudySession);
//        System.out.println(neilAccount);
//        System.out.println(natAccount);
        natAccount.viewAccountModules();
    }
}
