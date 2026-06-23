package model;

import java.io.Serializable;

public class User implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private int userId;
    private String fullName;
    private String matricNo;
    private String email;
    private String password;
    private String role;
    private String status;

    // Default constructor
    public User() {
        this.status = "active";
    }

    // Parameterized constructor
    public User(String fullName, String matricNo, String email, String password, String role) {
        this.fullName = fullName;
        this.matricNo = matricNo;
        this.email = email;
        this.password = password;
        this.role = role;
        this.status = "active";
    }

    // Getters and Setters
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getMatricNo() {
        return matricNo;
    }

    public void setMatricNo(String matricNo) {
        this.matricNo = matricNo;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}