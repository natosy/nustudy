import java.util.Random;

public class Location {
    static Random rngGenerator = new Random(3);
    private final int locationId;
    private final String name;

    private Location(String name) {
        this.name = name;
        this.locationId =  Math.abs(rngGenerator.nextInt());
    }

    static Location create(String name){
        return new Location(name);
    }

    public int getLocationId() {
        return locationId;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString(){
        return String.format("Location ID: %d, Location: %s", this.locationId, this.name);
    }
}
