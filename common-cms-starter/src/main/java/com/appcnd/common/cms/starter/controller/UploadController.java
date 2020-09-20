package com.appcnd.common.cms.starter.controller;

import com.appcnd.common.cms.starter.properties.QiniuProperties;
import com.qiniu.common.Zone;
import com.qiniu.http.Response;
import com.qiniu.storage.Configuration;
import com.qiniu.storage.UploadManager;
import com.qiniu.util.Auth;
import com.qiniu.util.StringMap;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.apache.tomcat.util.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

/**
 * created by nihao 2020/1/13
 */
@Slf4j
@RequestMapping("/upload/api")
public class UploadController extends BaseController {

    @Autowired
    private QiniuProperties qiniuProperties;

    private Auth auth;

    private Auth getAuth() {
        if (auth == null) {
            synchronized (this) {
                if (auth == null) {
                    auth = Auth.create(qiniuProperties.getAk(), qiniuProperties.getSk());
                }
            }
        }
        return auth;
    }

    @RequestMapping(value = "/token", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String token(@RequestParam(value = "file_name") String fileName,
                        @RequestParam String type) {
        String saveKey = getFileName(fileName, type);
        String token = getAuth().uploadToken(qiniuProperties.getBucket(), null, 3600, new StringMap().putNotEmpty("saveKey", saveKey));
        return ok().pull("token", token).pull("host", qiniuProperties.getHost()).pull("key", saveKey).json();
    }

    private String getFileName(String string, String type) {
        String fileName = "common-cms/" + type + "/" + UUID.randomUUID().toString().replaceAll("-","");
        if (string != null) {
            if (string.contains(".")) {
                fileName = fileName + string.substring(string.lastIndexOf("."));
            } else {
                fileName = fileName + string;
            }
        }
        return fileName;
    }

    @PostMapping(value = "/image")
    @ResponseBody
    public UeditorImage uploadPic(@RequestParam(value = "upfile") MultipartFile file) {
        return uploadImage(file);
    }

    @PostMapping(value = "/scrawl")
    @ResponseBody
    public UeditorImage uploadScrawl(String upfile) {
        String fileName = getFileName("x.jpeg", "image");
        return uploadImage(Base64.decodeBase64(upfile), fileName);
    }

    @PostMapping(value = "/video")
    @ResponseBody
    public UeditorVideo uploadVideo(@RequestParam(value = "upfile") MultipartFile file) {
        return uploadVideo(file, getFileName(file.getOriginalFilename(), "video"));
    }

    private UeditorImage uploadImage(MultipartFile file) {
        String fileName = getFileName(file.getOriginalFilename(), "image");
        try {
            return uploadImage(file.getBytes(), fileName);
        } catch (Exception e) {
            UeditorImage ueditorImage = new UeditorImage();
            log.error("七牛云上传异常", e);
            ueditorImage.setState("FAIL");
            return ueditorImage;
        }
    }

    @Data
    public static class UeditorImage{
        private String state;
        private String url;
        private String title;
        private String original;
    }

    @Data
    public static class UeditorVideo{
        private String state;
        private String url;
        private String type;
        private String original;
    }

    private UeditorImage uploadImage(byte[] data, String fileName) {
        String token = getAuth().uploadToken(qiniuProperties.getBucket());
        Configuration cfg = new Configuration(Zone.autoZone());
        UploadManager uploadManager = new UploadManager(cfg);
        UeditorImage ueditorImage = new UeditorImage();
        try {
            Response response = uploadManager.put(data, fileName, token);
            if (!response.isOK()) {
                log.error("七牛云上传异常, {}", response.error);
                ueditorImage.setState("FAIL");
            } else {
                ueditorImage.setState("SUCCESS");
                ueditorImage.setUrl(qiniuProperties.getHost() + "/" + fileName);
                ueditorImage.setTitle(fileName);
            }
        } catch (IOException e) {
            log.error("七牛云上传异常", e);
            ueditorImage.setState("FAIL");
        }
        return ueditorImage;
    }

    private UeditorVideo uploadVideo(MultipartFile file, String fileName) {
        String token = getAuth().uploadToken(qiniuProperties.getBucket());
        Configuration cfg = new Configuration(Zone.autoZone());
        UploadManager uploadManager = new UploadManager(cfg);
        UeditorVideo ueditorVideo = new UeditorVideo();
        try {
            Response response = uploadManager.put(file.getBytes(), fileName, token);
            if (!response.isOK()) {
                log.error("七牛云上传异常, {}", response.error);
                ueditorVideo.setState("FAIL");
            } else {
                ueditorVideo.setState("SUCCESS");
                ueditorVideo.setUrl(qiniuProperties.getHost() + "/" + fileName);
                ueditorVideo.setOriginal(fileName);
            }
        } catch (IOException e) {
            log.error("七牛云上传异常", e);
            ueditorVideo.setState("FAIL");
        }
        return ueditorVideo;
    }

}
