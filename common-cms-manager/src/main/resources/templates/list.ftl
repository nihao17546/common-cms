<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>配置列表</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
    <style>
        * {
            margin:0;
            padding:0;
        }
        #app {
            position:absolute;
            top:0;
            bottom:0;
            left:0;
            right: 0;
        }
    </style>
</head>
<body>
<div id="app">
    <div style="position: absolute; left: 10%; top: 10%;width: 80%;">
        <el-button type="primary" size="mini" @click="add" style="margin-bottom: 8px;">新增</el-button>
        <el-table
                :data="tableData"
                border
                style="width: 100%">
            <el-table-column
                    prop="id"
                    label="ID">
            </el-table-column>
            <el-table-column
                    prop="name"
                    label="配置">
            </el-table-column>
            <el-table-column
                    prop="created_at"
                    label="创建时间">
            </el-table-column>
            <el-table-column
                    prop="updated_at"
                    label="更新时间">
            </el-table-column>
            <el-table-column
                    fixed="right"
                    label="操作"
                    width="250">
                <template slot-scope="props">
                    <el-button-group>
                        <el-button type="success" size="mini">预览</el-button>
                        <el-button type="info" size="mini" @click="showJson(props.row)">查看</el-button>
                        <el-button type="primary" size="mini" @click="edit(props.row)">编辑</el-button>
                        <el-button type="danger" size="mini" @click="del(props.row.id)">删除</el-button>
                    </el-button-group>
                </template>
            </el-table-column>
        </el-table>
    </div>
    <iframe src="${contextPath}/pages/${random}.html" style="border: 0;margin: 0px;padding: 0px;width: 100%;height: 100%;"></iframe>

    <el-dialog
            title="JSON"
            :visible.sync="jsonDialog.visible"
            width="70%"
            :before-close="closeJson">
        <el-input :readonly="true" :autosize="true"
                type="textarea"
                placeholder=""
                v-model="jsonDialog.data">
        </el-input>
        <span slot="footer" class="dialog-footer">
            <el-button @click="closeJson">关闭</el-button>
        </span>
    </el-dialog>
</div>
<script>
    window.contextPath = '${contextPath}'
    window.vue = new Vue({
        name: 'list',
        el: '#app',
        data() {
            return {
                loading: false,
                tableData: [],
                jsonDialog: {
                    visible: false
                }
            }
        },
        methods: {
            del(id) {
                this.$confirm('确定要删除?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    this.loading = true;
                    axios.get(window.contextPath + '/api/delete',{
                        params: {
                            id: id
                        }
                    }).then(res => {
                        if (res.data.status != 0) {
                            this.$message.error(res.data.msg);
                            this.loading = false;
                        }
                        else {
                            this.loading = false;
                            this.getList();
                        }
                    }).catch(res => {
                        console.error(res)
                        this.loading = false;
                    })
                }).catch(() => {
                });
            },
            add() {
                window.location.href = window.contextPath + '/main.html'
            },
            edit(row) {
                window.location.href = window.contextPath + '/main.html?id=' + row.id
            },
            closeJson() {
                this.jsonDialog = {
                    visible: false
                }
            },
            showJson(row) {
                this.jsonDialog = {
                    visible: true,
                    data: row.config
                }
            },
            getList() {
                this.tableData = []
                axios.post(window.contextPath + '/api/getConfigs', {}, {
                    headers: {}
                }).then(res => {
                    if (res.data.status != 0) {
                        this.$message.error(res.data.msg);
                    }
                    else {
                        this.tableData = res.data.content.list;
                    }
                    this.loading = false;
                }).catch(res => {
                    console.error(res)
                    this.loading = false;
                })
            }
        },
        created: function () {
            this.getList()
        }
    })
</script>
</body>
</html>