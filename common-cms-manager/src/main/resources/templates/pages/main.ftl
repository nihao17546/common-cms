<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>main</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
    <style>
        .box-card {
            margin-top: 3px;
            margin-bottom: 3px;
        }
    </style>
</head>
<body style="margin: 0px;">
<div id="app" v-loading="loading">
    <el-card class="box-card">
        <div slot="header">
            <span>主表配置</span>
        </div>
        <el-row :gutter="24">
            <el-col :span="24"></el-col>
        </el-row>
    </el-card>
</div>
</body>
<script>
    window.contextPath = '${contextPath}'
</script>
<script>
    window.setInterval(() => {
        window.parent.document.getElementById("main").height = document.getElementById("app").offsetHeight + 15
    }, 200)

    window.vue = new Vue({
        name: 'main',
        el: '#app',
        data() {
            return {
                loading: false,
                height: window.innerHeight - 78,
                formLabelWidth: '150px'
            }
        },
        watch: {
        },
        methods: {

        },
        created: function () {
        }
    })
</script>
</html>