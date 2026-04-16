package com.voiceless.model;

public class GenericUserModel extends UserModel {
    private int reputationScore;

    public GenericUserModel() {
        super();
        this.role = "USER";
    }

    public GenericUserModel(int id, String name, String email, int reputationScore) {
        // Calls the parent constructor
        super(id, name, email, "USER");
        this.reputationScore = reputationScore;
    }

    // Getters and Setters specific to Generic User
    public int getReputationScore() { return reputationScore; }
    public void setReputationScore(int reputationScore) { this.reputationScore = reputationScore; }
}