package com.sightcorner.gdg.local;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.net.URL;
import java.nio.file.CopyOption;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.imageio.ImageIO;

import com.sightcorner.gdg.util.GDGUtil;
import com.sightcorner.gdg.vo.Country;
import com.sightcorner.gdg.vo.GDGChapter;
import com.sightcorner.gdg.vo.GDGCountry;
import com.sightcorner.gdg.vo.GDGEvent;
import org.apache.commons.io.FileUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;

/**
 * Created by zhengfucheng on 20/2/2017.
 */
public class ParseChapters {
    public static final String PRE_FILE_PATH = "/Users/zhengfucheng/Documents/workspace/sightcorner_image/staging/gdg/";
    private static List<GDGCountry> countryList;
    private static Map<String, String> firstEventMap = new HashMap();

    public static void main(String[] args) {
        String content = GDGUtil.requestGDGHub();
        content = content.replace("+GdgmaduraiBlogspotOfficial", "104331065705906191744");
        JSONObject jsonObject = new JSONObject(content);
        JSONArray jsonArray = (JSONArray) jsonObject.get("items");

        initialCountryList(jsonArray);
        outputEvent(jsonArray);
        outputChapters(jsonArray, "/event/chapters.xml");
    }


    private static void outputEvent(JSONArray jsonArray) {
        for (GDGCountry country : countryList) {
            List<GDGEvent> list = new ArrayList();
            for (GDGChapter chapter : country.getChapters()) {
                String id = chapter.getId();
                outputChapterEvent(id, list);
            }
            outputCountryEvent(list, country.getCountryID());
        }
    }

    private static void outputCountryEvent(List<GDGEvent> list, String countryID) {
        String filePath = "/Users/zhengfucheng/Documents/workspace/sightcorner_image/staging/gdg/event/" + countryID + ".xml";
        eventSort(list);
        List<GDGEvent> newList = new ArrayList();
        for (int i = 0; i < list.size(); i++) {
            if (i >= 50) {
                break;
            }
            newList.add((GDGEvent) list.get(i));
        }
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.createNewFile();
            }
            String content = parseEvent(newList);
            FileOutputStream out = new FileOutputStream(file, false);
            out.write(content.getBytes("UTF-8"));
            out.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private static void outputChapterEvent(String id, List<GDGEvent> list) {
        String filePath = "/Users/zhengfucheng/Documents/workspace/sightcorner_image/staging/gdg/event/" + id + ".xml";
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.createNewFile();
                String content = parseEvent(id, list);
                FileOutputStream out = new FileOutputStream(file, false);
                out.write(content.getBytes("UTF-8"));
                out.close();
            } else {
                File file2 = new File("/Users/zhengfucheng/Documents/workspace/sightcorner_image/staging/gdg/event/" + id + "new.xml");
                String content = parseEvent(id, list);
                FileOutputStream out = new FileOutputStream(file2, false);
                out.write(content.getBytes("UTF-8"));
                out.close();
                if (FileUtils.contentEquals(file, file2)) {
                    file2.delete();
                } else {
                    Files.move(file2.toPath(), file.toPath(), REPLACE_EXISTING);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private static List<GDGEvent> getEvents(String id) {
        String url = "https://developers.google.com/events/feed/json?group=" + id + "&start=0";
        String content = GDGUtil.request(url);
        JSONArray jsonArray = new JSONArray(content);
        List<GDGEvent> output = new ArrayList();
        for (int j = 0; j < jsonArray.length(); j++) {
            JSONObject json = jsonArray.getJSONObject(j);
            GDGEvent e = new GDGEvent();
            try {
                e.setTitle(json.getString("title"));
            } catch (Exception ex) {
                e.setTitle("");
            }
            try {
                e.setDescription(json.getString("description"));
            } catch (Exception ex) {
                e.setDescription("");
            }
            try {
                e.setStart(json.getString("start"));
            } catch (Exception ex) {
                e.setStart("");
            }
            try {
                e.setEnd(json.getString("end"));
            } catch (Exception ex) {
                e.setEnd("");
            }
            try {
                e.setGroup(json.getString("group"));
            } catch (Exception ex) {
                e.setGroup("");
            }
            try {
                e.setLocation(json.getString("location"));
            } catch (Exception ex) {
                e.setLocation("");
            }
            try {
                int participantsCount = json.getInt("participantsCount");
                e.setParticipantsCount(String.valueOf(participantsCount));
            } catch (Exception ex) {
                e.setParticipantsCount("");
            }
            parseAsPresentation(e);
            output.add(e);
        }
        return output;
    }

    private static void eventSort(List<GDGEvent> output) {
        Collections.sort(output, new Comparator<GDGEvent>() {
            public int compare(GDGEvent o1, GDGEvent o2) {
                if ((o1.getStartDate() == null) || (o2.getStartDate() == null)) {
                    return -1;
                }
                if (o1.getStartDate().before(o2.getStartDate())) {
                    return 1;
                }
                return -1;
            }
        });
    }

    private static int number = 1;

    private static String parseEvent(String id, List<GDGEvent> list) {
        List<GDGEvent> output = getEvents(id);
        list.addAll(output);
        eventSort(output);
        addFirstEvent(output);

        System.out.println(number++ + " id: " + id);
        return parseEvent(output);
    }

    private static void addFirstEvent(List<GDGEvent> output) {
        if ((output != null) && (output.size() > 0)) {
            GDGEvent e = (GDGEvent) output.get(output.size() - 1);
            firstEventMap.put(e.getGroup(), GDGUtil.format2format(e.getStart(), "yyyy.MM.dd HH:mm", "yyyy.MM.dd"));
        }
    }

    private static String parseEvent(List<GDGEvent> output) {
        StringBuffer result = new StringBuffer();

        result.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<data>");
        result.append("\n<number>").append(output.size()).append("</number>");
        result.append("\n<events>");
        for (int i = 0; i < output.size(); i++) {
            result.append("\n\t<event>");
            result.append("<title>").append(xmlUpdate(((GDGEvent) output.get(i)).getTitle())).append("</title>");
            result.append("<chapterid>").append(((GDGEvent) output.get(i)).getGroup()).append("</chapterid>");
            result.append("<description>").append(xmlUpdate(((GDGEvent) output.get(i)).getDescription())).append("</description>");
            result.append("<start>").append(((GDGEvent) output.get(i)).getStart()).append("</start>");
            result.append("<end>").append(((GDGEvent) output.get(i)).getEnd()).append("</end>");
            result.append("<location>").append(xmlUpdate(((GDGEvent) output.get(i)).getLocation())).append("</location>");
            result.append("<participantscount>").append(xmlUpdate(((GDGEvent) output.get(i)).getParticipantsCount())).append("</participantscount>");
            result.append("</event>");
        }
        result.append("\n</events>");
        result.append("\n</data>");
        return result.toString();
    }

    private static String xmlUpdate(String content) {
        content = content.replace("<", "&lt;").replace(">", "&gt;").replace("&", "&amp;").replace("'", "&apos;").replace("\"", "&quot;");
        return content;
    }

    private static void parseAsPresentation(GDGEvent e) {
        try {
            e.setStartDate(new SimpleDateFormat("dd MMM yyyy HH:mm").parse(e.getStart()));
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        String start = GDGUtil.format2format(e.getStart(), "dd MMM yyyy HH:mm", "yyyy.MM.dd HH:mm");
        String start2 = GDGUtil.format2format(e.getStart(), "dd MMM yyyy HH:mm", "yyyy.MM.dd ");
        String end = null;
        if ((start != null) && (start2 != null)) {
            end = GDGUtil.format2format(e.getEnd(), "dd MMM yyyy HH:mm", "yyyy.MM.dd HH:mm").replace(start2, "");
        }
        e.setStart(start);
        e.setEnd(end);
    }

    private static void outputChapters(JSONArray jsonArray, String fileName) {
        try {
            String filePath = "/Users/zhengfucheng/Documents/workspace/sightcorner_image/staging/gdg/" + fileName;
            File file = new File(filePath);
            if (!file.exists()) {
                file.createNewFile();
            }
            String content = parseChapters(jsonArray);
            FileOutputStream out = new FileOutputStream(file, false);
            out.write(content.getBytes("UTF-8"));
            out.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private static String parseChapters(JSONArray jsonArray) {
        StringBuffer result = new StringBuffer();

        result.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<data>");
        for (int i = 0; i < countryList.size(); i++) {
            result.append("\n<country>");
            result.append("\n\t<countryname>").append(((GDGCountry) countryList.get(i)).getCountryName()).append("</countryname>");
            result.append("\n\t<countryid>").append(((GDGCountry) countryList.get(i)).getCountryID()).append("</countryid>");
            result.append("\n\t<number>").append(((GDGCountry) countryList.get(i)).getChapters().size()).append("</number>");
            List<GDGChapter> chapters = ((GDGCountry) countryList.get(i)).getChapters();
            result.append("\n\t<chapters>");
            for (int j = 0; j < chapters.size(); j++) {
                String firsteventdate = (String) firstEventMap.get(((GDGChapter) chapters.get(j)).getId());
                if (firsteventdate == null) {
                    firsteventdate = "";
                }
                result.append("\n\t\t<chapter><chapterid>").append(((GDGChapter) chapters.get(j)).getId()).append("</chapterid>").append("<city>").append(((GDGChapter) chapters.get(j)).getCity()).append("</city>").append("<chaptername>").append(((GDGChapter) chapters.get(j)).getName().replace("&", "&amp;")).append("</chaptername>").append("<firsteventdate>").append(firsteventdate).append("</firsteventdate>").append("</chapter>");
            }
            result.append("\n\t</chapters>");
            result.append("\n</country>");
        }
        result.append("\n</data>");
        return result.toString();
    }

    private static void initialCountryList(JSONArray jsonArray) {
        List<Country> countries = getCountries(jsonArray);
        List<GDGCountry> list = new ArrayList();
        for (int i = 0; i < countries.size(); i++) {
            GDGCountry g = new GDGCountry();
            g.setCountryName(((Country) countries.get(i)).getCountryName());
            g.setCountryID(((Country) countries.get(i)).getCountryID());
            g.setChapters(new ArrayList());
            list.add(g);
        }
        for (int i = 0; i < jsonArray.length(); i++) {
            if (!jsonArray.getJSONObject(i).isNull("country")) {
                String countryName = (String) jsonArray.getJSONObject(i).getJSONObject("country").get("name");
                for (int j = 0; j < list.size(); j++) {
                    if (countryName.equals(((GDGCountry) list.get(j)).getCountryName())) {
                        GDGChapter g = new GDGChapter();
                        g.setCountry(countryName);
                        g.setCity(((String) jsonArray.getJSONObject(i).get("city")).trim());
                        g.setId(((String) jsonArray.getJSONObject(i).get("_id")).trim());
                        g.setName(((String) jsonArray.getJSONObject(i).get("name")).replace("GDG", "").trim());
                        ((GDGCountry) list.get(j)).getChapters().add(g);
                        break;
                    }
                }
            }
        }
        for (int j = 0; j < list.size(); j++) {
            Collections.sort(((GDGCountry) list.get(j)).getChapters(), new Comparator<GDGChapter>() {
                public int compare(GDGChapter o1, GDGChapter o2) {
                    return o1.getName().compareTo(o2.getName());
                }
            });
        }
        countryList = list;
    }

    private static List<Country> getCountries(JSONArray jsonArray) {
        Set<Country> countries = new HashSet();
        Country c;
        for (int i = 0; i < jsonArray.length(); i++) {
            try {
                JSONObject json = jsonArray.getJSONObject(i).getJSONObject("country");
                c = new Country();
                c.setCountryID((String) json.get("_id"));
                c.setCountryName((String) json.get("name"));
                countries.add(c);
            } catch (JSONException localJSONException) {
            }
        }
        List<Country> list = new ArrayList();
        for (Country s : countries) {
            list.add(s);
        }
        Collections.sort(list, new Comparator<Country>() {
            public int compare(Country o1, Country o2) {
                return o1.getCountryName().compareTo(o2.getCountryName());
            }
        });
        return list;
    }
}
