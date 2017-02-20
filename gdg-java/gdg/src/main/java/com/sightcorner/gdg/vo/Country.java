package com.sightcorner.gdg.vo;

/**
 * Created by zhengfucheng on 20/2/2017.
 */
public class Country {
    private String countryName;
    private String countryID;

    public String getCountryName() {
        return this.countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getCountryID() {
        return this.countryID;
    }

    public void setCountryID(String countryID) {
        this.countryID = countryID;
    }

    public int hashCode() {
        int prime = 31;
        int result = 1;
        result = 31 * result + (
                this.countryName == null ? 0 : this.countryName.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        Country other = (Country) obj;
        if (this.countryName == null) {
            if (other.countryName != null) {
                return false;
            }
        } else if (!this.countryName.equals(other.countryName)) {
            return false;
        }
        return true;
    }
}
