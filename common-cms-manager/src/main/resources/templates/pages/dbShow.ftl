<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>dbShow</title>
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
    <el-row :gutter="24">
        <el-col :span="8">
            <el-card class="box-card">
                <div slot="header">
                    <span>主表 - {{mainDb.schema}}.{{mainDb.table}}</span>
                    <el-table
                            :data="mainDb.columns"
                            border
                            style="width: 100%">
                        <el-table-column
                                prop="name"
                                label="字段">
                        </el-table-column>
                        <el-table-column
                                prop="type"
                                label="类型">
                        </el-table-column>
                    </el-table>
                </div>
            </el-card>
        </el-col>
        <el-col :span="8" v-for="(item, index) in oneToOnes">
            <el-card class="box-card">
                <div slot="header">
                    <span>一对一从表 - {{item.schema}}.{{item.table}}</span>
                    <el-table
                            :data="item.columns"
                            border
                            style="width: 100%">
                        <el-table-column
                                prop="name"
                                label="字段">
                        </el-table-column>
                        <el-table-column
                                prop="type"
                                label="类型">
                        </el-table-column>
                    </el-table>
                </div>
            </el-card>
        </el-col>
        <el-col :span="8" v-for="(item, index) in oneToMores">
            <el-card class="box-card">
                <div slot="header">
                    <span>一对多从表 - {{item.schema}}.{{item.table}}</span>
                    <el-table
                            :data="item.columns"
                            border
                            style="width: 100%">
                        <el-table-column
                                prop="name"
                                label="字段">
                        </el-table-column>
                        <el-table-column
                                prop="type"
                                label="类型">
                        </el-table-column>
                    </el-table>
                </div>
            </el-card>
        </el-col>
    </el-row>
</div>
</body>
<script>
    window.contextPath = '${contextPath}'
</script>
<script>
    window.setInterval(() => {
        window.parent.document.getElementById("dbShow").height = document.getElementById("app").offsetHeight + 15
    }, 200)

    window.vue = new Vue({
        name: 'dbShow',
        el: '#app',
        data() {
            return {
                loading: false,
                height: window.innerHeight - 78,
                formLabelWidth: '150px',
                mainDb: {},
                oneToOnes: [],
                oneToMores: []
            }
        },
        watch: {
        },
        methods: {
            init(mainDb, oneToOnes, oneToMores) {
                this.mainDb = mainDb
                this.oneToOnes = oneToOnes
                this.oneToMores = oneToMores
            }
        },
        created: function () {
        }
    })
</script>
</html>