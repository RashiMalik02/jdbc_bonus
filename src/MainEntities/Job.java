package MainEntities;

import java.sql.Timestamp;

public class Job {
    private int jobId;
    private String title;
    private int companyDeptId;
    private String description;
    private int totalApplications;
    private int postedBy;
    private String status;
    private Timestamp createdAt;

    public Job(int jobId, String title, int companyDeptId, String description, int totalApplications, int postedBy, String status, Timestamp createdAt) {
        this.jobId = jobId;
        this.title = title;
        this.companyDeptId = companyDeptId;
        this.description = description;
        this.totalApplications = totalApplications;
        this.postedBy = postedBy;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getJobId() {
        return jobId;
    }

    public String getTitle() {
        return title;
    }

    public int getCompanyDeptId() {
        return companyDeptId;
    }

    public String getDescription() {
        return description;
    }

    public int getTotalApplications() {
        return totalApplications;
    }

    public int getPostedBy() {
        return postedBy;
    }

    public String getStatus() {
        return status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
}
