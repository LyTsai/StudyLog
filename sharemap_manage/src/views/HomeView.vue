<template>
  <el-container class="home-container">
    <!-- header -->
    <el-header>
      <div>
        <img src="../assets/logo.png" alt="home logo">
        <span>Share Map</span>
      </div>
      <el-button type="danger" @click="logout">Log Out</el-button>
      </el-header>
      <!-- aside and main -->
    <el-container>
      <el-aside :width="isCollapse ? '64px' : '160px'">
        <div class="toggle-button" @click="toggleSide">|||</div>
        <el-menu background-color="#333744" text-color="#fff" active-text-color="#409EFF" unique-opened :collapse="isCollapse" :collapse-transition="false" router :default-active="activePath">
          <el-sub-menu :index="index" :key="index" v-for="(item, index) in menulist">
            <template #title>
              <!-- <el-icon :class="item.icon"></el-icon> -->
              <span>{{item.name}}</span>
            </template>
            <!-- sub -->
            <el-menu-item :index="subItem.path" :key="index + subIndex" v-for="(subItem, subIndex) in item.sub" @:click="saveNavState(subItem.path)">
              <template #title>
                <span>{{subItem.title}}</span>
              </template>
            </el-menu-item>
          </el-sub-menu>
        </el-menu>
      </el-aside>
      <!-- main -->
      <el-main>
        <router-view></router-view>
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
export default {
  data () {
    return {
      menulist: [{
        icon: '',
        name: 'User Management',
        sub: [{
          icon: '',
          title: 'User List',
          path: '/userlist'
        }]
      }, {
        icon: '',
        name: 'Visuals',
        sub: [{
          icon: '',
          title: 'Visual Pages',
          path: '/visualPage'
        }, {
          icon: '',
          title: 'Visual Books',
          path: '/visualBook'
        }]
      }, {
        icon: '',
        name: 'Clients',
        sub: []
      }],
      isCollapse: false,
      activePath: '/welcome'
    }
  },
  created () {
    // init state, fetch data?
    const sessionPath = window.sessionStorage.getItem('activePath')
    if (sessionPath) {
      this.activePath = sessionPath
    }
  },
  methods: {
    logout () {
      window.sessionStorage.clear()
      this.$router.push('/login')
    },
    toggleSide () {
      this.isCollapse = !this.isCollapse
    },
    saveNavState (activePath) {
      window.sessionStorage.setItem('activePath', activePath)
      this.activePath = activePath
    }
  }
}
</script>

<style lang="less" scoped>
.home-container {
  height: 100%;
}
.el-header {
  background-color: #373d41;
  color: #fff;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 20px;
  padding-left: 5px;
  > div {
    display: flex;
    align-items: center;
    span {
      margin-left: 15px;
    }
    img {
      height: 30px;
    }
  }
}

.el-header button {
  margin-right: 0px;
}

.el-aside {
  background-color: #333744;
  color: #fff;
}

.el-main {
  background-color: #eaedf1;
}

.toggle-button {
  background-color: #4a5064;
  font-size: 10px;
  line-height: 24px;
  color: #fff;
  text-align: center;
  letter-spacing: 0.2em;
  cursor: pointer;
}
</style>
