package com.appcnd.common.cms.starter.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.appcnd.common.cms.entity.constant.ObjectStorageType;
import com.appcnd.common.cms.starter.pojo.constant.BasicConstant;
import com.appcnd.common.cms.starter.pojo.vo.UeditorImage;
import com.appcnd.common.cms.starter.pojo.vo.UeditorVideo;
import com.appcnd.common.cms.starter.service.IUploadService;
import com.appcnd.common.cms.starter.util.CommonUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

/**
 * created by nihao 2020/1/13
 */
@Slf4j
@RequestMapping("/upload/api")
public class UploadController extends BaseController {
    @Autowired
    @Qualifier(BasicConstant.beanNamePrefix + "hwUploadService")
    private IUploadService hwUploadService;

    @Autowired
    @Qualifier(BasicConstant.beanNamePrefix + "qnUploadService")
    private IUploadService qnUploadService;

    private IUploadService getUploadService() throws UnsupportedEncodingException {
        String storage = null;
        String key = CommonUtils.getCookieValue(BasicConstant.configKey);
        if (key != null) {
            key = URLDecoder.decode(key, "UTF-8");
            JSONObject jsonObject = JSON.parseObject(key);
            storage = jsonObject.getString("storage");
        }
        if (ObjectStorageType.HW.name().equals(storage)) {
            return hwUploadService;
        }
        return qnUploadService;
    }

    @RequestMapping(value = "/token", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public String token(@RequestParam(value = "file_name") String fileName,
                        @RequestParam String type) throws UnsupportedEncodingException {
        IUploadService uploadService = getUploadService();
        return uploadService.token(fileName, type).json();
    }

    @PostMapping(value = "/image", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public UeditorImage uploadPic(@RequestParam(value = "upfile") MultipartFile file) throws UnsupportedEncodingException {
        IUploadService uploadService = getUploadService();
        return uploadService.uploadImage(file, file.getOriginalFilename());
    }

    @PostMapping(value = "/video", produces = "application/json;charset=UTF-8")
    @ResponseBody
    public UeditorVideo uploadVideo(@RequestParam(value = "upfile") MultipartFile file) throws UnsupportedEncodingException {
        IUploadService uploadService = getUploadService();
        return uploadService.uploadVideo(file, file.getOriginalFilename());
    }

}
