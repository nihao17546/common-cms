<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>preview</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
    <style>
        .competitors .is-leaf {
            padding-top: 3px;
            padding-bottom: 3px;
        }
        .competitors .el-table__row td {
            padding-top: 3px;
            padding-bottom: 3px;
        }
        .el-card__body {
            padding: 5px;
            font-size: 14px;
        }
        .clearfix:before,
        .clearfix:after {
            display: table;
            content: "";
        }
        .clearfix:after {
            clear: both
        }
        .el-card__header {
            padding-top: 0px;
            padding-bottom: 0px;
        }
        #position {
            height: 270px;
            overflow: hidden;
        }
        body .el-table th.gutter{
            display: table-cell!important;
        }
        .line-limit-length {
            /*overflow: hidden;*/
            /*text-overflow: ellipsis;*/
            /*white-space: nowrap; //文本不换行，这样超出一行的部分被截取，显示...*/
        }
        .c-card {
            border-top-color: #dd4b39;
            border-top-width: 3px;
            margin-top: 10px;
        }
        .el_btn {
            color: #fff;
            background-color: #409EFF;
            border: 1px #409EFF solid;
            border-radius: 4px;
            padding-top: 9px;
            padding-bottom: 9px;
            padding-left: 15px;
            padding-right: 15px;
            font-size: 12px;
            font-family: Arial;
            font-weight: 500;
        }
        .follow-dialog .el-dialog__body {
            padding: 2px;
        }
    </style>
</head>
<body style="margin: 0px;">
<div id="app" v-loading="loading">
    <el-row :gutter="24" style="margin-left: -5px; margin-right: -5px;">
        <el-col :span="24" id="search-card">
            <el-card shadow="never" class="c-card" v-if="config.searchElements && config.searchElements.length > 0">
                <div slot="header" style="margin-top: 5px;margin-bottom: 5px;font-size: 18px;">
                    <span>检索条件</span>
                </div>
                <el-form :inline="true">
                    <template v-for="(co,index) in config.searchElements">
                        <el-form-item :label="co.label + ':'" v-if="co.label">
                            <el-input v-if="co.elType == 'INPUT'" type="text" :clearable="co.clearable"
                                      :placeholder="co.placeholder" :size="co.size"></el-input>
                            <el-select v-if="co.elType == 'SELECT'"  :clearable="co.clearable"
                                       :placeholder="co.placeholder" :size="co.size">
                                <el-option v-if="co.options" v-for="(option,aIndex) in co.options" :key="option.value"
                                           :label="option.label" :value="option.value">
                                </el-option>
                            </el-select>
                            <el-date-picker v-if="co.elType == 'DATE_PICKER'"
                                            :placeholder="co.placeholder" :size="co.size"
                                            type="daterange" start-placeholder="开始日期" end-placeholder="结束日期" range-separator="至"
                                            :value-format="co.format" :format="co.format">
                            </el-date-picker>
                            <el-date-picker v-if="co.elType == 'DATETIME_PICKER'"
                                            :placeholder="co.placeholder" :size="co.size"
                                            type="datetimerange" start-placeholder="开始日期" end-placeholder="结束日期" range-separator="至"
                                            :value-format="co.format" :format="co.format">
                            </el-date-picker>
                        </el-form-item>
                    </template>
                    <el-form-item>
                        <el-button size="small" icon="el-icon-search" type="primary">查找</el-button>
                    </el-form-item>
                </el-form>
            </el-card>
        </el-col>
        <el-col :span="24" id="btn-card">
            <el-card shadow="never" class="c-card" v-if="config.add_btn || config.edit_btn || config.delete_btn">
                <el-row :gutter="12">
                    <el-col :span="12">
                        <el-button v-if="config.add_btn" size="small" @click="showAdd" type="info" plain icon="el-icon-plus">新增</el-button>
                        <el-button v-if="config.edit_btn" size="small" @click="showAdd" icon="el-icon-edit">修改</el-button>
                        <el-button v-if="config.delete_btn" size="small" type="danger" icon="el-icon-delete">删除</el-button>
                        <template v-if="config.follow_tables && config.follow_tables.length > 0">
                            <el-button v-for="(followTable,followTableIndex) in config.follow_tables"
                                       size="small" type="info" @click="showFollow">{{followTable.bottomName}}</el-button>
                        </template>
                    </el-col>
                </el-row>
            </el-card>
        </el-col>
        <el-col :span="24" id="table-card">
            <el-card shadow="never" class="c-card" v-if="config.table && config.table.columns && config.table.columns.length > 0">
                <el-table stripe style="width: 100%; margin-top: 3px;">
                    <el-table-column type="selection" width="55"></el-table-column>
                    <template v-for="(co,index) in config.table.columns">
                        <el-table-column v-if="co.label" :prop="co.key" :width="co.width" :sortable="co.sortable" :label="co.label"></el-table-column>
                    </template>
                </el-table>
                <div style="text-align: right;" v-if="config.table.pagination">
                    <el-pagination small background
                               layout="total, sizes, prev, pager, next, jumper"
                               :total="0"
                               :page-size="0"
                               :page-sizes="[10, 20, 50, 100]">
                    </el-pagination>
                </div>'
            </el-card>
        </el-col>
    </el-row>
</div>
<script>
    window.contextPath = '${contextPath}'
    function getParam(name) {
        var reg = new RegExp("[^\?&]?" + encodeURI(name) + "=[^&]+");
        var arr = window.location.search.match(reg);
        if (arr != null) {
            return decodeURI(arr[0].substring(arr[0].search("=") + 1));
        }
        return "";
    }
</script>
<script>
    window.vue = new Vue({
        name: 'preview',
        el: '#app',
        data() {
            return {
                uuid: null,
                loading: false,
                height: window.innerHeight - 78,
                formLabelWidth: '150px',
                config: {
                    table: {
                        columns: []
                    }
                },
                timer: ''
            }
        },
        watch: {
        },
        methods: {
            showFollow() {

            },
            showAdd() {},
            get() {
                let config = localStorage.getItem(this.uuid)
                if (config) {
                    this.config = JSON.parse(config)
                    document.title = this.config.title ? this.config.title : '预览'
                    console.log(JSON.stringify(this.config))
                }
            },
        },
        beforeDestroy() {
            clearInterval(this.timer);
        },
        mounted() {
            this.uuid = getParam('uuid')
            if (!this.uuid) {
                this.$message.error('预览异常');
            }
            this.timer = setInterval(this.get, 100);
        },
        created: function () {
        }
    })
</script>
</body>
</html>