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
      <el-table :data="visualList" border stripe>
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
    <!-- add or modify User -->
    <el-dialog :title="showForAdd ? 'Add Visual' : 'Modify Visual'" v-model="dialogVisible" width="50%" @close="dialogClosed" center>
      <!-- edit -->
      <el-form :model="visualForm" :rules="visualFormRules" ref="visualFormRef" label-width="100px">
        <el-form-item label="Title" prop="title">
          <el-input v-model="visualForm.title"></el-input>
        </el-form-item>
        <el-form-item label="Abstract" prop="abstract">
          <el-input v-model="visualForm.abstract"></el-input>
        </el-form-item>
        <el-form-item label="Keywords" prop="keywords">
          <el-tag v-for="(tag, index) in visualForm.keywords" :key="tag" class="mx-1" closable :disable-transitions="false" @close="handleClose(index)">{{ tag }}</el-tag>
          <el-input v-if="inputVisible" ref="InputRef" v-model="inputValue" class="ml-1 w-20" size="small" @keyup.enter="handleInputConfirm" @blur="handleInputConfirm"/>
          <el-button v-else class="button-new-tag ml-1" size="small" @click="showInput"> + New Keyword </el-button>
        </el-form-item>
        <el-form-item label="Subject" prop="subject">
          <el-input v-model="visualForm.subject"></el-input>
        </el-form-item>
        <el-form-item label="Text" prop="text">
          <el-input v-model="visualForm.text" type="textarea"/>
        </el-form-item>
        <el-form-item label="URL" prop="url">
          <el-input v-model="visualForm.url"></el-input>
        </el-form-item>
        <el-form-item label="URL scancode" prop="url_scancode">
          <el-input v-model="visualForm.url_scancode"></el-input>
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
import { getCurrentInstance, reactive, ref, nextTick } from 'vue'
export default {
  setup () {
    const queryInfo = reactive({
      query: '',
      pagenum: 1,
      pagesize: 10
    })
    // page
    // const handleSizeChange = (size) => {
    //   queryInfo.pagesize = size
    //   getUserList()
    // }
    // const handleCurrentChange = (page) => {
    //   queryInfo.pagenum = page
    //   getUserList()
    // }
    // data
    const visualList = reactive([{
      _id: '62390bb33528d814d2c384d5',
      user_id: '62352300fe3ca8f02b47f2a6',
      title: 'vitD',
      abstract: 'poster card about vitD',
      subject: 'vitD',
      keywords: ['vtD', 'lifestyle', 'diabetes'],
      text: 'the detailed text here',
      url: 'url poiting to the html page',
      url_scancode: 'url pointing to the scan code.  internal data field.'
    }])

    const visualForm = reactive({
      title: '',
      abstract: '',
      keywords: [],
      subject: '',
      text: '',
      url: '',
      url_scancode: ''
      // categories: [],
      // forwarded: 0,
      // likes: 0,
      // user_id: ''
    })
    // dialog
    const visualFormRef = ref('')
    const visualFormRules = {

    }
    const dialogVisible = ref(false)
    const showForAdd = ref(true)
    const visualId = ref('')
    // methods
    const getVisualList = () => {
      // load...
    }
    // tag
    const inputValue = ref('')
    const inputVisible = ref(false)
    const InputRef = ref()

    const handleClose = (index) => {
      visualForm.keywords.splice(index, 1)
    }

    const showInput = () => {
      inputVisible.value = true
      nextTick(() => {
        InputRef.value.input.focus()
      })
    }

    const handleInputConfirm = () => {
      if (inputValue.value) {
        visualForm.keywords.push(inputValue.value)
      }
      inputVisible.value = false
      inputValue.value = ''
    }

    // data action
    const { proxy } = getCurrentInstance()
    const addVisualClicked = () => {
      visualForm.title = ''
      visualForm.abstract = ''
      visualForm.keywords = []
      visualForm.subject = ''
      visualForm.text = ''
      visualForm.url = ''
      visualForm.url_scancode = ''
      showForAdd.value = true
      dialogVisible.value = true
    }

    const editClicked = (id) => {
      showForAdd.value = false
      visualId.value = id
      // assign
      const visual = getVisualByID(id).visual
      visualForm.title = visual.title
      visualForm.abstract = visual.abstract
      visualForm.keywords = visual.keywords
      visualForm.subject = visual.subject
      visualForm.text = visual.text
      visualForm.url = visual.url
      visualForm.url_scancode = visual.url_scancode
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
      if (showForAdd.value) {
        // add
        addVisual()
      } else {
        // modify
        modifyVisual()
      }
    }

    function modifyVisual () {
      // modify
      const visual = getVisualByID(visualId.value).visual
      visual.title = visualForm.title
      visual.abstract = visualForm.abstract
      visual.keywords = visualForm.keywords
      visual.subject = visualForm.subject
      visual.text = visualForm.text
      visual.url = visualForm.url
      visual.url_scancode = visualForm.url_scancode
      dialogClosed()
    }

    function addVisual () {
      visualList.push(visualForm)
      dialogClosed()
    }
    function deleteVisual (id) {
      const index = getVisualByID(id).index
      visualList.splice(index, 1)
    }

    function getVisualByID (id) {
      for (let index = 0; index < visualList.length; index++) {
        const element = visualList[index]
        if (element._id === id) {
          return {
            visual: element,
            index: index
          }
        }
      }
    }

    return { queryInfo, visualList, visualForm, visualFormRef, visualFormRules, dialogVisible, getVisualList, addVisualClicked, editClicked, deleteClicked, dialogClosed, confirmDialog, inputVisible, inputValue, InputRef, handleClose, showInput, handleInputConfirm }
  }
}
</script>
<style lang="less" scoped>
.mx-1 {
  margin-right: 5px;
}
</style>
