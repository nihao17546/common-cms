<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>配置</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
</head>
<body>
<div id="app" v-loading="loading">
    <el-card class="box-card">
        <div slot="header" class="clearfix">
            <span>主表配置</span>
        </div>
        <el-form :model="basic.form" :rules="basic.rules" ref="basicForm" size="small">
            <el-row :gutter="24">
                <el-col :span="10">
                    <el-form-item label="数据库:" prop="schema" :label-width="formLabelWidth">
                        <el-input v-model.trim="basic.form.schema" autocomplete="off" size="small"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="10">
                    <el-form-item label="数据库表:" prop="table" :label-width="formLabelWidth">
                        <el-input v-model.trim="basic.form.table" autocomplete="off" size="small"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="4" style="text-align: center">
                    <el-button type="primary" plain size="mini" @click="getMainTable">校验</el-button>
                </el-col>
            </el-row>
            <el-row :gutter="24" v-if="basic.checked">
                <el-col :span="10">
                    <el-form-item label="主键:" prop="primaryKey" :label-width="formLabelWidth">
                        <el-input v-model.trim="basic.form.primaryKey" readOnly="true" placeholder="必须int且自增类型" autocomplete="off" size="small"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="10">
                    <el-form-item label="页面标题:" prop="title" :label-width="formLabelWidth">
                        <el-input v-model.trim="basic.form.title" autocomplete="off" size="small" maxlength="200"></el-input>
                    </el-form-item>
                </el-col>
                <el-col :span="10">
                    <el-form-item label="允许新增:" prop="addBtn" :label-width="formLabelWidth">
                        <el-select style="width: 100%" v-model="basic.form.addBtn">
                            <el-option :key="true" label="是" :value="true"></el-option>
                            <el-option :key="false" label="否" :value="false"></el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
                <el-col :span="10">
                    <el-form-item label="允许编辑:" prop="editBtn" :label-width="formLabelWidth">
                        <el-select style="width: 100%" v-model="basic.form.editBtn">
                            <el-option :key="true" label="是" :value="true"></el-option>
                            <el-option :key="false" label="否" :value="false"></el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
                <el-col :span="10">
                    <el-form-item label="允许删除:" prop="deleteBtn" :label-width="formLabelWidth">
                        <el-select style="width: 100%" v-model="basic.form.deleteBtn">
                            <el-option :key="true" label="是" :value="true"></el-option>
                            <el-option :key="false" label="否" :value="false"></el-option>
                        </el-select>
                    </el-form-item>
                </el-col>
            </el-row>
        </el-form>

        <el-card style="margin-top: 10px;" shadow="never"  v-if="basic.checked">
            <div slot="header" class="clearfix">
                <span>列表查询配置</span>
            </div>
            <el-form :model="mainTable.form" :rules="mainTable.rules" ref="mainTableForm" size="small">
                <el-row :gutter="24">
                    <el-col :span="12">
                        <el-form-item label="是否分页:" prop="pagination" :label-width="formLabelWidth">
                            <el-select style="width: 100%" v-model="mainTable.form.pagination">
                                <el-option :key="true" label="是" :value="true"></el-option>
                                <el-option :key="false" label="否" :value="false"></el-option>
                            </el-select>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="默认排序字段:" prop="defaultSortColumn" :label-width="formLabelWidth">
                            <el-input v-model.trim="mainTable.form.defaultSortColumn" autocomplete="off" size="small"></el-input>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12" v-if="mainTable.form.defaultSortColumn">
                        <el-form-item label="正序or倒序:" prop="defaultOrder" :label-width="formLabelWidth">
                            <el-select style="width: 100%" v-model="mainTable.form.defaultOrder">
                                <el-option key="asc" label="正序" value="asc"></el-option>
                                <el-option key="desc" label="倒序" value="desc"></el-option>
                            </el-select>
                        </el-form-item>
                    </el-col>
                    <el-col :span="24" style="margin-bottom: 8px;">
                        <el-form-item label="添加列" prop="columns" :label-width="formLabelWidth">
                            <el-button type="primary" plain size="mini" @click="showAddColumn">添加</el-button>
                        </el-form-item>
                    </el-col>
                    <span v-for="(item,index) in mainTable.form.columns">
                        <el-card style="margin-top: 8px;">
                            <el-row style="border: 0px solid gray;" :gutter="24">
                                <el-col :span="8">
                                    <el-form-item label="sql查询字段:" :label-width="formLabelWidth"
                                                  :prop="'columns.' + index + '.key'" :rules="mainTable.rules.columnRules.key">
                                        <el-input v-model.trim="item.key" placeholder="" readOnly="true" autocomplete="off" size="small"></el-input>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="8">
                                    <el-form-item label="sql查询别名:" :label-width="formLabelWidth"
                                                  :prop="'columns.' + index + '.prop'" :rules="mainTable.rules.columnRules.prop">
                                        <el-input v-model.trim="item.prop" placeholder="默认等于“sql查询字段”" maxlength="50" autocomplete="off" size="small"></el-input>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="8">
                                    <el-form-item label="前端列头文案:" :label-width="formLabelWidth"
                                                  :prop="'columns.' + index + '.label'" :rules="mainTable.rules.columnRules.label">
                                        <el-input v-model.trim="item.label" placeholder="" maxlength="50" autocomplete="off" size="small"></el-input>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="8">
                                    <el-form-item label="前端列宽度（px）:" :label-width="formLabelWidth"
                                                  :prop="'columns.' + index + '.width'" :rules="mainTable.rules.columnRules.width">
                                        <el-input v-model.trim="item.width" placeholder="" maxlength="50" autocomplete="off" size="small"></el-input>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="8">
                                    <el-form-item label="是否可以排序:" :label-width="formLabelWidth">
                                        <el-select style="width: 100%" v-model="item.sortable" placeholder="默认否">
                                            <el-option :key="true" label="是" :value="true"></el-option>
                                            <el-option :key="false" label="否" :value="false"></el-option>
                                        </el-select>
                                    </el-form-item>
                                </el-col>
                            </el-row>
                            <el-row style="border: 0px solid gray;" :gutter="24">
                                <el-col :span="8">
                                    <el-form-item label="格式化类型:" :label-width="formLabelWidth">
                                        <el-select style="width: 100%" clearable v-model="item.formatterTypeIndex" @change="formatterTypeChange(index)">
                                            <el-option v-for="(type,aIndex) in formatterTypes" :key="aIndex"
                                                       :label="type.name" :value="aIndex">
                                            </el-option>
                                        </el-select>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="8" v-if="item.hides.indexOf('formatterPicWidth') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="图片展示宽度（px）:" :prop="'columns.' + index + '.formatterPicWidth'" :rules="mainTable.rules.columnRules.width" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterPicWidth" placeholder="默认50" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="8" v-if="item.hides.indexOf('formatterPicHeight') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="图片展示高度（px）:" :prop="'columns.' + index + '.formatterPicHeight'" :rules="mainTable.rules.columnRules.width" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterPicHeight" placeholder="默认50" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="8" v-if="item.hides.indexOf('formatterSwitchActiveValue') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="选中选项的值:" :prop="'columns.' + index + '.formatterSwitchActiveValue'" :rules="mainTable.rules.columnRules.formatterSwitchValue" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterSwitchActiveValue" placeholder="" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="8" v-if="item.hides.indexOf('formatterSwitchActiveLabel') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="选中选项的标签:" :prop="'columns.' + index + '.formatterSwitchActiveLabel'" :rules="mainTable.rules.columnRules.formatterSwitchValue" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterSwitchActiveLabel" placeholder="" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="8" v-if="item.hides.indexOf('formatterSwitchInactiveValue') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="未选中选项的值:" :prop="'columns.' + index + '.formatterSwitchInactiveValue'" :rules="mainTable.rules.columnRules.formatterSwitchValue" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterSwitchInactiveValue" placeholder="" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                <el-col :span="8" v-if="item.hides.indexOf('formatterSwitchInactiveLabel') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">
                                    <el-form-item label="未选中选项的标签:" :prop="'columns.' + index + '.formatterSwitchInactiveLabel'" :rules="mainTable.rules.columnRules.formatterSwitchValue" :label-width="formLabelWidth">
                                        <el-input v-model.trim="item.formatterSwitchInactiveLabel" placeholder="" autocomplete="off" size="small" maxlength="50"></el-input>
                                    </el-form-item>
                                </el-col>
                                <#--<el-col :span="8" v-if="item.hides.indexOf('formatterTextMap') == -1 && (item.formatterTypeIndex || item.formatterTypeIndex == 0)">-->
                                    <#--<el-form-item label="未选中选项的标签:" :prop="'columns.' + index + '.formatterTextMap'" :rules="mainTable.rules.columnRules.formatterTextMap" :label-width="formLabelWidth">-->
                                        <#--<el-input v-model.trim="item.formatterTextMap" placeholder="" autocomplete="off" size="small" maxlength="50"></el-input>-->
                                    <#--</el-form-item>-->
                                <#--</el-col>-->
                            </el-row>
                        </el-card>
                    </span>
                </el-row>
            </el-form>
        </el-card>
    </el-card>

    <el-dialog title="添加列" :visible.sync="addColumn.visible" class="group-dialog" :before-close="closeAddColumn">
        <el-select v-model="addColumn.item" placeholder="请选择" size="small"
                   style="width: 100%">
            <el-option
                    v-for="item in mainColumns"
                    :key="item.name"
                    :label="'列名:' + item.name + '   类型:' + item.type"
                    :value="item.name">
            </el-option>
        </el-select>
        <el-button type="primary" plain size="mini" @click="addColumnFun">确认</el-button>
    </el-dialog>
</div>

<script>
    window.contextPath = '${contextPath}'
    new Vue({
        name: 'config',
        el: '#app',
        data() {
            var validateNum = (rule, value, callback) => {
                if (!value || value === '') {
                    callback();
                } else {
                    if (/(^[1-9]\d*$)/.test(value)) {
                        callback();
                    }else{
                        callback(new Error('格式要求正整数'));
                    };
                }
            };
            var validateMap = (rule, value, callback) => {
                if (!value || value === '') {
                    callback(new Error('请输入'));
                } else {
                    try {
                        let obj = JSON.parse(value);
                        console.log(Object.keys(obj).length)
                        if (Object.keys(obj).length == 0) {
                            callback(new Error('格式要求map类型的json,key value都必须为string'));
                            return
                        }
                        for (let o in obj) {
                            if (typeof (o) != 'string' || typeof(obj[o]) != 'string') {
                                callback(new Error('格式要求map类型的json,key value都必须为string'));
                                return
                            }
                        }
                        callback();
                    } catch (e) {
                        callback(new Error('格式要求map类型的json,key value都必须为string'));
                    }
                }
            };
            return {
                loading: false,
                formLabelWidth: '150px',
                addElementTypes: [],
                formatterTypes: [],
                basic: {
                    form: {},
                    rules: {
                        title: [{required : true, message: '请输入', trigger: 'change' }],
                        schema: [{required : true, message: '请输入', trigger: 'change' }],
                        table: [{required : true, message: '请输入', trigger: 'change' }],
                        primaryKey: [{required : true, message: '请输入', trigger: 'change' }],
                    },
                    checked: false
                },
                mainColumns: [],
                mainTable: {
                    form: {
                        columns: []
                    },
                    rules: {
                        pagination: [{required : true, message: '请选择', trigger: 'change' }],
                        columns: [{required : true, message: '查询字段不能为空', trigger: 'change' }],
                        columnRules: {
                            key: [{required : true, message: 'sql查询字段不能为空', trigger: 'change' }],
                            label: [{required : true, message: '前端列头文案不能为空', trigger: 'change' }],
                            width: [{required : false, validator: validateNum, trigger: 'change' }],
                            formatterSwitchValue: [{required : true, message: '请输入', trigger: 'change' }],
                            formatterTextMap: [{required : true, validator: validateMap, trigger: 'change' }],
                        }
                    }
                },
                addColumn: {
                    visible: false,
                    item: null
                }
            }
        },
        methods: {
            formatterTypeChange(index) {
                if (typeof this.mainTable.form.columns[index].formatterTypeIndex == 'number') {
                    this.mainTable.form.columns[index].hides = this.formatterTypes[this.mainTable.form.columns[index].formatterTypeIndex].hides
                } else {
                    delete this.mainTable.form.columns[index].formatterTypeIndex
                }
            },
            addColumnFun() {
                this.loading = true

                if (this.addColumn.item != null && typeof this.addColumn.item != 'undefined') {
                    for (let i = 0; i < this.mainColumns.length; i ++) {
                        if (this.mainColumns[i].name === this.addColumn.item) {
                            this.mainTable.form.columns.push({
                                key: this.addColumn.item,
                                hides: []
                            })
                            this.mainColumns.splice(i,1)
                            break
                        }
                    }
                }
                this.closeAddColumn()
                this.loading = false
            },
            closeAddColumn() {
                this.addColumn.visible = false
                this.addColumn.item = null
            },
            showAddColumn() {
                this.addColumn.visible = true
            },
            reset() {
                this.mainTable.form.columns = []
                this.mainColumns = []
                delete this.basic.form.primaryKey
                this.basic.checked = false
            },
            getMainTable() {
                if (!this.basic.form.schema) {
                    this.$message.info('请填写数据库');
                    return
                }
                if (!this.basic.form.table) {
                    this.$message.info('请填写数据库表');
                    return
                }
                this.reset()
                this.loading = true
                axios.get(window.contextPath + '/api/getTable',{
                    params: {
                        schema: this.basic.form.schema,
                        table: this.basic.form.table
                    }
                }).then(res => {
                    if (res.data.status != 0) {
                        this.$message.error(res.data.msg);
                    }
                    else {
                        this.basic.form.primaryKey = res.data.content.table.primaryKey
                        this.mainColumns = res.data.content.table.columns
                        this.basic.checked = true
                    }
                    this.loading = false;
                }).catch(res => {
                    console.error(res)
                    this.$message.error('服务异常');
                    this.loading = false;
                })
            }
        },
        created: function () {
            axios.get(window.contextPath + '/api/addElementTypes',{
                params: {}
            }).then(res => {
                if (res.data.status != 0) {
                    this.$message.error(res.data.msg);
                }
                else {
                    this.addElementTypes = res.data.content.list;
                }
                this.loading = false;
            }).catch(res => {
                console.error(res)
                this.$message.error('服务异常');
                this.loading = false;
            })
            axios.get(window.contextPath + '/api/formatterTypes',{
                params: {}
            }).then(res => {
                if (res.data.status != 0) {
                    this.$message.error(res.data.msg);
                }
                else {
                    this.formatterTypes = res.data.content.list;
                }
                this.loading = false;
            }).catch(res => {
                console.error(res)
                this.$message.error('服务异常');
                this.loading = false;
            })

            this.basic.form.schema = 'test_cms'
            this.basic.form.table = 'tb_main'
            this.getMainTable()
        }
    })
</script>
</body>
</html>