<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Codeless Platform</title>
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
        .el-link.el-link--default {
            color: white;
            font-size: larger;
        }
        .box-card {
            width: 480px;
        }
    </style>
</head>
<body>
<div id="app">
    <div v-if="!inLogin" style="position: absolute;color: white;left: 100px;top: 20px;">
        <div>
            <el-link :underline="false" href="#">使用文档</el-link>
        </div>
        <div style="margin-top: 150px;width: 330px;">
            <p style="font-size: xx-large;">Codeless Platform</p>
            <p style="font-size: medium;">低代码插件配置</p>
        </div>
        <div style="margin-top: 60px;">
            <el-button type="info" plain @click="toLogin">登录</el-button>
        </div>
    </div>
    <div v-if="inLogin" style="position: absolute; left: 50%; top: 30%;">
        <div style="position: relative; left: -50%; top: -50%;">
            <el-card class="box-card">
                <div slot="header" style="text-align: center;font-family: 微软雅黑;color: grey;">
                    <span>登 录</span>
                </div>
                <el-form ref="form" :model="form" :disabled="loading">
                    <el-form-item prop="loginname" :rules="[{required: true, message: '请输入账户', trigger: 'change'}]">
                        <el-input prefix-icon="el-icon-user" v-model="form.loginname" placeholder="登录名"></el-input>
                    </el-form-item>
                    <el-form-item prop="password" :rules="[{required: true, message: '请输入密码', trigger: 'change'}]">
                        <el-input prefix-icon="el-icon-lock" v-model="form.password" type="password" show-password placeholder="密码"></el-input>
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" style="width: 100%" @click="login">登录</el-button>
                    </el-form-item>
                </el-form>
            </el-card>
        </div>
    </div>
    <iframe src="${contextPath}/pages/${random}.html" style="border: 0;margin: 0px;padding: 0px;width: 100%;height: 100%;"></iframe>
</div>
<script>
    window.contextPath = '${contextPath}'
    window.vue = new Vue({
        name: 'index',
        el: '#app',
        data() {
            return {
                inLogin: false,
                loading: false,
                form: {}
            }
        },
        methods: {
            toLogin() {
                this.inLogin = true
            },
            login() {
                this.loading = true
                this.$refs['form'].validate((valid, obj) => {
                    if (valid) {
                        axios.get(window.contextPath + '/api/login', {
                            params: {
                                loginname: this.form.loginname,
                                password: this.form.password
                            }
                        }).then(res => {
                            this.loading = false
                            if (res.data.status == 0) {
                                window.location.href = window.contextPath + '/list.html'
                            } else {
                                this.$message.error(res.data.msg);
                            }
                        }).catch(res => {
                            this.loading = false
                            console.error(res)
                            this.$message.error('服务异常');
                        })
                    } else {
                        this.loading = false
                    }
                });
            }
        },
        created: function () {
        }
    })
</script>
</body>
</html>