<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>db</title>
    <link rel="stylesheet" href="${contextPath}/element-ui/theme-chalk/index.css">
    <script src="${contextPath}/vue.min.js"></script>
    <script src="${contextPath}/element-ui/index.js"></script>
    <script src="${contextPath}/axios.min.js"></script>
    <style>
        .box-card {
            margin-top: 3px;
            margin-bottom: 3px;
        }
        #app {
            min-height: 400px;
        }
    </style>
</head>
<body style="margin: 0px;">
<div id="app" v-loading="loading">
    <el-card class="box-card">
        <div slot="header">
            <span>主表</span>
        </div>
        <div>
            <el-form :inline="true" :model="form" :rules="rules" ref="form" size="small">
                <el-form-item label="数据库:" prop="schema">
                    <el-input v-model.trim="form.schema" placeholder="请填写数据库" :disabled="form.checked"></el-input>
                </el-form-item>
                <el-form-item label="数据库表:" prop="table">
                    <el-input v-model.trim="form.table" placeholder="请填写数据库表" :disabled="form.checked"></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="getTable(dbMain, form, 'form')" size="mini" :disabled="form.checked">点击获取表结构</el-button>
                    <el-button type="success" @click="submit" size="mini" v-if="form.checked" :disabled="confirmed">确认</el-button>
                    <el-button type="warning" @click="reset" size="mini" v-if="form.checked">重置</el-button>
                    <el-button type="info" @click="showDialog" size="mini">查看</el-button>
                </el-form-item>
            </el-form>
        </div>
    </el-card>
    <el-card class="box-card" v-if="form.checked">
        <div slot="header">
            <span>[{{form.schema}}.{{form.table}}]一对一从表</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="addOneToOneFollow" :disabled="confirmed">点击添加</el-button>
        </div>
        <div v-for="(item,index) in oneToOneFollowForms">
            <el-card class="box-card">
                <el-form :inline="true" :disabled="confirmed" size="small" :model="oneToOneFollowForms" :ref="'oneToOneFollowRef' + index">
                    <el-form-item label="数据库:"
                                  :prop="index + '.schema'"
                                  :rules="rules.schema">
                        <el-input v-model.trim="item.schema" placeholder="请填写数据库" :disabled="item.checked"></el-input>
                    </el-form-item>
                    <el-form-item label="数据库表:"
                                  :prop="index + '.table'"
                                  :rules="rules.table">
                        <el-input v-model.trim="item.table" placeholder="请填写数据库表" :disabled="item.checked"></el-input>
                    </el-form-item>
                    <el-form-item label="关联主表字段:"
                                  :prop="index + '.parentKey'"
                                  :rules="rules.parentKey">
                        <el-select v-model.trim="item.parentKey" placeholder="请选择关联主表字段" size="small" style="width: 100%" :disabled="item.checked">
                            <el-option
                                    v-for="column in dbMain.columns"
                                    :key="column.name"
                                    :label="'列名:' + column.name + '   类型:' + column.type"
                                    :value="column.name">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="当前表外键字段:"
                                  :prop="index + '.relateKey'"
                                  :rules="rules.relateKey">
                        <el-input v-model.trim="item.relateKey" placeholder="请填写当前表外键字段" :disabled="item.checked"></el-input>
                    </el-form-item>
                    <el-form-item>
                        <el-button-group>
                            <el-button type="primary" @click="getTable(dbOneToOneFollows[index], item, 'oneToOneFollowRef' + index)" size="mini" :disabled="item.checked">点击获取表结构</el-button>
                            <el-button type="danger" @click="removeTable(dbOneToOneFollows, oneToOneFollowForms, index)" size="mini">移除</el-button>
                        </el-button-group>
                    </el-form-item>
                </el-form>
            </el-card>
        </div>
    </el-card>
    <el-card class="box-card" v-if="form.checked">
        <div slot="header">
            <span>[{{form.schema}}.{{form.table}}]一对多从表</span>
            <el-button style="float: right; padding: 3px 0" type="text" @click="addOneToMoreFollow" :disabled="confirmed">点击添加</el-button>
        </div>
        <div v-for="(item,index) in oneToMoreFollowForms">
            <el-card class="box-card">
                <el-form :inline="true" :disabled="confirmed" size="small" :model="oneToMoreFollowForms" :ref="'oneToMoreFollowRef' + index">
                    <el-form-item label="数据库:"
                                  :prop="index + '.schema'"
                                  :rules="rules.schema">
                        <el-input v-model.trim="item.schema" placeholder="请填写数据库" :disabled="item.checked"></el-input>
                    </el-form-item>
                    <el-form-item label="数据库表:"
                                  :prop="index + '.table'"
                                  :rules="rules.table">
                        <el-input v-model.trim="item.table" placeholder="请填写数据库表" :disabled="item.checked"></el-input>
                    </el-form-item>
                    <el-form-item label="关联主表字段:"
                                  :prop="index + '.parentKey'"
                                  :rules="rules.parentKey">
                        <el-select v-model.trim="item.parentKey" placeholder="请选择关联主表字段" size="small" style="width: 100%" :disabled="item.checked">
                            <el-option
                                    v-for="column in dbMain.columns"
                                    :key="column.name"
                                    :label="'列名:' + column.name + '   类型:' + column.type"
                                    :value="column.name">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="当前表外键字段:"
                                  :prop="index + '.relateKey'"
                                  :rules="rules.relateKey">
                        <el-input v-model.trim="item.relateKey" placeholder="请填写当前表外键字段" :disabled="item.checked"></el-input>
                    </el-form-item>
                    <el-form-item>
                        <el-button-group>
                            <el-button type="primary" @click="getTable(dbOneToMoreFollows[index], item, 'oneToMoreFollowRef' + index)" size="mini" :disabled="item.checked">点击获取表结构</el-button>
                            <el-button type="danger" @click="removeTable(dbOneToMoreFollows, oneToMoreFollowForms, index)" size="mini">移除</el-button>
                        </el-button-group>
                    </el-form-item>
                    <el-card class="box-card" v-if="item.checked">
                        <div slot="header">
                            <span>[{{item.schema}}.{{item.table}}]一对一从表</span>
                            <el-button style="float: right; padding: 3px 0" type="text" @click="addFollowOneToOneFollow(index)" :disabled="confirmed">点击添加</el-button>
                        </div>
                        <div v-for="(itemFollow,indexFollow) in item.oneToOneFollowForms">
                            <el-card class="box-card">
                                <el-form :inline="true" :disabled="confirmed" size="small"
                                         :model="itemFollow" :ref="'followOneToOneFollowRef' + indexFollow">
                                    <el-form-item label="数据库:"
                                                  prop="schema"
                                                  :rules="rules.schema">
                                        <el-input v-model.trim="itemFollow.schema" placeholder="请填写数据库" :disabled="itemFollow.checked"></el-input>
                                    </el-form-item>
                                    <el-form-item label="数据库表:"
                                                  prop="table"
                                                  :rules="rules.table">
                                        <el-input v-model.trim="itemFollow.table" placeholder="请填写数据库表" :disabled="itemFollow.checked"></el-input>
                                    </el-form-item>
                                    <el-form-item label="关联主表字段:"
                                                  prop="parentKey"
                                                  :rules="rules.parentKey">
                                        <el-select v-model.trim="itemFollow.parentKey" placeholder="请选择关联主表字段" size="small" style="width: 100%" :disabled="itemFollow.checked">
                                            <el-option
                                                    v-for="column in dbOneToMoreFollows[index].columns"
                                                    :key="column.name"
                                                    :label="'列名:' + column.name + '   类型:' + column.type"
                                                    :value="column.name">
                                            </el-option>
                                        </el-select>
                                    </el-form-item>
                                    <el-form-item label="当前表外键字段:"
                                                  prop="relateKey"
                                                  :rules="rules.relateKey">
                                        <el-input v-model.trim="itemFollow.relateKey" placeholder="请填写当前表外键字段" :disabled="itemFollow.checked"></el-input>
                                    </el-form-item>
                                    <el-form-item>
                                        <el-button-group>
                                            <el-button type="primary" @click="getTable(oneToMoreFollowForms[index].dbOneToOneFollow[indexFollow], itemFollow, 'followOneToOneFollowRef' + indexFollow)"
                                                       size="mini" :disabled="itemFollow.checked">点击获取表结构</el-button>
                                            <el-button type="danger" @click="removeTable(oneToMoreFollowForms[index].dbOneToOneFollow, oneToMoreFollowForms[index].oneToOneFollowForms, indexFollow)" size="mini">移除</el-button>
                                        </el-button-group>
                                    </el-form-item>
                                </el-form>
                            </el-card>
                        </div>
                    </el-card>
                </el-form>
            </el-card>
        </div>
    </el-card>

    <el-dialog title="数据库" :visible.sync="dialogVisible" width="80%">
        <el-row :gutter="24">
            <el-col :span="8" v-if="dbMain.schema && dbMain.table">
                <el-card class="box-card">
                    <div slot="header">
                        <span>主表 - {{dbMain.schema}}.{{dbMain.table}}</span>
                        <el-table
                                :data="dbMain.columns"
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
            <el-col :span="8" v-for="(item, index) in dbOneToOneFollows" v-if="item.schema && item.table && item.columns && item.columns.length > 0">
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
            <el-col :span="8" v-for="(item, index) in dbOneToMoreFollows" v-if="item.schema && item.table && item.columns && item.columns.length > 0">
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
    </el-dialog>
</div>
<script>
    window.contextPath = '${contextPath}'
</script>
<script>
    window.setInterval(() => {
        window.parent.document.getElementById("db").height = document.getElementById("app").offsetHeight + 15
    }, 200)

    window.vue = new Vue({
        name: 'db',
        el: '#app',
        data() {
            return {
                loading: false,
                confirmed: false,
                height: window.innerHeight - 78,
                formLabelWidth: '150px',
                form: {
                    schema: '',
                    table: '',
                    checked: false
                },
                rules: {
                    schema: [{required: true, message: '请输入', trigger: 'change'}],
                    table: [{required: true, message: '请输入', trigger: 'change'}],
                    relateKey: [{required: true, message: '请输入', trigger: 'change'}],
                    parentKey: [{required: true, message: '请输入', trigger: 'change'}],
                },
                dbMain: {},
                oneToOneFollowForms: [],
                dbOneToOneFollows: [],
                oneToMoreFollowForms: [],
                dbOneToMoreFollows: [],
                dialogVisible: false
            }
        },
        watch: {
        },
        methods: {
            submit() {
                // if (this.dbMain.columns && this.dbMain.columns.length > 0) {
                //     parent.window.vue.showDisabled = false
                // } else {
                //     parent.window.vue.showDisabled = true
                // }
                this.trans()
                parent.window.vue.showDisabled = false
                this.confirmed = true
            },
            showDialog() {
                this.dialogVisible = true
            },
            trans() {
                let oneToOne = []
                for (let i = 0; i < this.dbOneToOneFollows.length; i ++) {
                    if (this.dbOneToOneFollows[i].schema) {
                        oneToOne.push(this.dbOneToOneFollows[i])
                    }
                }
                let oneToMore = []
                for (let i = 0; i < this.dbOneToMoreFollows.length; i ++) {
                    if (this.dbOneToMoreFollows[i].schema) {
                        oneToMore.push(this.dbOneToMoreFollows[i])
                    }
                }
                parent.window.vue.$options.methods.init(this.dbMain, oneToOne, oneToMore)
            },
            reset() {
                this.oneToOneFollowForms = []
                this.dbOneToOneFollows = []
                this.oneToMoreFollowForms = []
                this.dbOneToMoreFollows = []
                this.dbMain = {}
                this.form = {
                    schema: '',
                    table: '',
                    checked: false
                }
                this.$refs.form.resetFields()
                this.trans()
                parent.window.vue.showDisabled = true
                this.confirmed = false
            },
            removeTable(dbs, forms, index) {
                dbs.splice(index, 1)
                forms.splice(index, 1)
            },
            addFollowOneToOneFollow(index) {
                if (typeof this.oneToMoreFollowForms[index].oneToOneFollowForms == 'undefined') {
                    this.oneToMoreFollowForms[index].oneToOneFollowForms = []
                    this.oneToMoreFollowForms[index].dbOneToOneFollow = []
                }
                this.oneToMoreFollowForms[index].oneToOneFollowForms.push({
                    schema: '',
                    table: '',
                    relateKey: '',
                    parentKey: '',
                    checked: false
                })
                this.oneToMoreFollowForms[index].dbOneToOneFollow.push({})
                this.oneToMoreFollowForms = JSON.parse(JSON.stringify(this.oneToMoreFollowForms))
            },
            addOneToMoreFollow() {
                this.oneToMoreFollowForms.push({
                    schema: '',
                    table: '',
                    checked: false
                })
                this.dbOneToMoreFollows.push({})
            },
            addOneToOneFollow() {
                this.oneToOneFollowForms.push({
                    schema: '',
                    table: '',
                    relateKey: '',
                    parentKey: '',
                    checked: false
                })
                this.dbOneToOneFollows.push({})
            },
            getTable(db, form, formName) {
                let ff = null;
                if (typeof this.$refs[formName].length == 'number') {
                    ff = this.$refs[formName][0]
                } else {
                    ff = this.$refs[formName]
                }
                ff.validate((valid) => {
                    if (valid) {
                        this.loading = true
                        axios.get(window.contextPath + '/api/getTable', {
                            params: {
                                schema: form.schema,
                                table: form.table
                            }
                        }).then(res => {
                            if (res.data.status != 0) {
                                this.$message.error(res.data.msg);
                            }
                            else {
                                if (form.parentKey) {
                                    let parentKey = false
                                    for (let i = 0; i < res.data.content.table.columns.length; i ++) {
                                        if (res.data.content.table.columns[i].name == form.parentKey) {
                                            parentKey = true
                                            break
                                        }
                                    }
                                    if (parentKey) {
                                        db.schema = form.schema
                                        db.table = form.table
                                        db.primaryKey = res.data.content.table.primaryKey
                                        db.columns = res.data.content.table.columns
                                        db.parentKey = form.parentKey
                                        db.relateKey = form.relateKey
                                        form.checked = true
                                        this.$message.success("表结构获取成功");
                                        // this.trans()
                                    } else {
                                        form.checked = false
                                        this.$message.error('当前表外键字段 ' + form.parentKey + " 不存在");
                                        form.parentKey = ''
                                    }
                                } else {
                                    db.schema = form.schema
                                    db.table = form.table
                                    db.primaryKey = res.data.content.table.primaryKey
                                    db.columns = res.data.content.table.columns
                                    form.checked = true
                                    this.$message.success("表结构获取成功");
                                    // this.trans()
                                }
                            }
                            this.loading = false;
                        }).catch(res => {
                            console.error(res)
                            this.$message.error('服务异常');
                            this.loading = false;
                        })
                    } else {
                        this.$message.info('数据不完整');
                    }
                });
            }
        },
        created: function () {
            this.form.schema = 'test'
            this.form.table = 'tb_main'
            this.oneToMoreFollowForms.push({
                schema: 'test',
                table: 'tb_follow',
                checked: false,
                parentKey: 'id',
                relateKey: 'main_id'
            })
            this.dbOneToMoreFollows.push({})
        }
    })
</script>
</body>
</html>