package com.appcnd.common.cms.starter.service.impl;

import com.alibaba.fastjson.JSON;
import com.appcnd.common.cms.entity.constant.ObjectStorageType;
import com.appcnd.common.cms.starter.pojo.HttpResult;
import com.appcnd.common.cms.starter.pojo.vo.UeditorImage;
import com.appcnd.common.cms.starter.pojo.vo.UeditorVideo;
import com.appcnd.common.cms.starter.properties.HuaweiProperties;
import com.appcnd.common.cms.starter.service.IUploadService;
import com.cloud.sdk.DefaultRequest;
import com.cloud.sdk.Request;
import com.cloud.sdk.auth.credentials.BasicCredentials;
import com.cloud.sdk.auth.signer.Signer;
import com.cloud.sdk.auth.signer.SignerFactory;
import com.cloud.sdk.http.HttpMethodName;
import com.obs.services.ObsClient;
import com.obs.services.model.PutObjectResult;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.ssl.AllowAllHostnameVerifier;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLContexts;
import org.apache.http.conn.ssl.TrustSelfSignedStrategy;
import org.apache.http.entity.InputStreamEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import javax.net.ssl.SSLContext;
import java.io.ByteArrayInputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

/**
 * created by nihao 2021/01/27
 */
@Slf4j
public class HwUploadServiceImpl extends IUploadService {
    @Autowired
    private HuaweiProperties huaweiProperties;

    private int durationSeconds = 3600;
    private Map<String,String> defaultHeaders;
    private String tokenContent = "{" +
            "	\"auth\":{" +
            "		\"identity\":{" +
            "			\"methods\":[\"token\"],\"token\": {\n" +
            "                \"duration-seconds\": \"" + durationSeconds + "\"\n" +
            "            }" +
            "		}" +
            "	}" +
            "}";

    @PostConstruct
    public void init() {
        this.defaultHeaders= new HashMap<>();
        this.defaultHeaders.put("Content-Type","application/json");
    }

    ObsClient obsClient;
    private ObsClient getObsClient() {
        if (obsClient == null) {
            synchronized (this) {
                if (obsClient == null) {
                    obsClient = new ObsClient(huaweiProperties.getAk(), huaweiProperties.getSk(),
                            "https://obs." + huaweiProperties.getRegion() + ".myhuaweicloud.com");
                }
            }
        }
        return obsClient;
    }

    @Override
    public HttpResult token(String fileName, String type) {
        String saveKey = getFileName(fileName, type);
        CloseableHttpClient httpClient = null;
        CloseableHttpResponse response = null;
        HttpEntity httpEntity = null;
        try {
            String urlStr = "https://iam." + huaweiProperties.getRegion() + ".myhuaweicloud.com/v3.0/OS-CREDENTIAL/securitytokens";
            URL url = new URL(urlStr);
            Request request = new DefaultRequest();
            request.setEndpoint(url.toURI());
            request.setHttpMethod(HttpMethodName.POST);
            request.setHeaders(defaultHeaders);
            request.setContent(new ByteArrayInputStream(tokenContent.getBytes()));
            Signer signer = SignerFactory.getSigner();
            signer.sign(request, new BasicCredentials(huaweiProperties.getAk(), huaweiProperties.getSk()));

            HttpPost httpPost = new HttpPost(url.toString());
            InputStreamEntity entity = new InputStreamEntity(request.getContent());
            httpPost.setEntity(entity);
            Map<String, String> requestHeaders = request.getHeaders();
            for (String key : requestHeaders.keySet()) {
                httpPost.addHeader(key, requestHeaders.get(key));
            }

            SSLContext sslContext = SSLContexts.custom()
                    .loadTrustMaterial(null, new TrustSelfSignedStrategy())
                    .useTLS().build();
            SSLConnectionSocketFactory sslSocketFactory = new SSLConnectionSocketFactory(
                    sslContext, new AllowAllHostnameVerifier());

            httpClient = HttpClients.custom().setSSLSocketFactory(sslSocketFactory).build();
            response = httpClient.execute(httpPost);
            if (response.getStatusLine().getStatusCode() < 200
                    || response.getStatusLine().getStatusCode() > 300) {
                throw new RuntimeException(response.getStatusLine().toString());
            }
            httpEntity = response.getEntity();
            String resultStr = EntityUtils.toString(httpEntity, "utf-8");
            TokenResult tokenResult = JSON.parseObject(resultStr, TokenResult.class);
            Credential credential = tokenResult.getCredential();
            return HttpResult.success().pull("access", credential.getAccess())
                    .pull("secret", credential.getSecret())
                    .pull("endpoint", "https://obs." + huaweiProperties.getRegion() + ".myhuaweicloud.com")
                    .pull("bucket", huaweiProperties.getBucket())
                    .pull("host", huaweiProperties.getHost())
                    .pull("token", credential.getSecuritytoken())
                    .pull("key", saveKey)
                    .pull("provider", ObjectStorageType.HW.name());
        } catch (RuntimeException e) {
            log.error("{}", e);
            return HttpResult.fail(e.getMessage());
        } catch (Exception e) {
            log.error("{}", e);
            return HttpResult.fail("服务异常");
        } finally {
            if (httpEntity != null) {
                try {
                    EntityUtils.consume(httpEntity);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            if (response != null) {
                try {
                    response.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            if (httpClient != null) {
                try {
                    httpClient.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    public UeditorImage uploadImage(MultipartFile file, String fileName) {
        UeditorImage ueditorImage = new UeditorImage();
        try {
            String saveKey = getFileName(fileName, "image");
            PutObjectResult putObjectResult = getObsClient().putObject(huaweiProperties.getBucket(), saveKey, file.getInputStream());
            if (putObjectResult.getObjectKey() != null) {
                ueditorImage.setState("SUCCESS");
                ueditorImage.setUrl(huaweiProperties.getHost() + "/" + putObjectResult.getObjectKey());
                ueditorImage.setTitle(fileName);
            } else {
                log.warn("华为云上传响应", putObjectResult.toString());
                ueditorImage.setState("FAIL");
            }
        } catch (Exception e) {
            log.error("华为云上传异常", e);
            ueditorImage.setState("FAIL");
        }
        return ueditorImage;
    }

    @Override
    public UeditorVideo uploadVideo(MultipartFile file, String fileName) {
        UeditorVideo ueditorVideo = new UeditorVideo();
        try {
            String saveKey = getFileName(fileName, "video");
            PutObjectResult putObjectResult = getObsClient().putObject(huaweiProperties.getBucket(), saveKey, file.getInputStream());
            if (putObjectResult.getObjectKey() != null) {
                ueditorVideo.setState("SUCCESS");
                ueditorVideo.setUrl(huaweiProperties.getHost() + "/" + saveKey);
                ueditorVideo.setOriginal(fileName);
            } else {
                log.warn("华为云上传响应", putObjectResult.toString());
                ueditorVideo.setState("FAIL");
            }
        } catch (Exception e) {
            log.error("华为云上传异常", e);
            ueditorVideo.setState("FAIL");
        }
        return ueditorVideo;
    }

    @Data
    public static class TokenResult{
        private Credential credential;
    }

    @Data
    public static class Credential{
        private String access;
        private String secret;
        private String securitytoken;
        private String expires_at;
    }
}
