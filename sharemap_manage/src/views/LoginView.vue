<template>
<div class="login_container">
  <div class="login_box">
    <!-- logo image -->
    <div class="avator_box">
      <img src="../assets/logo.png" alt="logo">
    </div>
    <el-form ref="loginFormRef" :model="loginForm" :rules="loginFormRules" label-width="0" class="login_form">
      <!-- username -->
      <el-form-item prop="username">
        <span>UserName</span>
        <el-input v-model="loginForm.username" placeholder="Please input Email adress" :prefix-icon="Search"/>
      </el-form-item>
        <!-- password -->
      <el-form-item prop="password">
        <span>Password</span>
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
// import axios from 'axios'
export default {
  data () {
    return {
      loginForm: {
        username: '',
        password: ''
      },
      loginFormRules: {
        username: [
          { required: true, message: 'Please input valid account', trigger: 'blur' }
        ],
        password: [
          { required: true, message: 'Please input password', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    resetLoginForm () {
      this.$refs.loginFormRef.resetFields()
    },
    login () {
      this.$refs.loginFormRef.validate(valid => {
        if (!valid) return

        const loginUrl = 'https://annielyticx-gamedataauth.azurewebsites.net/oauth/token'
        const body = 'username=' + this.loginForm.username + '&password=' + this.loginForm.password + '&grant_type=password'
        fetch(loginUrl, {
          method: 'post',
          body: body,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          }
          // , mode: 'no-cors'
        }).then(response => {
          console.log(response)
          if (!response.ok) {
            throw new Error(response.status)
          }
          return response.json()
        }).then(result => {
          const token = result.access_token
          window.sessionStorage.setItem('token', token)
          this.$router.push('/home')
        }).catch(error => {
          alert(error)
        })
      })
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
}
</style>
