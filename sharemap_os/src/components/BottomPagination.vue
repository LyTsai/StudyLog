<template>
  <el-pagination
  @size-change="handleSizeChange"
  @current-change="handleCurrentChange"
  :current-page="queryInfo.pagenum"
  :page-sizes="[5, 10, 15]"
  :page-size="queryInfo.pagesize"
  layout="total, sizes, prev, pager, next, jumper"
  :total="total">
</template>

<script>
export default {
  name: 'bottom-pagination',
  props: {
    
  }
}
</script>

<style>

</style>