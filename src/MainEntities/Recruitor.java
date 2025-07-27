package MainEntities;

public class Recruitor {
    private int userId;
    private int recruitorId;
    private int companyId;

    public Recruitor(int userId, int recruitorId, int companyId) {
        this.userId = userId;
        this.recruitorId = recruitorId;
        this.companyId = companyId;
    }

    public int getUserId() {
        return userId;
    }

    public int getRecruitorId() {
        return recruitorId;
    }

    public int getCompanyId() {
        return companyId;
    }
}
