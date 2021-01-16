public class Profile {
    private History history = new History();
    private double rating;
    private String biography;
    private String nickname;
    int year;

    public Profile(double rating, String biography, String nickname, int year) {
        this.rating = rating;
        this.biography = biography;
        this.nickname = nickname;
        this.year = year;
    }

    double getRating() {
        return rating;
    }

    History getHistory() {
        return history;
    }

    String getNickname() {
        return nickname;
    }

    String getBiography() {
        return biography;
    }

    public int getYear() {
        return year;
    }

    public void updateNickname(String nickname) {
        this.nickname = nickname;
    }

    public void updateBiography(String biography) {
        this.biography = biography;
    }

    public void addToHistory(StudySession ss) {
        history.addToHistory(ss);
    }

}
