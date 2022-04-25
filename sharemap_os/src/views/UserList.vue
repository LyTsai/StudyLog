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
          <el-input placeholder="Input name" v-model="queryInfo.query" clearable @keyup.enter="getUserList" @clear="getUserList">
            <template  #append>
              <el-button type="primary" @click="getUserList">Search</el-button>
            </template>
          </el-input>
        </el-col>
        <el-col :span="4">
          <el-button type="primary" @click="addUserClicked">Add User</el-button>
        </el-col>
      </el-row>
      <!-- table -->
       <!-- height="50" -->
      <el-table :data="userlist" v-loading="listLoading" border stripe>
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
      <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange" :current-page="queryInfo.pagenum" :page-sizes="[5, 10, 15, 20]" :small=true :background=true :page-size="queryInfo.pagesize" layout="total, sizes, prev, pager, next, jumper" :total="total">
      </el-pagination>
    </el-card>
    <!-- add or modify User -->
    <el-dialog :title="addForm._id === '' ? 'Add User' : 'Modify User'" v-model="dialogVisible" width="50%" @close="dialogClosed" v-loading="formLoading">
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
  </div>
</template>
<script>
import { getCurrentInstance, onMounted, reactive, ref, unref } from 'vue'

export default {
  setup () {
    const listLoading = ref(false)
    const formLoading = ref(false)

    const queryInfo = reactive({
      query: '',
      pagenum: 1,
      pagesize: 10
    })

    const userlist = ref()
    const total = ref(0)
    // add form
    const addFormRef = ref()
    const dialogVisible = ref(false)
    const addForm = reactive({
      _id: '',
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
      const user = getUserInfoByID(id)
      addForm._id = user._id
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
      if (confirmResult === 'confirm') {
        deleteUser(id)
      }
    }
    // dialog
    const addUserClicked = () => {
      addForm._id = ''
      addForm.username = ''
      addForm.password = ''
      addForm.first_name = ''
      addForm.last_name = ''
      addForm.address = ''
      addForm.profession = []
      addForm.email = ''
      addForm.cell = ''

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
          // no id
          if (addForm._id === '') {
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
      listLoading.value = true
      try {
        const result = await proxy.$http.get('/api/userByPage', {
          params: queryInfo
        })
        listLoading.value = false
        // get list
        if (result.status === 200) {
          userlist.value = result.data.data
          total.value = result.data.total
        }else {
          alert('Failed to load users:' + result.message)
        }
      } catch (error) {
        listLoading.value = false
        alert('Failed to load users:' + error)
      }
    }
    async function addUser() {
      // name used?
      formLoading.value = true
      try {
        let upload = addForm
        delete upload._id

        const add = await proxy.$http.post('/api/user', upload)
        formLoading.value = false
        if (add.status == 201) {
          getUserList()
          dialogClosed()
        } else {
          // alert
          alert('Failed to add user:' + add.message)
        }
      } catch (error) {
        console.log('here??')
        alert('Failed to add user:' + error)
      }
    }
    // update
    async function updateUser () {
      formLoading.value = true
      try {
        const update = await proxy.$http.put('/api/user', addForm)
        formLoading.value = false
        if (update.status == 200) {
          getUserList()
          dialogVisible.value = false
        } else {
          alert('Failed to update user:' + error)
        }
      } catch (error) {
        formLoading.value = false
        alert('Failed to update user:' + error)
      }
    }
    // delete
    async function deleteUser (id) {
      // delete by id
      try {
        const deleted = await proxy.$http.delete('/api/user', {
          params: {
            id: id
          }
        })
        if (deleted.status == 200) {
          getUserList()
        } else {
          // alert
          alert('Failed to delete user:' + add.message)
        }
      } catch (error) {
        alert('Failed to delete user:' + error)
      }
    }
    // user model
    function getUserInfoByID (id) {
      let users = unref(userlist)
      for (let index = 0; index < users.length; index++) {
        const element = users[index]
        if (element._id === id) {
          return element
        }
      }
    }
    onMounted(() => {
      getUserList()
    })

    return { listLoading, formLoading, queryInfo, userlist, total, getUserList, dialogVisible, addFormRef, addForm, addFormRules, handleSizeChange, handleCurrentChange, addUserClicked, editUserClicked, deleteUserClicked, dialogClosed, confirmClicked }
  }
}


// axios

</script>
<style lang="less" scoped>

</style>
