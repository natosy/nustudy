import java.util.Random;

public class Module {
    static Random rngGenerator = new Random(2);
    int moduleId;
    String moduleCode;
    String moduleTitle;

    private Module(String moduleCode, String moduleTitle){
        this.moduleCode = moduleCode;
        this.moduleTitle = moduleTitle;
        this.moduleId = Math.abs(rngGenerator.nextInt());
    }

    static Module create(String moduleCode, String moduleTitle){
        return new Module(moduleCode, moduleTitle);
    }

    @Override
    public String toString(){
        return String.format("Module ID: %d\nModule Code: %s\nTitle: %s", this.moduleId,this.moduleCode, this.moduleTitle);
    }
}
