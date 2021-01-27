package com.appcnd.common.cms.starter.service;

import com.appcnd.common.cms.starter.pojo.HttpResult;
import com.appcnd.common.cms.starter.pojo.vo.UeditorImage;
import com.appcnd.common.cms.starter.pojo.vo.UeditorVideo;
import org.springframework.web.multipart.MultipartFile;

import java.util.UUID;

/**
 * created by nihao 2021/01/27
 */
public abstract class IUploadService extends BaseService {
    public abstract HttpResult token(String fileName, String type);
    public abstract UeditorImage uploadImage(MultipartFile file, String fileName);
    public abstract UeditorVideo uploadVideo(MultipartFile file, String fileName);

    protected String getFileName(String string, String type) {
        String fileName = "codeless/" + type + "/" + UUID.randomUUID().toString().replaceAll("-","");
        if (string != null) {
            if (string.contains(".")) {
                fileName = fileName + string.substring(string.lastIndexOf("."));
            } else {
                fileName = fileName + string;
            }
        }
        return fileName;
    }
}
