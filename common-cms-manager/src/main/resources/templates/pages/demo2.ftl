<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>文档</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <link rel="stylesheet" href="${contextPath}/jcrop/jquery.Jcrop.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
    <script src="${contextPath}/jcrop/jquery.Jcrop.min.js"></script>
    <style>
    </style>
</head>
<body>

<div id="app">
    <img @click="showImg(\'' + element.key + '\')" style="width: 90%" :src="addForm.' + element.key + '"/>
</div>

<script>
    new Vue({
        name: 'demo',
        el: '#app',
        data() {
            return {
            }
        },
        methods: {

        },
        mounted() {

        },
        created() {
        }
    })
</script>
</body>
</html>