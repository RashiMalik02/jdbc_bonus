package MainEntities;

import java.sql.Timestamp;

public class Application {
    private int applicationId;
    private int candidateId;
    private int jobId;
    private Timestamp appliedAt;
    private int currentStageId;

    public Application(int applicationId, int candidateId, int jobId, Timestamp appliedAt, int currentStageId) {
        this.applicationId = applicationId;
        this.candidateId = candidateId;
        this.jobId = jobId;
        this.appliedAt = appliedAt;
        this.currentStageId = currentStageId;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public int getCandidateId() {
        return candidateId;
    }

    public int getJobId() {
        return jobId;
    }

    public Timestamp getAppliedAt() {
        return appliedAt;
    }

    public int getCurrentStageId() {
        return currentStageId;
    }
}
