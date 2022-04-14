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
          <el-button type="primary" @click="addUserClicked">Add User</el-button>
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
        <el-table-column fixed="right" label="Operations" width="110">
          <template #default="scope">
            <!-- buttons -->
            <el-button type="text" size="small" @click="editUserClicked(scope.row._id)">Edit</el-button>
            <el-button type="text" size="small" @click="deleteUserClicked(scope.row._id)">Delete</el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- paging -->
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange" :current-page="queryInfo.pagenum" :page-sizes="[1, 2, 5, 10]" :page-size="queryInfo.pagesize" layout="total, sizes, prev, pager, next, jumper" :total="total">
      </el-pagination>
    </el-card>
    <!-- add or modify User -->
    <el-dialog :title="showForAdd ? 'Add User' : 'Modify User'" v-model="dialogVisible" width="50%" @close="dialogClosed" center>
      <!-- edit -->
      <el-form :model="addForm" :rules="addFormRules" ref="addFormRef" label-width="100px">
        <el-form-item label="Username" prop="username">
          <el-input v-model="addForm.username"></el-input>
        </el-form-item>
        <el-form-item label="Password" prop="password">
          <el-input v-model="addForm.password"></el-input>
        </el-form-item>
        <el-form-item label="Name">
          <el-col :span="11">
            <el-form-item prop="first_name">
             <el-input v-model="addForm.first_name" placeholder="first name"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="2" class="text-center">
          </el-col>
          <el-col :span="11">
            <el-form-item prop="last_name">
              <el-input v-model="addForm.last_name" placeholder="last name"></el-input>
            </el-form-item>
        </el-col>
        </el-form-item>
        <el-form-item label="Address" prop="address">
          <el-input v-model="addForm.address" type="textarea"/>
        </el-form-item>
        <el-form-item label="Profession" prop="profession">
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
          <el-button @click="dialogClosed">Cancel</el-button>
          <el-button type="primary" @click="confirmClicked">Confirm</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
    <!-- delelte -->
  </div>
</template>
<script>
import { getCurrentInstance, reactive, ref, unref } from 'vue'
export default {
  setup () {
    const queryInfo = reactive({
      query: '',
      pagenum: 1,
      pagesize: 10
    })

    const userlist = reactive([{
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
    }])
    const total = ref(0)
    // add form
    const addFormRef = ref()
    const showForAdd = ref(true)
    const userId = ref('')
    const dialogVisible = ref(false)
    const addForm = reactive({
      username: '',
      password: '',
      first_name: '',
      last_name: '',
      address: '',
      profession: [],
      email: '',
      cell: ''
    })
    // rules
    const checkEmail = (rule, value, cb) => {
      const regEmail = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-])+/
      if (regEmail.test(value)) {
        return cb()
      }
      cb(new Error('Please input a valid email address'))
    }
    const addFormRules = reactive({
      username: [
        { required: true, message: 'Input user name', trigger: 'blur' }
      ],
      password: [
        { required: true, message: 'Input user password', trigger: 'blur' }
      ],
      email: [
        // { message: 'Input a valid email address', trigger: 'blur' },
        { validator: checkEmail, trigger: 'blur' }
      ]
    })

    // page
    const handleSizeChange = (size) => {
      queryInfo.pagesize = size
      getUserList()
    }
    const handleCurrentChange = (page) => {
      queryInfo.pagenum = page
      getUserList()
    }
    // user buttons
    const editUserClicked = (id) => {
      showForAdd.value = false
      userId.value = id
      const user = getUserInfoByID(id).user
      addForm.username = user.username
      addForm.password = user.password
      addForm.first_name = user.first_name
      addForm.last_name = user.last_name
      addForm.address = user.address
      addForm.profession = user.profession
      addForm.email = user.email
      addForm.cell = user.cell
      dialogVisible.value = true
    }
    const { proxy } = getCurrentInstance()
    const deleteUserClicked = async (id) => {
      const confirmResult = await proxy.$confirm(
        'This User Will be deleted.',
        'Warning',
        {
          confirmButtonText: 'Confirm',
          cancelButtonText: 'Cancel',
          type: 'warning'
        }
      ).catch(error => error)
      if (confirmResult !== 'confirm') {
        // cancel
      } else {
        deleteUser(id)
      }
    }
    // dialog
    const addUserClicked = () => {
      addForm.username = ''
      addForm.password = ''
      addForm.first_name = ''
      addForm.last_name = ''
      addForm.address = ''
      addForm.profession = []
      addForm.email = ''
      addForm.cell = ''
      showForAdd.value = true
      dialogVisible.value = true
    }
    const dialogClosed = () => {
      dialogVisible.value = false
    }
    const confirmClicked = async () => {
      const form = unref(addFormRef)
      if (!form) return
      await form.validate((valid, fields) => {
        if (valid) {
          if (showForAdd.value) {
            addUser()
          } else {
            updateUser()
          }
        } else {
          console.log('error submit!', fields)
        }
      })
    }
    // api functions
    const getUserList = async () => {
      // const result = await proxy.$http.get('/api/user', {
      //   params: queryInfo
      // })
      // console.log(result)
      total.value = userlist.length
    }
    const addUser = async () => {
      // name used?
      // const add = await proxy.$http.post('/api/user', {
      //   params: addForm.value
      // })
      // console.log(add)
      addForm._id = userlist.length + 1
      userlist.push(addForm)
      getUserList()
      dialogClosed()
    }
    async function deleteUser (id) {
      // delete by id
      // const deleted = await proxy.$http.delele('/api/user', {
      //   params: {
      //     _id: id
      //   }
      // })
      // console.log(deleted)
      const index = getUserInfoByID(id).index
      userlist.splice(index, 1)
      getUserList()
    }

    function getUserInfoByID (id) {
      for (let index = 0; index < userlist.length; index++) {
        const element = userlist[index]
        if (element._id === id) {
          return {
            user: element,
            index: index
          }
        }
      }
    }
    function updateUser () {
      const id = unref(userId)
      const user = getUserInfoByID(id).user
      user.username = addForm.username
      user.password = addForm.password
      user.first_name = addForm.first_name
      user.last_name = addForm.last_name
      user.address = addForm.address
      user.profession = addForm.profession
      user.email = addForm.email
      user.cell = addForm.cell
      dialogVisible.value = true
    }
    return { queryInfo, userlist, total, showForAdd, userId, dialogVisible, addFormRef, addForm, addFormRules, handleSizeChange, handleCurrentChange, addUserClicked, editUserClicked, deleteUserClicked, dialogClosed, confirmClicked }
  }
}
</script>
<style lang="less" scoped>

</style>
