<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>配置</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
    <style>
    </style>
</head>
<body>
<div id="app" v-loading="loading">
    <el-tabs v-model="activeName">
        <el-tab-pane label="数据库配置" name="db">
            <iframe id="database" src="${contextPath}/pages/database.html" frameborder="0" width="100%" :height="height"></iframe>
        </el-tab-pane>
        <el-tab-pane label="页面配置" name="basic" :disabled="!mainDb || !mainDb.schema">
            <iframe id="basic" src="${contextPath}/pages/basic.html" frameborder="0" width="100%"></iframe>
        </el-tab-pane>
    </el-tabs>
</div>
</body>
<script>
    function ScollPostion() { //滚动条位置
        var t, l, w, h;
        if(document.documentElement && document.documentElement.scrollTop) {
            t = document.documentElement.scrollTop;
            l = document.documentElement.scrollLeft;
            w = document.documentElement.scrollWidth;
            h = document.documentElement.scrollHeight;
        } else if(document.body) {
            t = document.body.scrollTop;
            l = document.body.scrollLeft;
            w = document.body.scrollWidth;
            h = document.body.scrollHeight;
        }
        return {
            top: t,
            left: l,
            width: w,
            height: h
        };
    }
    window.contextPath = '${contextPath}'
    window.vue = new Vue({
        name: 'config',
        el: '#app',
        data() {
            return {
                loading: false,
                height: window.innerHeight - 78,
                activeName: 'db',
                mainDb: null,
                followDbs: null
            }
        },
        methods: {
            init(mainDb, followDbs) {
                window.vue.mainDb = mainDb
                window.vue.followDbs = followDbs
            }
        },
        created: function () {

        }
    })
</script>
</html>