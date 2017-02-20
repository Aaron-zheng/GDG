package com.sightcorner.gdg.local;

import com.sightcorner.gdg.util.GDGUtil;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.net.URL;

/**
 * Created by zhengfucheng on 20/2/2017.
 */
public class InitialChapters {


    private static void outputImage(JSONArray jsonArray) {
        String filePath = "/Users/zhengfucheng/Documents/workspace/sightcorner_image/staging/gdg/avatar/avatar.txt";
        File file = new File(filePath);
        try {
            if (!file.exists()) {
                file.createNewFile();
            }
            String content = parseImage(jsonArray);
            FileOutputStream out = new FileOutputStream(file, false);
            out.write(content.getBytes("UTF-8"));
            out.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private static String parseImage(JSONArray jsonArray) {
        StringBuffer result = new StringBuffer();
        for (int i = 0; i < jsonArray.length(); i++) {
            String id = (String) jsonArray.getJSONObject(i).get("_id");
            String url = "https://www.googleapis.com/plus/v1/people/" + id + "?fields=image&key=AIzaSyD7v04m_bTu-rcWtuaN3fTP9NBmjhB7lXg";
            String content = GDGUtil.request(url);
            if ((content == null) || (content.length() <= 0)) {
                System.out.println("no data found: " + id);
            } else {
                JSONObject json = new JSONObject(content);
                result.append(id + ": " + json.getJSONObject("image").get("url")).append("\n");
                String imageURL = ((String) json.getJSONObject("image").get("url")).replace("?sz=50", "");
                System.out.println("id: " + id);
                String filePath = "/Users/zhengfucheng/Documents/workspace/sightcorner_image/staging/gdg/avatar/" + id + ".jpg";
                File file = new File(filePath);
                try {
                    URL u = new URL(imageURL);
                    BufferedImage bi = ImageIO.read(u);
                    ImageIO.write(bi, "PNG", file);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }
        return result.toString();
    }

}
