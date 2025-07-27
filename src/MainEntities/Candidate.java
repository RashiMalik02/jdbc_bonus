package MainEntities;

public class Candidate {
    private int userId;
    private int candidateId;
    private String resumeLinkPath;
    private int experience;
    private String education;
    private String skill;

    public Candidate(int userId, int candidateId, String resumeLinkPath, int experience, String education, String skill) {
        this.userId = userId;
        this.candidateId = candidateId;
        this.resumeLinkPath = resumeLinkPath;
        this.experience = experience;
        this.education = education;
        this.skill = skill;
    }

    public int getCandidateId() {
        return candidateId;
    }

    public String getResumeLinkPath() {
        return resumeLinkPath;
    }

    public int getUserId() {
        return userId;
    }

    public int getExperience() {
        return experience;
    }

    public String getEducation() {
        return education;
    }

    public String getSkill() {
        return skill;
    }
}
