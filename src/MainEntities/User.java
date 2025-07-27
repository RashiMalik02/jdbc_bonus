package MainEntities;

import java.sql.Date;

public class User {
    private int userId;
    private String name;
    private String email;
    private String gender;
    private String phoneNo;
    private Date dateOfBirth;
    private String password;

    public User(int userId, String name , String email, String gender, String phoneNo, Date dateOfBirth, String password) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.gender = gender;
        this.phoneNo = phoneNo;
        this.dateOfBirth = dateOfBirth;
        this.password = password;
    }

    public int getUserId() {
        return userId;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getGender() {
        return gender;
    }

    public String getPhoneNo() {
        return phoneNo;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public String getPassword() {
        return password;
    }
}
