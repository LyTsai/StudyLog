<template>
  <div>
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/home' }">Home</el-breadcrumb-item>
      <el-breadcrumb-item>User Management</el-breadcrumb-item>
      <el-breadcrumb-item>User List</el-breadcrumb-item>
    </el-breadcrumb>
    <!-- list -->
    <el-card>
      <!-- search and add -->
      <el-row :gutter="20">
        <el-col :span="8">
          <el-input placeholder="Input name" v-model="queryInfo.query" clearable @clear="getUserList">
            <template  #append>
              <el-button type="primary" :icon="Search" @click="getUserList">Search</el-button>
            </template>
          </el-input>
        </el-col>
        <el-col :span="4">
          <el-button type="primary" @click="addDialogVisible = true">Add User</el-button>
        </el-col>
      </el-row>
      <!-- table -->
       <!-- height="50" -->
      <el-table :data="userlist" border stripe>
        <el-table-column type="index"></el-table-column>
        <el-table-column label="Username" prop="username"></el-table-column>
        <el-table-column label="Name">
          <template #default="scope">{{scope.row.first_name}} {{scope.row.last_name}}</template>
        </el-table-column>
        <el-table-column label="Address" prop="address"></el-table-column>
        <el-table-column label="Profession" prop="profession"></el-table-column>
        <el-table-column label="Email" prop="email"></el-table-column>
        <el-table-column label="Cell" prop="cell"></el-table-column>
        <el-table-column label="Manage" width="135px">
          <template #default="scope">
            <!-- buttons -->
            <el-button type="primary" @click="editUser(scope.row._id)">Edit</el-button>
            <el-button type="danger" @click="removeUser(scope.row._id)">Delete</el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- paging -->
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange" :current-page="queryInfo.pagenum" :page-sizes="[1, 2, 5, 10]" :page-size="queryInfo.pagesize" layout="total, sizes, prev, pager, next, jumper" :total="total">
      </el-pagination>
    </el-card>
    <!-- addUser -->
    <el-dialog title="Add User" v-model="addDialogVisible" width="50%" @close="addDialogClosed">
      <!-- edit -->
      <el-form :model="addForm" :rules="addFormRules" ref="addFormRef" label-width="100px">
        <el-form-item label="Username" prop="username">
          <el-input v-model="addForm.username"></el-input>
        </el-form-item>
        <el-form-item label="Password" prop="password">
          <el-input v-model="addForm.password"></el-input>
        </el-form-item>
        <el-form-item label="Name" prop="name">
          <el-col :span="11">
            <el-input v-model="addForm.first_name" placeholder="first name"></el-input>
          </el-col>
          <el-col :span="2" class="text-center">
          </el-col>
          <el-col :span="11">
          <el-input v-model="addForm.last_name" placeholder="last name"></el-input>
        </el-col>
        </el-form-item>
        <el-form-item label="Address" prop="address">
          <el-input v-model="addForm.address" type="textarea"/>
        </el-form-item>
        <el-form-item label="Profession">
          <el-checkbox-group v-model="addForm.profession">
            <el-checkbox label = "Medical Professional" name="profession"></el-checkbox>
            <el-checkbox label = "Educator" name="profession"></el-checkbox>
            <el-checkbox label = "Reasearcher" name="profession"></el-checkbox>
          </el-checkbox-group>
        </el-form-item>
        <el-form-item label="Email" prop="email">
          <el-input v-model="addForm.email"></el-input>
        </el-form-item>
        <el-form-item label="Cell" prop="mobile">
          <el-input v-model="addForm.cell"></el-input>
        </el-form-item>
        <!-- bottom -->
        <el-form-item>
          <el-button @click="addDialogVisible = false">Cancel</el-button>
          <el-button type="primary" @click="addUser">Create</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
    <!-- delelte -->
  </div>
</template>
<script>
export default {
  data () {
    return {
      queryInfo: {
        query: '',
        pagenum: 1,
        pagesize: 10
      },
      userlist: [{
        _id: '12345',
        username: 'userOne',
        first_name: 'User',
        last_name: 'one',
        password: 'slowaging123',
        address: 'long long text to see',
        profession: ['a', 'b', 'c'],
        email: 'hello@163.com',
        cell: '1000000'
      }, {
        _id: '12ddd345',
        username: 'user2',
        first_name: 'User',
        last_name: '2',
        password: 'slowaging123d',
        profession: ['a', 'b'],
        email: 'hello@163.com'
      }, {
        _id: '1dsgad5',
        username: 'user2',
        first_name: 'User',
        last_name: '2',
        password: 'slowaging123d',
        profession: ['a', 'b'],
        email: 'hello@163.com'
      }, {
        _id: '1daggag5',
        username: 'user2',
        first_name: 'User',
        last_name: '2',
        password: 'slowaging123d',
        profession: ['a', 'b'],
        email: 'hello@163.com'
      }, {
        _id: '12dagdgae5',
        username: 'user2',
        first_name: 'User',
        last_name: '2',
        password: 'slowaging123d',
        profession: ['a', 'b'],
        email: 'hello@163.com'
      }, {
        _id: '12agadd345',
        username: 'user2',
        first_name: 'User',
        last_name: '2',
        password: 'slowaging123d',
        profession: ['a', 'b'],
        email: 'hello@163.com'
      }],
      addDialogVisible: false,
      addForm: {
        username: '',
        password: '',
        first_name: '',
        last_name: '',
        address: '',
        profession: [],
        email: '',
        cell: ''
      },
      addFormRules: {
        username: [
          { required: true, message: 'Input user name', trigger: 'blur' }
        ],
        password: [
          { required: true, message: 'Input user password', trigger: 'blur' }
        ]
      }
    }
  },
  methods: {
    fullname: function (id) {
      console.log(id)
    },
    getUserList: async function () {
      // const { data: res } = await this.$http.get('/weatherforecast')
      // if (res.meta.status !== 200) {
      //   console.log(res)

      //   return this.$message.error('Failed')
      // }
      // console.log(res)
      // this.userlist = res.data
      // await this.$http.get('/api/user')
      // const loginUrl = 'https://localhost:5001/api/user'
      // fetch(loginUrl, {
      //   method: 'get',
      //   headers: {
      //     'Content-Type': 'application/json'
      //     // Authorization: token
      //   }
      //   // , mode: 'no-cors'
      // }).then(response => {
      //   console.log(response)
      //   if (!response.ok) {
      //     throw new Error(response.status)
      //   }
      //   return response.json()
      // }).then(result => {
      // }).catch(error => {
      //   alert(error)
      // })
    },
    addUser: function () {

    },
    handleSizeChange: function (size) {
      this.queryInfo.pagesize = size
      this.getUserList()
    },
    handleCurrentChange: function (page) {
      this.queryInfo.pagenum = page
      this.getUserList()
    },
    editUser: function (id) {
      console.log(id)
    },
    removeUser: function (id) {

    },
    addDialogClosed: function () {
      this.$refs.addFormRef.resetFields()
    }
  },
  computed: {
    total: function () {
      return this.userlist.length
    }
  },
  created () {
    this.getUserList()
  }
}
</script>
<style lang="less" scoped>

</style>
