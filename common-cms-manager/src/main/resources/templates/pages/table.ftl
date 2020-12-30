<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>table页配置</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
    <style>
    </style>
</head>
<body>
<div id="app" v-loading="loading">

</div>
</body>
<script>
    window.contextPath = '${contextPath}'
    window.setInterval(() => {
        window.parent.document.getElementById("table").height = document.getElementById("app").offsetHeight + 15
    }, 200)

    window.vue = new Vue({
        name: 'table',
        el: '#app',
        data() {
            return {
                loading: false,
                height: window.innerHeight - 78,
                formLabelWidth: '150px',
                mainDb: null,
                followDbs: null,
                form: {},
                rules: {}
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