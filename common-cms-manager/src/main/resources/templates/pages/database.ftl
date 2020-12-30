<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>database</title>
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
    <el-form :inline="true" :model="mainDb" :rules="rules" ref="mainDb" size="small">
        <el-card class="box-card">
            <div slot="header">
                <span>主表</span>
            </div>
            <div>
                <el-form-item label="数据库:" prop="schema">
                    <el-input v-model.trim="mainDb.schema" placeholder="请填写数据库" :disabled="mainDb.checked"></el-input>
                </el-form-item>
                <el-form-item label="数据库表:" prop="table">
                    <el-input v-model.trim="mainDb.table" placeholder="请填写数据库表" :disabled="mainDb.checked"></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="getTable('mainDb',mainDb)" size="mini" v-if="!mainDb.checked">点击获取表结构</el-button>
                    <el-button type="primary" @click="showTable(mainDb)" size="mini" v-if="mainDb.checked">查看表</el-button>
                    <el-button type="primary" @click="resetAll" size="mini" v-if="mainDb.checked">重置</el-button>
                </el-form-item>
            </div>
            <el-row :gutter="24"  v-if="mainDb.checked">
                <el-col :span="24">
                    <el-button type="success" @click="addOne(mainDb)" size="mini" :disabled="confirmed">添加一对一从表</el-button>
                </el-col>
                <el-col :span="24" v-for="(follow,index) in mainDb.follows" style="margin-top: 8px;">
                    <el-form-item label="数据库:"
                                  :prop="'follows.' + index + '.schema'"
                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                        <el-input v-model.trim="follow.schema" placeholder="请填写数据库"
                                  @change="tableOrSchemaChange(follow)"
                                  :disabled="follow.checked"></el-input>
                    </el-form-item>
                    <el-form-item label="数据库表:"
                                  :prop="'follows.' + index + '.table'"
                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                        <el-input v-model.trim="follow.table" placeholder="请填写数据库表"
                                  @change="tableOrSchemaChange(follow)"
                                  :disabled="follow.checked"></el-input>
                    </el-form-item>
                    <el-form-item label="关联主表字段:"
                                  :prop="'follows.' + index + '.parentKey'"
                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                        <el-select v-model.trim="follow.parentKey" placeholder="请选择关联主表字段" size="small" style="width: 100%" :disabled="follow.checked">
                            <el-option
                                    v-for="column in mainDb.columns"
                                    :key="column.name"
                                    :label="'列名:' + column.name + '   类型:' + column.type"
                                    :value="column.name">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item label="当前表外键字段:"
                                  :prop="'follows.' + index + '.relateKey'"
                                  :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                        <el-select v-model.trim="follow.relateKey" placeholder="请填写当前表外键字段" size="small" style="width: 100%" :disabled="follow.checked">
                            <el-option
                                    v-for="column in follow.columns"
                                    :key="column.name"
                                    :label="'列名:' + column.name + '   类型:' + column.type"
                                    :value="column.name">
                            </el-option>
                        </el-select>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" @click="getTable('mainDb',follow)" size="mini" v-if="!follow.checked">点击获取表结构</el-button>
                        <el-button type="primary" @click="showTable(follow)" size="mini" v-if="follow.checked">查看表</el-button>
                        <el-button type="danger" @click="remove(mainDb.follows,index)" size="mini" :disabled="confirmed">移除</el-button>
                    </el-form-item>
                </el-col>
            </el-row>
        </el-card>
    </el-form>
    <el-form :inline="true" :model="followDb" :rules="rules" ref="followDb" size="small" v-if="mainDb.checked">
        <el-card class="box-card">
            <div slot="header">
                <span>一对多从表</span>
            </div>
            <div>
                <el-button type="success" @click="addTwo(followDb)" size="mini" :disabled="confirmed">添加一对多从表</el-button>
            </div>
            <el-card class="box-card" v-for="(follow,index) in followDb">
                <el-row :gutter="24">
                    <el-col :span="24" style="margin-top: 8px;">
                        <el-form-item label="数据库:"
                                      :prop="index + '.schema'"
                                      :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                            <el-input v-model.trim="follow.schema" placeholder="请填写数据库"
                                      @change="tableOrSchemaChange(follow)"
                                      :disabled="follow.checked"></el-input>
                        </el-form-item>
                        <el-form-item label="数据库表:"
                                      :prop="index + '.table'"
                                      :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                            <el-input v-model.trim="follow.table" placeholder="请填写数据库表"
                                      @change="tableOrSchemaChange(follow)"
                                      :disabled="follow.checked"></el-input>
                        </el-form-item>
                        <el-form-item label="关联主表字段:"
                                      :prop="index + '.parentKey'"
                                      :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                            <el-select v-model.trim="follow.parentKey" placeholder="请选择关联主表字段" size="small" style="width: 100%" :disabled="follow.checked">
                                <el-option
                                        v-for="column in mainDb.columns"
                                        :key="column.name"
                                        :label="'列名:' + column.name + '   类型:' + column.type"
                                        :value="column.name">
                                </el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="当前表外键字段:"
                                      :prop="index + '.relateKey'"
                                      :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                            <el-select v-model.trim="follow.relateKey" placeholder="请填写当前表外键字段" size="small" style="width: 100%" :disabled="follow.checked">
                                <el-option
                                        v-for="column in followDb[index].columns"
                                        :key="column.name"
                                        :label="'列名:' + column.name + '   类型:' + column.type"
                                        :value="column.name">
                                </el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item>
                            <el-button type="primary" @click="getTable('followDb',follow)" size="mini" v-if="!follow.checked">点击获取表结构</el-button>
                            <el-button type="primary" @click="showTable(follow)" size="mini" v-if="follow.checked">查看表</el-button>
                            <el-button type="danger" @click="remove(followDb,index)" size="mini" :disabled="confirmed">移除</el-button>
                        </el-form-item>
                    </el-col>
                </el-row>
                <el-row :gutter="24"  v-if="follow.checked">
                    <el-col :span="24">
                        <el-button type="success" @click="addOne(follow)" size="mini" :disabled="confirmed">添加一对一从表</el-button>
                    </el-col>
                    <el-col :span="24" v-for="(onFollow,fIndex) in follow.follows" style="margin-top: 8px;">
                        <el-form-item label="数据库:"
                                      :prop="index + '.follows.' + fIndex + '.schema'"
                                      :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                            <el-input v-model.trim="onFollow.schema" placeholder="请填写数据库"
                                      @change="tableOrSchemaChange(onFollow)"
                                      :disabled="onFollow.checked"></el-input>
                        </el-form-item>
                        <el-form-item label="数据库表:"
                                      :prop="index + '.follows.' + fIndex + '.table'"
                                      :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                            <el-input v-model.trim="onFollow.table" placeholder="请填写数据库表"
                                      @change="tableOrSchemaChange(onFollow)"
                                      :disabled="onFollow.checked"></el-input>
                        </el-form-item>
                        <el-form-item label="关联主表字段:"
                                      :prop="index + '.follows.' + fIndex + '.parentKey'"
                                      :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                            <el-select v-model.trim="onFollow.parentKey" placeholder="请选择关联主表字段" size="small" style="width: 100%" :disabled="onFollow.checked">
                                <el-option
                                        v-for="column in follow.columns"
                                        :key="column.name"
                                        :label="'列名:' + column.name + '   类型:' + column.type"
                                        :value="column.name">
                                </el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item label="当前表外键字段:"
                                      :prop="index + '.follows.' + fIndex + '.relateKey'"
                                      :rules="[{required: true, message: '请输入', trigger: 'change'}]">
                            <el-select v-model.trim="onFollow.relateKey" placeholder="请填写当前表外键字段" size="small" style="width: 100%" :disabled="onFollow.checked">
                                <el-option
                                        v-for="column in onFollow.columns"
                                        :key="column.name"
                                        :label="'列名:' + column.name + '   类型:' + column.type"
                                        :value="column.name">
                                </el-option>
                            </el-select>
                        </el-form-item>
                        <el-form-item>
                            <el-button type="primary" @click="getTable('followDb',onFollow)" size="mini" v-if="!onFollow.checked">点击获取表结构</el-button>
                            <el-button type="primary" @click="showTable(onFollow)" size="mini" v-if="onFollow.checked">查看表</el-button>
                            <el-button type="danger" @click="remove(followDb.follows,index)" size="mini" :disabled="confirmed">移除</el-button>
                        </el-form-item>
                    </el-col>
                </el-row>
            </el-card>
        </el-card>
    </el-form>

    <div style="text-align: right">
        <el-button type="primary" @click="submit" size="mini" v-if="mainDb.checked && !confirmed" ref="confirm_submit">确认</el-button>
    </div>

    <el-dialog :title="tableDialog.title"
            :visible.sync="tableDialog.visible">
        <div>主键: {{tableDialog.primaryKey}}</div>
        <el-table
                :data="tableDialog.columns"
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
    </el-dialog>
</div>
<script>
    window.contextPath = '${contextPath}'
    window.setInterval(() => {
        window.parent.document.getElementById("database").height = document.getElementById("app").offsetHeight + 15
    }, 200)
</script>
<script>
    window.vue = new Vue({
        name: 'database',
        el: '#app',
        data() {
            return {
                loading: false,
                mainDb: {
                },
                followDb: [],
                rules: {
                    schema: [{required: true, message: '请输入', trigger: 'change'}],
                    table: [{required: true, message: '请输入', trigger: 'change'}]
                },
                tableDialog: {
                    visible: false,
                    title: '',
                    columns: '',
                    primaryKey: ''
                },
                confirmed: false
            }
        },
        watch: {
        },
        methods: {
            sy() {
                console.log(JSON.stringify(this.mainDb))
                console.log(JSON.stringify(this.followDb))
                parent.window.vue.$options.methods.init(this.mainDb, this.followDb)
                parent.window.document.getElementById("basic").contentWindow.vue.$options.methods.init(this.mainDb, this.followDb)
            },
            submit() {
                console.log(this.$refs['mainDb'])
                this.$refs['mainDb'].validate((valid) => {
                    if (valid) {
                        if (this.mainDb.follows && this.mainDb.follows.length > 0) {
                            for (let i = 0; i < this.mainDb.follows.length; i ++) {
                                this.mainDb.follows[i].checked = true
                            }
                        }
                        if (this.followDb && this.followDb.length > 0) {
                            this.$refs['followDb'].validate((valid) => {
                                if (valid) {
                                    for (let i = 0; i < this.followDb.length; i ++) {
                                        this.followDb[i].checked = true
                                        if (this.followDb[i].follows && this.followDb[i].follows.length > 0) {
                                            for (let j = 0; j < this.followDb[i].follows.length; j ++) {
                                                this.followDb[i].follows[j].checked = true
                                            }
                                        }
                                    }
                                    this.confirmed = true
                                    this.sy()
                                }
                            });
                        } else {
                            this.confirmed = true
                            this.sy()
                        }
                    }
                });
            },
            tableOrSchemaChange(follow) {
                follow.primaryKey = ''
                follow.columns = []
                if (follow && follow.schema && follow.table) {
                    axios.get(window.contextPath + '/api/getTable', {
                        params: {
                            schema: follow.schema,
                            table: follow.table
                        }
                    }).then(res => {
                        if (res.data.status == 0) {
                            follow.primaryKey = res.data.content.table.primaryKey
                            follow.columns = res.data.content.table.columns
                            this.mainDb = JSON.parse(JSON.stringify(this.mainDb))
                            this.followDb = JSON.parse(JSON.stringify(this.followDb))
                        } else {
                            this.mainDb = JSON.parse(JSON.stringify(this.mainDb))
                            this.followDb = JSON.parse(JSON.stringify(this.followDb))
                        }
                    }).catch(res => {
                        console.error(res)
                        this.mainDb = JSON.parse(JSON.stringify(this.mainDb))
                        this.followDb = JSON.parse(JSON.stringify(this.followDb))
                    })
                }
            },
            addTwo(follows) {
                follows.push({
                    checked: false
                })
                this.followDb = JSON.parse(JSON.stringify(this.followDb))
            },
            remove(follows,index) {
                follows.splice(index,1)
            },
            addOne(form) {
                if (typeof form.follows == 'undefined') {
                    form.follows = []
                }
                form.follows.push({
                    checked: false,
                    columns: []
                })
                this.mainDb = JSON.parse(JSON.stringify(this.mainDb))
                this.followDb = JSON.parse(JSON.stringify(this.followDb))
            },
            showTable(form) {
                this.tableDialog = {
                    visible: true,
                    title: form.schema + '-' + form.table,
                    columns: form.columns,
                    primaryKey: form.primaryKey
                }
            },
            resetAll() {
                this.mainDb = {}
                this.followDb = []
                this.confirmed = false
                this.$refs.mainDb.resetFields()
                this.$refs.followDb.resetFields()
            },
            getTable(formName, form) {
                this.$refs[formName].validate((valid) => {
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
                                form.primaryKey = res.data.content.table.primaryKey
                                form.columns = res.data.content.table.columns
                                form.checked = true
                            }
                            this.loading = false;
                        }).catch(res => {
                            console.error(res)
                            this.$message.error('服务异常');
                            this.loading = false;
                        })
                    }
                });
            }
        },
        created() {
            this.mainDb = {"schema":"test","table":"tb_main","primaryKey":"id","columns":[{"name":"id","type":"int"},{"name":"name","type":"varchar"},{"name":"type","type":"int"},{"name":"pic","type":"varchar"},{"name":"status","type":"int"},{"name":"city_id","type":"int"},{"name":"time","type":"datetime"},{"name":"rich","type":"text"}],"checked":true,"follows":[{"checked":true,"columns":[{"name":"id","type":"int"},{"name":"name","type":"varchar"},{"name":"main_id","type":"int"}],"schema":"test","primaryKey":"id","table":"tb_main_left","parentKey":"id","relateKey":"main_id"}]}
            this.followDb = [{"checked":true,"schema":"test","primaryKey":"id","columns":[{"name":"id","type":"int"},{"name":"main_id","type":"int"},{"name":"f_name","type":"varchar"},{"name":"url","type":"varchar"},{"name":"time","type":"datetime"}],"table":"tb_follow","parentKey":"id","relateKey":"main_id","follows":[{"checked":true,"columns":[{"name":"id","type":"int"},{"name":"f_id","type":"int"},{"name":"pos","type":"varchar"}],"schema":"test","primaryKey":"id","table":"tb_follow_left","parentKey":"id","relateKey":"f_id"}]}]
            window.setTimeout(() => {
                this.submit()
            }, 500)
        }
    })
</script>
</body>
</html>