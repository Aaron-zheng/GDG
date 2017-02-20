package com.sightcorner.gdg.vo;

import java.util.List;

/**
 * Created by zhengfucheng on 20/2/2017.
 */

public class GDGCountry {
    private String countryName;
    private String countryID;
    private List<GDGChapter> chapters;

    public String getCountryName() {
        return this.countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public List<GDGChapter> getChapters() {
        return this.chapters;
    }

    public void setChapters(List<GDGChapter> chapters) {
        this.chapters = chapters;
    }

    public String getCountryID() {
        return this.countryID;
    }

    public void setCountryID(String countryID) {
        this.countryID = countryID;
    }
}
