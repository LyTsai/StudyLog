<template>
  <div>
    <el-breadcrumb separator-class="el-icon-arrow-right">
      <el-breadcrumb-item :to="{ path: '/home' }">Home</el-breadcrumb-item>
      <el-breadcrumb-item>Visuals</el-breadcrumb-item>
      <el-breadcrumb-item>Visual List</el-breadcrumb-item>
    </el-breadcrumb>
    <el-card>
      <!-- search and add -->
      <el-row :gutter="20">
        <el-col :span="8">
          <el-input placeholder="Input title" v-model="queryInfo.query" clearable @clear="getVisualList">
            <template #append>
              <el-button type="primary" :icon="Search" @click="getVisualList">Search</el-button>
            </template>
          </el-input>
        </el-col>
        <el-col :span="4">
          <el-button type="primary" @click="addVisualClicked">Add Visual</el-button>
        </el-col>
      </el-row>
      <!-- table -->
       <!-- height="50" -->
      <el-table :data="visualList" v-loading="listLoading" border stripe>
        <el-table-column type="index"></el-table-column>
        <el-table-column label="Title" prop="title"></el-table-column>
        <el-table-column label="Abstract" prop="abstract"></el-table-column>
        <el-table-column label="Keywords" prop="keywords"></el-table-column>
        <el-table-column label="Subject" prop="subject"></el-table-column>
        <el-table-column label="Text" prop="text"></el-table-column>
        <el-table-column label="Url" prop="url"></el-table-column>
        <el-table-column label="Url_scancode" prop="url_scancode"></el-table-column>
        <el-table-column fixed="right" label="Operations" width="110">
          <template #default="scope">
            <!-- buttons -->
            <el-button type="text" size="small" @click="editClicked(scope.row._id)">Edit</el-button>
            <el-button type="text" size="small" @click="deleteClicked(scope.row._id)">Delete</el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- paging -->
      <!-- <el-pagination @size-change="handleSizeChange" @current-change="handleCurrentChange" :current-page="queryInfo.pagenum" :page-sizes="[1, 2, 5, 10]" :page-size="queryInfo.pagesize" layout="total, sizes, prev, pager, next, jumper" :total="total">
      </el-pagination> -->
    </el-card>
    <!-- add or modify visual -->
    <el-dialog :title="addForm._id === '' ? 'Add Visual' : 'Modify Visual'" v-model="dialogVisible" width="50%" @close="dialogClosed" v-loading="formLoading" center>
      <!-- edit -->
      <el-form :model="addForm" :rules="visualFormRules" ref="visualFormRef" label-width="100px">
        <el-form-item label="Title" prop="title">
          <el-input v-model="addForm.title"></el-input>
        </el-form-item>
        <el-form-item label="Abstract" prop="abstract">
          <el-input v-model="addForm.abstract"></el-input>
        </el-form-item>
        <el-form-item label="Keywords" prop="keywords">
          <el-tag v-for="(tag, index) in addForm.keywords" :key="tag" class="mx-1" closable :disable-transitions="false" @close="handleClose(index)">{{ tag }}</el-tag>
          <el-input v-if="inputVisible" ref="InputRef" v-model="inputValue" class="ml-1 w-20" size="small" @keyup.enter="handleInputConfirm" @blur="handleInputConfirm"/>
          <el-button v-else class="button-new-tag ml-1" size="small" @click="showInput"> + New Keyword </el-button>
        </el-form-item>
        <el-form-item label="Subject" prop="subject">
          <el-input v-model="addForm.subject"></el-input>
        </el-form-item>
        <el-form-item label="Text" prop="text">
          <el-input v-model="addForm.text" type="textarea"/>
        </el-form-item>
        <el-form-item label="URL" prop="url">
          <el-input v-model="addForm.url"></el-input>
        </el-form-item>
        <el-form-item label="URL scancode" prop="url_scancode">
          <el-input v-model="addForm.url_scancode"></el-input>
        </el-form-item>
        <el-form-item>
          <el-select v-model="user" filterable placeholder="User">
            <el-option
              v-for="item in userList"
              :key="item.value"
              :label="item.label"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <!-- bottom -->
        <el-form-item>
          <el-button @click="dialogClosed">Cancel</el-button>
          <el-button type="primary" @click="confirmDialog">Confirm</el-button>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>
<script>
import { getCurrentInstance, reactive, ref, unref, nextTick, onMounted } from 'vue'
export default {
  setup () {
    const listLoading = ref(false)
    const formLoading = ref(false)
    
    const queryInfo = reactive({
      query: '',
      pagenum: 1,
      pagesize: 10
    })
    // page
    // const handleSizeChange = (size) => {
    //   queryInfo.pagesize = size
    //   getVisualList()
    // }
    // const handleCurrentChange = (page) => {
    //   queryInfo.pagenum = page
    //   getVisualList()
    // }
    // data
    const visualList = ref()
    const addForm = reactive({
      _id: '',
      title: '',
      abstract: '',
      keywords: [],
      subject: '',
      text: '',
      url: '',
      url_scancode: '',
      // categories: [],
      // forwarded: 0,
      // likes: 0,
      visual_id: ''
    })
    // dialog
    const visualFormRef = ref('')
    const visualFormRules = {
  
    }
    const dialogVisible = ref(false)
// const user = ref('') 
// const userList = [
//   {
//     value: 'Option1',
//     label: 'Option1',
//   },
//   {
//     value: 'Option2',
//     label: 'Option2',
//   }
// ]

    // tag
    const inputValue = ref('')
    const inputVisible = ref(false)
    const InputRef = ref()

    const handleClose = (index) => {
      addForm.keywords.splice(index, 1)
    }

    const showInput = () => {
      inputVisible.value = true
      nextTick(() => {
        InputRef.value.input.focus()
      })
    }

    const handleInputConfirm = () => {
      if (inputValue.value) {
        addForm.keywords.push(inputValue.value)
      }
      inputVisible.value = false
      inputValue.value = ''
    }

    // data action
    const { proxy } = getCurrentInstance()
    const addVisualClicked = () => {
      addForm.title = ''
      addForm.abstract = ''
      addForm.keywords = []
      addForm.subject = ''
      addForm.text = ''
      addForm.url = ''
      addForm.url_scancode = ''
 
      dialogVisible.value = true
    }

    const editClicked = (id) => {
      // assign
      const visual = getVisualByID(id)
      addForm.title = visual.title
      addForm.abstract = visual.abstract
      addForm.keywords = visual.keywords
      addForm.subject = visual.subject
      addForm.text = visual.text
      addForm.url = visual.url
      addForm.url_scancode = visual.url_scancode
      // show
      dialogVisible.value = true
    }

    const deleteClicked = async (id) => {
      const confirmResult = await proxy.$confirm(
        'This Visual Will be deleted.',
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
        deleteVisual(id)
      }
    }

    const dialogClosed = () => {
      dialogVisible.value = false
    }

    const confirmDialog = () => {
      // validate?
      if (addForm._id === '') {
        // add
        addVisual()
      } else {
        // modify
        modifyVisual()
      }
    }
   // api functions
    const getVisualList = async () => {
      listLoading.value = true
      try {
        const result = await proxy.$http.get('/api/visual')
        listLoading.value = false
        console.log(result)
        // get list
        if (result.status === 200) {
          visualList.value = result.data
          // total.value = result.data.total
        }else {
          alert('Failed to load visuals' + result.message)
        }
      } catch (error) {
        listLoading.value = false
        alert('Failed to load visuals' + error)
      }
    }
    async function addVisual () {
      // url used?
      formLoading.value = true
      try {
        let upload = addForm
        delete upload._id

        const add = await proxy.$http.post('/api/visual', upload)
        formLoading.value = false
        if (add.status == 201) {
          getVisualList()
          dialogClosed()
        } else {
          // alert
          alert('Failed to add visual:' + add.message)
        }
      } catch (error) {
        console.log('here??')
        alert('Failed to add visual:' + error)
      }
    }
    // update
    async function modifyVisual () {
      formLoading.value = true
      try {
        const update = await proxy.$http.put('/api/visual', addForm)
        formLoading.value = false
        if (update.status == 200) {
          getVisualList()
          dialogVisible.value = false
        } else {
          alert('Failed to update visual:' + error)
        }
      } catch (error) {
        formLoading.value = false
        alert('Failed to update visual:' + error)
      }
    }
    // delete
    async function deleteVisual (id) {
      // delete by id
      try {
        const deleted = await proxy.$http.delete('/api/visual', {
          params: {
            id: id
          }
        })
        if (deleted.status == 200) {
          getVisualList()
        } else {
          // alert
          alert('Failed to delete visual:' + add.message)
        }
      } catch (error) {
        alert('Failed to delete visual:' + error)
      }
    }
    // visual model
    function getVisualByID (id) {
      let visuals = unref(visualList)
      for (let index = 0; index < visuals.length; index++) {
        const element = visuals[index]
        if (element._id === id) {
          return element
        }
      }
    }
    onMounted(() => {
      getVisualList()
    })

    return { listLoading, formLoading, queryInfo, visualList, addForm, visualFormRef, visualFormRules, dialogVisible, getVisualList, addVisualClicked, editClicked, deleteClicked, dialogClosed, confirmDialog, inputVisible, inputValue, InputRef, handleClose, showInput, handleInputConfirm }
  }
}
</script>
<style lang="less" scoped>
.mx-1 {
  margin-right: 5px;
}
</style>
