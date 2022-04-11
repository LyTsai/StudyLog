<template>
<div class="login_container">
  <div class="login_box">
    <!-- logo image -->
    <div class="avator_box">
      <img src="../assets/logo.png" alt="logo">
    </div>
    <el-form ref="loginFormRef" :model="loginForm" :rules="loginFormRules" label-width="120" class="login_form" hide-required-asterisk=false>
      <!-- username -->
      <el-form-item label = "Username:" prop="username">
        <el-input v-model="loginForm.username" placeholder="Please input Email address" :prefix-icon="Search"/>
      </el-form-item>
        <!-- password -->
      <el-form-item label = "Password:" prop="password">
        <el-input v-model="loginForm.password" type="password" placeholder="Please input password" show-password :prefix-icon="icon-password"/>
      </el-form-item>
        <!-- buttons -->
      <el-form-item class="btns">
        <el-button type="primary" @click="login">Log In</el-button>
        <el-button type="info" @click="resetLoginForm">Reset</el-button>
      </el-form-item>
    </el-form>
  </div>
</div>
</template>

<script>
import { getCurrentInstance, reactive, ref, unref } from 'vue'
export default {
  setup (props) {
    const loginFormRef = ref()
    const loginForm = reactive({
      username: '',
      password: ''
    })
    const loginFormRules = reactive({
      username: [
        { required: true, message: 'Please input a valid account', trigger: 'blur' }
      ],
      password: [
        { required: true, message: 'Please input password', trigger: 'blur' }
      ]
    })

    const resetLoginForm = () => {
      const formEl = unref(loginFormRef)
      formEl.resetFields()
    }

    const { proxy } = getCurrentInstance()
    const login = async () => {
      const formEl = unref(loginFormRef)
      if (!formEl) return
      await formEl.validate((valid, fields) => {
        if (valid) {
          const loginUrl = 'https://annielyticx-gamedataauth.azurewebsites.net/oauth/token'
          const body = 'username=' + loginForm.username + '&password=' + loginForm.password + '&grant_type=password'
          fetch(loginUrl, {
            method: 'post',
            body: body,
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded'
            }
          }).then(response => {
            console.log(response)
            if (!response.ok) {
              throw new Error('Failed to login' + response.status)
            }
            return response.json()
          }).then(result => {
            console.log(result)
            const token = result.access_token
            window.sessionStorage.setItem('token', token)
            proxy.$router.push('/home')
          }).catch(error => {
            alert('Failed to login :' + error)
          })
        } else {
          console.log('error submit!', fields)
        }
      })
    }
    return {
      loginFormRef, loginForm, loginFormRules, resetLoginForm, login
    }
  }
}
</script>

<style lang="less" scoped>
.login_container {
    background-color: #2b4b6b;
    height: 100%;
}

.login_box {
    width: 450px;
    height: 300px;
    background-color: white;
    border-radius: 3px;
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
}

.avator_box {
    height: 130px;
    width: 130px;
    border: 1px solid #eee;
    border-radius: 50%;
    padding: 10px;
    box-shadow: 0 0 10px #ddd;
    position: absolute;
    left: 50%;
    top: -50%;
    transform: translate(-50%, 50%);
    background-color: #fff;
    img {
        width: 100%;
        height: 100%;
        border-radius: 50%;
        background-color: #eee;
    }
}

.login_form {
    position: absolute;
    bottom: 0;
    width: 100%;
    padding: 0 20px;
    box-sizing: border-box;
}

.btns {
    display: flex;
    justify-content: flex-end;
    float: right;
}
</style>
