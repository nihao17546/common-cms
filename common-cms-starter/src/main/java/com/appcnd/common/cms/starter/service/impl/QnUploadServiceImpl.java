package com.appcnd.common.cms.starter.service.impl;

import com.appcnd.common.cms.entity.constant.ObjectStorageType;
import com.appcnd.common.cms.starter.pojo.HttpResult;
import com.appcnd.common.cms.starter.pojo.vo.UeditorImage;
import com.appcnd.common.cms.starter.pojo.vo.UeditorVideo;
import com.appcnd.common.cms.starter.properties.QiniuProperties;
import com.appcnd.common.cms.starter.service.IUploadService;
import com.qiniu.common.Zone;
import com.qiniu.http.Response;
import com.qiniu.storage.Configuration;
import com.qiniu.storage.UploadManager;
import com.qiniu.util.Auth;
import com.qiniu.util.StringMap;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;

/**
 * created by nihao 2021/01/27
 */
@Slf4j
public class QnUploadServiceImpl extends IUploadService {
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

    @Override
    public HttpResult token(String fileName, String type) {
        String saveKey = getFileName(fileName, type);
        String token = getAuth().uploadToken(qiniuProperties.getBucket(), null, 3600, new StringMap().putNotEmpty("saveKey", saveKey));
        return HttpResult.success().pull("token", token).pull("host", qiniuProperties.getHost())
                .pull("key", saveKey).pull("provider", ObjectStorageType.QN.name());
    }

    @Override
    public UeditorImage uploadImage(MultipartFile file, String fileName) {
        UeditorImage ueditorImage = new UeditorImage();
        try {
            String saveKey = getFileName(fileName, "image");
            String token = getAuth().uploadToken(qiniuProperties.getBucket());
            Configuration cfg = new Configuration(Zone.autoZone());
            UploadManager uploadManager = new UploadManager(cfg);
            Response response = uploadManager.put(file.getBytes(), saveKey, token);
            if (!response.isOK()) {
                log.error("七牛云上传异常, {}", response.error);
                ueditorImage.setState("FAIL");
            } else {
                ueditorImage.setState("SUCCESS");
                ueditorImage.setUrl(qiniuProperties.getHost() + "/" + saveKey);
                ueditorImage.setTitle(fileName);
            }
        } catch (Exception e) {
            log.error("七牛云上传异常", e);
            ueditorImage.setState("FAIL");
        }
        return ueditorImage;
    }

    @Override
    public UeditorVideo uploadVideo(MultipartFile file, String fileName) {
        UeditorVideo ueditorVideo = new UeditorVideo();
        try {
            String saveKey = getFileName(fileName, "video");
            String token = getAuth().uploadToken(qiniuProperties.getBucket());
            Configuration cfg = new Configuration(Zone.autoZone());
            UploadManager uploadManager = new UploadManager(cfg);
            Response response = uploadManager.put(file.getBytes(), saveKey, token);
            if (!response.isOK()) {
                log.error("七牛云上传异常, {}", response.error);
                ueditorVideo.setState("FAIL");
            } else {
                ueditorVideo.setState("SUCCESS");
                ueditorVideo.setUrl(qiniuProperties.getHost() + "/" + saveKey);
                ueditorVideo.setOriginal(fileName);
            }
        } catch (Exception e) {
            log.error("七牛云上传异常", e);
            ueditorVideo.setState("FAIL");
        }
        return ueditorVideo;
    }
}
