package com.sightcorner.gdg.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by zhengfucheng on 20/2/2017.
 */

public class GDGUtil {

    public static String format2format(String time, String fromFormat, String toFormat) {
        String result = date2TimeStamp(time, fromFormat);
        result = timeStamp2Date(result, toFormat);
        return result;
    }

    public static String timeStamp2Date(String seconds, String format) {
        if ((seconds == null) || (seconds.isEmpty()) || (seconds.equals("null"))) {
            return "";
        }
        if ((format == null) || (format.isEmpty())) {
            format = "yyyy-MM-dd HH:mm:ss";
        }
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(new Date(Long.valueOf(seconds + "000").longValue()));
    }

    public static String date2TimeStamp(String date_str, String format) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            return String.valueOf(sdf.parse(date_str).getTime() / 1000L);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    public static String request(String urlInput) {
        StringBuffer output = new StringBuffer();
        try {
            URL url = new URL(urlInput);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String temp;
            while ((temp = br.readLine()) != null) {
                output.append(temp);
            }
            br.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return output.toString();
    }

    public static String requestGDGHub() {
        StringBuffer output = new StringBuffer();
        try {
            BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(new File("/Users/zhengfucheng/Downloads/Google/GDG_resource/gdghub.json"))));
            String temp;
            while ((temp = br.readLine()) != null) {
                output.append(temp);
            }
            br.close();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return output.toString();
    }
}
