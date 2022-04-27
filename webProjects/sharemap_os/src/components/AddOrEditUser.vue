<template>
     <el-dialog :title="showForAdd ? 'Add User' : 'Modify User'" v-model="dialogVisible" width="50%" @close="dialogClosed">
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
</template>

<script>
export default {
  name: 'AddOrEditUser',
  props: {
    
  }
}
</script>

<style>

</style>